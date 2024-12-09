MODPATH=${0%/*}

# This script will be executed in post-fs-data mode
# log
exec 2> $MODPATH/logs/post-fs-data.log
set -x

#EOF