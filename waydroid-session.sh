# weston --xwayland &
# export WAYLAND_DISPLAY=wayland-1
# sleep 2
# waydroid show-full-ui &

#!/bin/bash

# Ensure the script is run from its directory
cd "$(dirname "$0")"

start_waydroid() {
    weston --xwayland --scale=1 --width=2240 --height=1400 &
    WESTON_PID=$!
    export WAYLAND_DISPLAY=wayland-0
    sleep 2
    waydroid show-full-ui &
    WAYDROID_PID=$!

   sleep 15

   adb shell am start -n com.xiaomi.smarthome/.SmartHomeMainActivity
   #  adb install /home/satevg/Dev/use-waydroid-on-x11/AuroraStore-4.7.0.apk
}

stop_waydroid() {
    # Stop Waydroid session
    waydroid session stop

    # Kill Weston
    if [ -n "$WESTON_PID" ]; then
        kill $WESTON_PID
    else
        killall weston
    fi

    # Ensure Waydroid is stopped
    if [ -n "$WAYDROID_PID" ]; then
        kill $WAYDROID_PID 2>/dev/null
    fi
    killall waydroid 2>/dev/null
}

# Start Waydroid
start_waydroid

# Wait for Weston to exit
wait $WESTON_PID

# When Weston exits, stop the session
stop_waydroid
