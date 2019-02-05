#!/usr/bin/env bash

if [ -z ${1+x} ];
then echo "No AVD name is specified. Powering on AVD Carl_Sagan by default";
emulatorName="Carl_Sagan";
else
emulatorName=$1;
fi

if avdmanager list avd | grep ${emulatorName}
then
   echo "Found AVD '$emulatorName'. Proceeding to launch it";
else
   echo "Error: Failed to find any such emulator: '$emulatorName'";
   echo "Error: Please create an AVD labeled '$emulatorName'";
   echo "Or invoke an AVD from your available AVDs"
   echo "Here's a list of your available AVDs:"
   echo "------------------"
   emulator -list-avds
   echo "------------------"
   exit 1
fi

#echo 'Searching for device...'
#devicesCount=`adb devices | grep -c emulator`
#if [[ $devicesCount =~ 0 ]]; then
#  echo 'launching emulator'
#  $ANDROID_HOME/emulator/emulator -netdelay hscsd -netspeed hscsd -avd ${emulatorName} &
#fi

$ANDROID_HOME/emulator/emulator -netdelay hscsd -netspeed hscsd -avd ${emulatorName} &


#wait for emulator to get ready

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 1
done

echo "AVD is online"