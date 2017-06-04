# ServoCap

An 3D-printed automated cap for small telescopes driven by an
[Arduino Nano](https://www.arduino.cc/en/Main/ArduinoBoardNano).

The ServoCap can be controlled from KStars using the
[indiduino driver](https://indiduino.wordpress.com/).

## Installation instructions

You'll have to copy the provided file `servo_cap.xml` into `/usr/share/indi/`
and add a new `<device>` section to `/usr/share/indi/indi_duino.xml`.
