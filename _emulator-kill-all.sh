#!/usr/bin/env bash

adb devices | grep "emulator-" | while read -r line ; do
    suffix="	device"
    emulatorInstanceName=${line%${suffix}}

    echo "Killing $emulatorInstanceName"
    adb -s ${emulatorInstanceName} emu kill
done
