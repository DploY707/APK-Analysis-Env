#!/bin/bash

# adb install [TARGET_APK]
adb install ./ShoppingCart_clean_15_add_AssetFile.apk
# adb shell setprop wrap.[TARGET_APK_PACKAGE_NAME] "/data/local/tmp/t_launcher32"
adb shell setprop wrap.com.example.shoppingcart "/data/local/tmp/t_launcher32"
# adb shell am start -n [TARGET_APK_PACKAGE_NAME]:[TARGET_APK_PACKAGE_NAME].[ENTRYPOINT]
adb shell am start -n com.example.shoppingcart:com.example.shoppingcart.MainActivity

adb pull /data/data/com.example.shoppingcart/m_full.log /data/m_full.log

var1=$(stat -c%s /tmp/m_full.log)

condition=1

while [condition]
do
    var2=$(stat -c%s /tmp/m_full.log)
    if [["$var1" -eq "$var2"]]; then
        condition = 0
        adb pull /data/data/com.example.shoppingcart/m_full.log /data/m_full.log
    else
        var1=$var2
    fi
done
