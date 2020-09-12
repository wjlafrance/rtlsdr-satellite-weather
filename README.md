# NOAA APT Imagery

These are my scripts for capturing NOAA [automatic picture transmission (APT)](https://en.wikipedia.org/wiki/Automatic_picture_transmission) imagery.

### Links

- [noaa-apt](https://noaa-apt.mbernardi.com.ar/) is the main software used for decoding images.
- [wxtoimg](https://wxtoimgrestored.xyz/), legacy / abandonware software used for decoding images, and I still use it to get my satellite pass schedule. [A redditor](https://www.reddit.com/r/RTLSDR/comments/6qlgtt/wxtoimg_license_info_no_longer_working/dl0g6en/) has posted licensing information.
- [RTL-SDR Blog's recommended dongle](https://www.amazon.com/dp/B0129EBDS2), this is the actual radio receiver used to turn RF signals into the `.raw` audio files later processed.
- [RTL-SDR Blog dipole antenna kit](https://www.amazon.com/dp/B075445JDF), the antenna I'm currently using.
- [Instructable for building a QFH antenna from PVC, copper, and coax](https://www.instructables.com/id/NOAA-Satellite-Signals-with-a-PVC-QFH-Antenna-and-/), the antenna I'm currently building.

### Scheduling

Generally, there can be up to 12 satellite passes per day, two each of NOAA-15, -18, and -19, in the morning and evening. Sometimes one or more of these passes will not be visible in your location. Obtain a satellite pass list for your location from `wxtoimg -G` (be sure to update keplers first!), and schedule the pass recording using `at` as exampled in `scrach.txt`.

Since `at` cannot schedule down to the second, I start my recordings at the top of the minute a satellite appears, and add two minutes to the duration. Note that passes of two satellites can overlap, so you may need to cut a recording short to free your radio for the next one.

### Processing

I use `.raw` captures as the main source file, and `process.sh` will process each `.raw` file in a directory, deleting any `.wav` and `.png` representations and remaking them. Throughout the day I run `./process.sh /tank/archive/satellite-samples/2020-09-11` to process images for viewing.

There seems to be a bug in `noaa-apt` where you need to do a decode in the GUI program at least daily or locations will be entirely wrong. Open `noaa-apt` in GUI mode and decode a `.wav` file, close `noaa-apt`, and re-run `./process.sh`.

### TODO

- `.raw` captures are very large. Now that I have confidence in my decoding pipeline, `capture.sh` should convert the `.raw` to `.wav` with `sox` and `process.sh` should use the `.wav` as its main source file.

- Add a script for parsing either the pass list from `wxtoimg -G` or for building a pass list from another API.