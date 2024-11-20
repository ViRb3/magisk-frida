##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
# if 1 skip all default installation steps
SKIPUNZIP=0
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into post-fs-data.sh or service.sh
# 5. Add your additional or modified system properties into system.prop
#
##########################################################################################
##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

##########################################################################################
#
# Function Callbacks
#
# The following functions will be called by the installation framework.
# You do not have the ability to modify update-binary, the only way you can customize
# installation is through implementing these functions.
#
# When running your callbacks, the installation framework will make sure the Magisk
# internal busybox path is *PREPENDED* to PATH, so all common commands shall exist.
# Also, it will make sure /data, /system, and /vendor is properly mounted.
#
##########################################################################################
##########################################################################################
#
# The installation framework will export some variables and functions.
# You should use these variables and functions for installation.
#
# ! DO NOT use any Magisk internal paths as those are NOT public API.
# ! DO NOT use other functions in util_functions.sh as they are NOT public API.
# ! Non public APIs are not guranteed to maintain compatibility between releases.
#
# Available variables:
#
# MAGISK_VER (string): the version string of current installed Magisk
# MAGISK_VER_CODE (int): the version code of current installed Magisk
# BOOTMODE (bool): true if the module is currently installing in Magisk Manager
# MODPATH (path): the path where your module files should be installed
# TMPDIR (path): a place where you can temporarily store files
# ZIPFILE (path): your module's installation zip
# ARCH (string): the architecture of the device. Value is either arm, arm64, x86, or x64
# IS64BIT (bool): true if $ARCH is either arm64 or x64
# API (int): the API level (Android version) of the device
#
# Availible functions:
#
# ui_print <msg>
#     print <msg> to console
#     Avoid using 'echo' as it will not display in custom recovery's console
#
# abort <msg>
#     print error message <msg> to console and terminate installation
#     Avoid using 'exit' as it will skip the termination cleanup steps
#
# set_perm <target> <owner> <group> <permission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     this function is a shorthand for the following commands
#       chown owner.group target
#       chmod permission target
#       chcon context target
#
# set_perm_recursive <directory> <owner> <group> <dirpermission> <filepermission> [context]
#     if [context] is empty, it will default to "u:object_r:system_file:s0"
#     for all files in <directory>, it will call:
#       set_perm file owner group filepermission context
#     for all directories in <directory> (including itself), it will call:
#       set_perm dir owner group dirpermission context
#
##########################################################################################
##########################################################################################
# If you need boot scripts, DO NOT use general boot scripts (post-fs-data.d/service.d)
# ONLY use module scripts as it respects the module status (remove/disable) and is
# guaranteed to maintain the same behavior in future Magisk releases.
# Enable boot scripts by setting the flags in the config section above.
##########################################################################################

# Set what you want to display when installing your module

print_modname() {
  ui_print " "
  ui_print "    ********************************************"
  ui_print "    *          Magisk-/KernelSU-Frida          *"
  ui_print "    ********************************************"
  ui_print " "
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  case $ARCH in
    arm64) F_ARCH=$ARCH;;
    arm)   F_ARCH=$ARCH;;
    x64)   F_ARCH=x86_64;;
    x86)   F_ARCH=$ARCH;;
    *)     ui_print "Unsupported architecture: $ARCH"; abort;;
  esac

  ui_print "- Detected architecture: $F_ARCH"

  if [ "$BOOTMODE" ] && [ "$KSU" ]; then
      ui_print "- Installing from KernelSU app"
      ui_print "- KernelSU version: $KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)"
  elif [ "$BOOTMODE" ] && [ "$APATCH" ]; then
      ui_print "- Installing from APatch app"
      ui_print "- APatch version: $APATCH_VER_CODE. Magisk version: $MAGISK_VER_CODE"
  elif [ "$BOOTMODE" ] && [ "$MAGISK_VER_CODE" ]; then
      ui_print "- Installing from Magisk app"
      ui_print "- Magisk version: $MAGISK_VER_CODE"
  else
    ui_print "*********************************************************"
    ui_print "! Install from recovery is not supported"
    ui_print "! Please install from KernelSU or Magisk app"
    abort    "*********************************************************"
fi

  ui_print "- Extracting module files"
  F_TARGETDIR="$MODPATH/system/bin"
  mkdir -p "$F_TARGETDIR"
  chcon -R u:object_r:system_file:s0 "$F_TARGETDIR"
  chmod -R 755 "$F_TARGETDIR"

  mv "$MODPATH/files/frida-server-$F_ARCH" "$F_TARGETDIR/frida-server"
  rm -r "$MODPATH/files"
  
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases
# You can add more functions to assist your custom script code
