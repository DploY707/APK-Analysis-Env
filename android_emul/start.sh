function wait_emulator_to_be_ready() {
  adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
  emulator -avd test -no-audio -no-boot-anim -no-window -accel on -gpu off -skin 1440x2880 &

boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "Boot Status: $status"

    if [ "$status" == "1" ]; then
      boot_completed=true
    else
      sleep 1
    fi
  done
}

function disable_animation() {
  adb shell "settings put global window_animation_scale 0.0"
  adb shell "settings put global transition_animation_scale 0.0"
  adb shell "settings put global animator_duration_scale 0.0"
}

wait_emulator_to_be_ready
sleep 1
disable_animation

adb root

adb shell setenforce 0

adb push ./classes.dex "/data/local/tmp/"
adb push ./libsmtb.so "/data/local/tmp/"
adb push ./t_launcher "/data/local/tmp/"
adb push ./t_launcher32 "/data/local/tmp/"

# adb install [TARGET_APK]
adb install ./ShoppingCart_clean_15_add_AssetFile.apk
# adb shell setprop wrap.[TARGET_APK_PACKAGE_NAME] "/data/local/tmp/t_launcher32"
adb shell setprop wrap.com.example.shoppingcart "/data/local/tmp/t_launcher32"
# adb shell am start -a [ACTION_NAME] -n [TARGET_APK_PACKAGE_NAME]/.[ClassName]
adb shell am start -a android.intent.action.MAIN -n com.example.shoppingcart/.MainActivity

sleep 30

adb pull /data/data/com.example.shoppingcart/m_full.log /data
sleep 3

var1=$(stat -c%s /data/m_full.log)

while [ $true ]
do
    sleep 3
    adb pull /data/data/com.example.shoppingcart/m_full.log /data/m_full.log
    sleep 3

    var2=$(stat -c%s /data/m_full.log)

    if [["$var1" -eq "$var2"]]; then
        if ["$var1" -gt 0]; then
            break
        fi
    else
        var1=$var2
    fi
done
