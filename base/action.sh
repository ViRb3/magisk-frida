#!/system/bin/sh
MODPATH=${0%/*}
PATH=$PATH:/data/adb/ap/bin:/data/adb/magisk:/data/adb/ksu/bin

# log
exec 2> $MODPATH/logs/action.log
set -x

. $MODPATH/utils.sh

[ -f $MODPATH/disable ] && {
    echo "[-] Frida-server is already disable. Please re-enable & reboot"
    string="description=Run frida-server on boot: ❌ (failed)"
    sed -i "s/^description=.*/$string/g" $MODPATH/module.prop
    sleep 1
    exit 0
}

result="$(busybox pgrep 'frida-server')"
if [ $result -gt 0 ]; then
    echo "[-] Stopping Frida-server..."
    busybox kill -9 $result
else
    echo "[-] Starting Frida server..."
    frida-server -D
fi

sleep 2

check_frida_is_up

#EOF
