#!/bin/bash
# Installs the CI-signed RELEASE apk, launches it and screenshots it. Optional second arg "back":
# portfolio navigation test using accessibility nodes (no guessed coordinates).
PKG="$1"; MODE="$2"; mkdir -p shots
adb uninstall "$PKG" >/dev/null 2>&1
adb install -r build/app/outputs/flutter-apk/app-release-ci.apk || { echo "::error::release install failed"; exit 1; }
adb logcat -c
adb shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
foc(){ adb shell dumpsys window 2>/dev/null | grep -m1 mCurrentFocus | tr -d '\r' | sed 's/.*u0 //' | cut -c1-110; }
dump(){ adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; adb shell cat /sdcard/u.xml | tr '>' '\n' | grep -o 'text="[^"]\+"[^/]*bounds="[^"]*"\|content-desc="[^"]\+"[^/]*bounds="[^"]*"' | sed 's/class="[^"]*"//;s/resource-id="[^"]*"//' | cut -c1-160 | head -${1:-40}; }
sleep 20; adb exec-out screencap -p > shots/rel_1.png
echo "REL focus=$(foc) pid=$(adb shell pidof $PKG | tr -d '\r')"
if [ "$MODE" = back ]; then
  echo "REL nodes:"; dump 40
  B=$(adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; adb shell cat /sdcard/u.xml | tr '>' '\n' | grep -i "talk" | grep -o 'bounds="\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]"' | head -1)
  echo "REL talk_bounds=$B"
  if [ -n "$B" ]; then
    adb shell input swipe 160 450 160 150 300; sleep 2; adb exec-out screencap -p > shots/rel_2.png
    echo "REL scrolled nodes:"; dump 25
    B2=$(adb shell uiautomator dump /sdcard/u.xml >/dev/null 2>&1; adb shell cat /sdcard/u.xml | tr '>' '\n' | grep -i "talk" | grep -o 'bounds="\[[0-9]*,[0-9]*\]\[[0-9]*,[0-9]*\]"' | head -1)
    echo "REL talk_bounds_after_scroll=$B2"
    python3 - "$B2" > /tmp/xy.txt <<'PY'
import re,sys
m=re.findall(r'\d+',sys.argv[1])
print((int(m[0])+int(m[2]))//2, (int(m[1])+int(m[3]))//2) if len(m)==4 else print("")
PY
    XY=$(cat /tmp/xy.txt); echo "REL tap_xy=$XY"
    if [ -n "$XY" ]; then adb shell input tap $XY; sleep 6; adb exec-out screencap -p > shots/rel_3.png; echo "REL after tap focus=$(foc)"; fi
  fi
  adb shell input keyevent 4; sleep 4; adb exec-out screencap -p > shots/rel_4.png
  echo "REL after back1 focus=$(foc) pid=$(adb shell pidof $PKG | tr -d '\r')"
fi
adb logcat -d > shots/rel_logcat.txt 2>/dev/null
echo "REL_FATAL=$(grep -c 'FATAL EXCEPTION' shots/rel_logcat.txt)"
for f in $(ls shots/rel_*.png | sort); do echo "B64_BEGIN $f"; base64 -w0 "$f"; echo; echo "B64_END $f"; done
