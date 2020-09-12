# usage
# ~/rtlsdr/satellite_weather/capture.sh <satellite> <duration in minutes> <rtlsdr index> <N or S>
# echo "~/rtlsdr/satellite_weather/capture.sh 18 13 0 N" | at 9:39am

case $1 in
  "15") FREQUENCY=137.62M ;;
  "18") FREQUENCY=137.9125M ;;
  "19") FREQUENCY=137.1M ;;
  *) echo "No known frequency for NOAA-$1."; exit 1 ;;
esac

DATESTAMP=`date +%Y-%m-%d`
TIMESTAMP=`date +%y%m%d%H%M`
OUTDIR=/tank/archive/satellite-samples/$DATESTAMP
FILENAME=$TIMESTAMP-NOAA-$1-dev$3_$4
mkdir -p $OUTDIR

# add gain setting to rtl_fm if needed
# -g 43
timeout $2m rtl_fm -d $3 -f $FREQUENCY -s 44100 -F 9 -E dc -p 0 $OUTDIR/$FILENAME.raw
