#!/usr/bin/env bash

echo "** KILLING EXISTING EMULATORS **"
sh _emulator-kill-all.sh &
sleep 5s
echo "** DONE KILLING EMULATORS **"

cd $CA
git fetch
sleep 15s
git checkout espresso-refector-onboarding
sleep 2s

cd $TO
git fetch
sleep 15s
git checkout ca_config
sleep 2s

cd $UTILS
git fetch
sleep 10s

echo "** RE-LAUNCHING EMULATORS **"
echo "Launching emulator Carl_Sagan"
./_emulator-launch.sh Carl_Sagan &
sleep 15s
#echo "Launching emulator Sam_Harris"
#./_emulator-launch.sh Sam_Harris &
#sleep 15s
echo "** DONE LAUNCHING EMULATORS **"

echo "Build and launch consumer droid sanity"
cd $TO
python3 ./Launcher.py -tset AllSanity -lplan reBuild
