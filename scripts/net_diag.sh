#!/bin/bash
# Network diagnostics for the emulator (waits up to 60s for internet before the app is launched).
for i in $(seq 1 20); do
  if adb shell ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then echo "NET_PING_8888=ok after ${i} tries"; break; fi
  sleep 3
done
echo "NET_PING_HOST=$(adb shell ping -c 1 -W 3 saifalmajd.web.app 2>&1 | tail -2 | tr '\n' ' ')"
echo "NET_VALIDATED=$(adb shell dumpsys connectivity 2>/dev/null | grep -c 'VALIDATED')"
echo "HOST_HTTP=$(curl -s -o /dev/null -w '%{http_code}' https://saifalmajd.web.app/)"
