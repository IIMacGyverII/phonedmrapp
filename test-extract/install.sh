#!/system/bin/sh
# MacDMRUlephone Magisk Module
# This module overlays the custom MacDMRUlephone APK over the original system app

MODDIR=${0%/*}

# Module will automatically replace /system/priv-app/PriInterPhone/PriInterPhone.apk
# with the MacDMRUlephone.apk via Magisk's file overlay system

ui_print "- Installing MacDMRUlephone system overlay"
ui_print "- This keeps DMR hardware access while adding custom branding"
ui_print "- Original app signature preserved for system privileges"
