pushd ${1:-/tank/archive/satellite-samples/`date +%Y-%m-%d`}
for f in *.raw; do
    FILENAME=`echo $f | sed s/\.raw$//`
    TIMESTAMP=`echo $f | cut -c 1-10`

    if [[ $FILENAME == *-NOAA-15-* ]]; then
        SATELLITE="noaa_15"
    elif [[ $FILENAME == *-NOAA-18-* ]]; then
        SATELLITE="noaa_18"
    elif [[ $FILENAME == *-NOAA-19-* ]]; then
        SATELLITE="noaa_19"
    else
        echo "Unknown satellite."
        continue
    fi

    rm -f $FILENAME.wav $FILENAME.png

    EPOCH=`stat -c %y $FILENAME.raw`
    RFC3339=`date -d "$EPOCH + 5 hours" --rfc-3339=seconds | sed s/\ /T/`
    echo "Processing $FILENAME (timestamp $TIMESTAMP, rfc3339 $RFC3339, satellite $SATELLITE)"

    sox -t raw -r 44100 -es -b16 -c1 -V1 $FILENAME.raw $FILENAME.wav rate 11025
    TZ='UTC' touch -t $TIMESTAMP $FILENAME.raw
    TZ='UTC' touch -t $TIMESTAMP $FILENAME.wav

    ROTATE="no"
    if [[ $FILENAME == *_N ]]; then
        ROTATE="yes"
    fi

    noaa-apt $FILENAME.wav -o $FILENAME.png --contrast 98_percent --map yes --rotate $ROTATE --sat $SATELLITE --start-time $RFC3339 &
    pids[${FILENAME}]=$!
    echo "----"
done

for pid in ${pids[*]}; do
    wait $pid
done

popd
