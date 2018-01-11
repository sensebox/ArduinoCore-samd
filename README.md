# senseBox MCU Arduino Core Board Support Package [![Build Status](https://travis-ci.org/sensebox/arduino-senseBoxCore.svg?branch=master)](https://travis-ci.org/sensebox/arduino-senseBoxCore)

This repository contains the Board Support Package for the senseBox MCU required to compile Arduino sketches in [Arduino IDE v1.8+](https://www.arduino.cc/en/Main/Software).

To install the core in your Arduino IDE:

  1. Open the **Preferences** of the Arduino IDE.
  1. Add this URL `https://sensebox.github.io/arduino-senseBoxCore/package_sensebox_index.json` in the **Additional Boards Manager URLs** field, and click OK.
  1. Open the **Boards Manager** (menu Tools->Board->Board Manager...)
  1. Install **senseBox MCU Board Core**
  1. Select the **senseBox MCU** board under **senseBox** in Tools->Board menu
  1. Connect your senseBox MCU through USB
  1. Compile/Upload as usual

## Features

* [Microchip ATSAMD21](http://www.microchip.com/wwwproducts/en/ATSAMD21G18) ARM Cortex-M0+ Microcontroller
* [Microchip ATECC608A](http://www.microchip.com/wwwproducts/en/ATECC608A) Crypto Authentication
* [Bosch BMX055](https://www.bosch-sensortec.com/bst/products/all_products/bmx055) Orientation Sensor (Accelerometer + Gyroscope + Magnetometer)
* USB CDC+MSC Bootloader (Arduino compatible)
* XBee compatible sockets with UART and SPI
* 5V tolerant IOs, UART, I2C

## Hardware and Software

* [Schematics + Layout](https://github.com/watterott/SenseBox-MCU/tree/master/hardware) (External link)
* [Board Support Package for Arduino IDE](https://github.com/sensebox/arduino-senseBoxCore/)

## Try changes locally

This only works on linx!

1. `./extras/pack.release.bash`
1. `./extras/test.release.bash prepareJson`
1. If you have the current version already installed, delete the folder `~/.arduino15/packages/senseBox`
1. Run `arduino --pref "boardsmanager.additional.urls=file:///home/your-user/arduino-senseBoxCore/package_sensebox_index.json" --install-boards "senseBox:samd:${VERSION}"`

## Releasing a new version

Make sure there isn't already a release with this version on Github! The release provider will not overwrite the release but force push the json resulting in different crc values of the actual archive file and in the json!

1. Commit all of your changes
1. Increase the version in `platform.txt`
1. Try to build locally `./extras/pack.release.bash`
1. Run `./extras/pack.release.bash commitAndTag`
1. Run `git push origin <NEW_VERSION> master`
1. Travis CI will take over to:
    * Create the archive
    * Try to compile a basic sketch
    * Create a release containing the archive
    * Update the `package_sensebox_index.json` on the `gh-pages` branch

## Sources

[https://downloads.arduino.cc/packages/package_index.json](https://downloads.arduino.cc/packages/package_index.json)
[https://github.com/watterott/SAM-BAR](https://github.com/watterott/SAM-BAR/tree/67850505de43aa24ca12c3899b9348745af7809d)
[https://github.com/watterott/SenseBox-MCU](https://github.com/watterott/SenseBox-MCU)
[https://github.com/arduino/ArduinoCore-samd](https://github.com/arduino/ArduinoCore-samd)

## Changes made to the original Arduino Core for SAMD21 CPU

* Extended the `extras/pack.release.bash` file to create and deploy JSON and package to Github pages
* Replaced files in `bootloaders`, `drivers`and `variants` from with senseBox Board stuff from watterott/SenseBox-MCU
* Added senseBoxIO library to `libraries`
* Replaced `boards.txt` with senseBox Board definitions from watterott/SenseBox-MCU
* Changed `version` and `name` fields in `platform.txt`

## License and credits

This core is based on work by Arduino LL, Atmel and Watterott.

License for parts by Arduino LLC

    Copyright (c) 2015 Arduino LLC.  All right reserved.

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
