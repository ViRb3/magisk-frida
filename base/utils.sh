#!/bin/sh
MODPATH=${0%/*}
FRIDA_BIN="$MODPATH/bin/frida-server"
FRIDA_PORT_FILE="$MODPATH/port"
PATH="$MODPATH/bin:$PATH:/data/adb/ap/bin:/data/adb/magisk:/data/adb/ksu/bin"

# log
exec 2> $MODPATH/logs/utils.log
set -x

check_frida_is_up() {
    if [ -n "$1" ]; then
        timeout="$1"
    else
        timeout=4
    fi
    counter=0

    while [ $counter -lt $timeout ]; do
        result="$(busybox pgrep 'frida-server')"
        if [ -n "$result" ]; then
            echo "[-] Frida-server is running... 💉😜"
            string="description=Run frida-server on boot: ✅ (active)"
            break
        else
            echo "[-] Checking Frida-server status: $counter"
            counter=$((counter + 1))
        fi
        sleep 1.5
    done

    if [ $counter -ge $timeout ]; then
        string="description=Run frida-server on boot: ❌ (failed)"
    fi

    sed -i "s/^description=.*/$string/g" $MODPATH/module.prop
}

start_frida_server() {
  if [ ! -x "$FRIDA_BIN" ]; then
    echo "[-] Frida binary not found: $FRIDA_BIN"
    string="description=Run frida-server on boot: ❌ (missing binary)"
    sed -i "s/^description=.*/$string/g" $MODPATH/module.prop
    return 1
  fi

  FRIDA_LISTEN=""
  if [ -f "$FRIDA_PORT_FILE" ]; then
    FRIDA_PORT="$(tr -d ' \t\r\n' < "$FRIDA_PORT_FILE")"
    case "$FRIDA_PORT" in
      '' | *[!0-9]*) echo "[-] Ignoring invalid port: $FRIDA_PORT" ;;
      *) [ "$FRIDA_PORT" -ge 1 ] && [ "$FRIDA_PORT" -le 65535 ] \
           && FRIDA_LISTEN="127.0.0.1:$FRIDA_PORT" \
           || echo "[-] Ignoring out-of-range port: $FRIDA_PORT" ;;
    esac
  fi

  "$FRIDA_BIN" ${FRIDA_LISTEN:+-l "$FRIDA_LISTEN"} -D
}

wait_for_boot() {
  while true; do
    result="$(getprop sys.boot_completed)"
    if [ $? -ne 0 ]; then
      exit 1
    elif [ "$result" = "1" ]; then
      break
    fi
    sleep 3
  done
}

#EOF
