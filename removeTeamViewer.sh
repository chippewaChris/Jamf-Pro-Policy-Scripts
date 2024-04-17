#!/bin/bash
# ----------------------------------------------------------------------------------------------------------------------------
# Exclusive Script License for Johnson Lambert LLP
# Provided by Chippewa Limited Liability Co.
# ----------------------------------------------------------------------------------------------------------------------------
# Title: 
# Date: 4/17/24 
# Author: Chris Cohoon
# Version: 1.0
# Target OS: macOS Sonoma
# ----------------------------------------------------------------------------------------------------------------------------
# Version Control:
#
# 1.0 - Initial Release - 4/17/24 - Chris Cohoon, Chippewa Limited Liability Co.
#       
#
# ----------------------------------------------------------------------------------------------------------------------------
# Purpose: To remove TeamViewer and all related components from a macOS device.
#
# 
# 
#
# ----------------------------------------------------------------------------------------------------------------------------
# Legal Disclaimer:
# 
# This script is the exclusive property of Chippewa Limited Liability Co. 
# and is intended solely for internal use at Johnson Lambert LLP. 
# Unauthorized distribution, modification, or use of this script is strictly prohibited.
#
# ----------------------------------------------------------------------------------------------------------------------------
# Warranty:
# 
# This script comes with a warranty valid for the current version of macOS listed as the 'Target OS' above.
# Any updates or changes to the macOS version may require adjustments to the script for continued functionality.
#
# ----------------------------------------------------------------------------------------------------------------------------
# Requirements:
#
#  - macOS Sonoma
#
# ----------------------------------------------------------------------------------------------------------------------------
logDirectory="/Library/Application Support/Chippewa/TeamViewer Removal/Logs"
logFile="/Library/Application Support/Chippewa/TeamViewer Removal/Logs/teamViewerRemoval.log"
reportLog() {
    if [ ! -d "$logDirectory" ]; then
        mkdir -p "$logDirectory"
    fi
    if [ ! -f "$logFile" ]; then
        touch "$logFile"
    fi
    echo "$(date +"%b %d %T") $(hostname) teamViewerRemoval[$$]: $1" >> "$logFile"
}

reportLog "Starting TeamViewer removal script."
reportLog "Checking if TeamViewer is installed on this device..."

if pgrep -ix "TeamViewer" > /dev/null; then
    reportLog "TeamViewer is currently running on this device."
    reportLog "Quitting TeamViewer..."
    killall TeamViewer
    if pgrep -ix "TeamViewer" > /dev/null; then
        reportLog "TeamViewer is still running on this device."
        reportLog "Force quitting TeamViewer..."
        killall -9 TeamViewer
    else
        reportLog "TeamViewer has been quit."
    fi
else
    reportLog "TeamViewer is not currently running on this device."
fi

if [ -d "/Applications/TeamViewer.app" ]; then
    reportLog "TeamViewer is installed on this device."
    reportLog "Removing TeamViewer from this device."
    rm -r "/Applications/TeamViewer.app"
    if [ ! -d "/Applications/TeamViewer.app" ]; then
        reportLog "TeamViewer has been removed from this device."
    else
        reportLog "Failed to remove TeamViewer from this device."
    fi
else
    reportLog "TeamViewer is not installed on this device."
fi


# Check for TeamViewerHost.app

if [ -d "/Applications/TeamViewerHost.app" ]; then
    reportLog "TeamViewer Host is installed on this device."
    reportLog "Removing TeamViewer Host from this device."
    rm -r "/Applications/TeamViewerHost.app"
    if [ ! -d "/Applications/TeamViewerHost.app" ]; then
        reportLog "TeamViewer Host has been removed from this device."
    else
        reportLog "Failed to remove TeamViewer Host from this device."
    fi
else
    reportLog "TeamViewer Host is not installed on this device."
fi

# Remove ~/Library/Application Support/TeamViewer from all User's Application Support 
userDirectories=$(ls -1 /Users | grep -v "Shared")

for i in $userDirectories; do
    if [ -d "/Users/$i/Library/Application Support/TeamViewer" ]; then
        reportLog "TeamViewer is installed in /Users/$i/Library/Application Support/TeamViewer."
        reportLog "Removing TeamViewer from /Users/$i/Library/Application Support/TeamViewer."
        rm -r "/Users/$i/Library/Application Support/TeamViewer"
        if [ ! -d "/Users/$i/Library/Application Support/TeamViewer" ]; then
            reportLog "TeamViewer has been removed from /Users/$i/Library/Application Support/TeamViewer."
        else
            reportLog "Failed to remove TeamViewer from /Users/$i/Library/Application Support/TeamViewer."
        fi
    else
        reportLog "TeamViewer is not installed in /Users/$i/Library/Application Support/TeamViewer."
    fi
done

# Remove ~/Library/Caches/ com.teamviewer.TeamViewer from all User's Caches
for i in $userDirectories; do
    if [ -d "/Users/$i/Library/Caches/com.teamviewer.TeamViewer" ]; then
        reportLog "TeamViewer is installed in /Users/$i/Library/Caches/com.teamviewer.TeamViewer."
        reportLog "Removing TeamViewer from /Users/$i/Library/Caches/com.teamviewer.TeamViewer."
        rm -r "/Users/$i/Library/Caches/com.teamviewer.TeamViewer"
        if [ ! -d "/Users/$i/Library/Caches/com.teamviewer.TeamViewer" ]; then
            reportLog "TeamViewer has been removed from /Users/$i/Library/Caches/com.teamviewer.TeamViewer."
        else
            reportLog "Failed to remove TeamViewer from /Users/$i/Library/Caches/com.teamviewer.TeamViewer."
        fi
    else
        reportLog "TeamViewer is not installed in /Users/$i/Library/Caches/com.teamviewer.TeamViewer."
    fi
done

# Remove ~/Library/Preferences/com.teamviewer10.plist from all User's Preferences
for i in $userDirectories; do
    if [ -f "/Users/$i/Library/Preferences/com.teamviewer10.plist" ]; then
        reportLog "TeamViewer is installed in /Users/$i/Library/Preferences/com.teamviewer10.plist."
        reportLog "Removing TeamViewer from /Users/$i/Library/Preferences/com.teamviewer10.plist."
        rm "/Users/$i/Library/Preferences/com.teamviewer10.plist"
        if [ ! -f "/Users/$i/Library/Preferences/com.teamviewer10.plist" ]; then
            reportLog "TeamViewer has been removed from /Users/$i/Library/Preferences/com.teamviewer10.plist."
        else
            reportLog "Failed to remove TeamViewer from /Users/$i/Library/Preferences/com.teamviewer10.plist."
        fi
    else
        reportLog "TeamViewer is not installed in /Users/$i/Library/Preferences/com.teamviewer10.plist."
    fi
done

# Remove ~/Library/Preferences/com.teamviewer.TeamViewer.plist from all User's Preferences
for i in $userDirectories; do
    if [ -f "/Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist" ]; then
        reportLog "TeamViewer is installed in /Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist."
        reportLog "Removing TeamViewer from /Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist."
        rm "/Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist"
            if [ ! -f "/Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist" ]; then
                reportLog "TeamViewer has been removed from /Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist."
            else
                reportLog "Failed to remove TeamViewer from /Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist."
            fi
    else
        reportLog "TeamViewer is not installed in /Users/$i/Library/Preferences/com.teamviewer.TeamViewer.plist."
    fi
done

# Remove ~/Library/Logs/TeamViewer from all User's Logs
for i in $userDirectories; do
    if [ -d "/Users/$i/Library/Logs/TeamViewer" ]; then
        reportLog "TeamViewer is installed in /Users/$i/Library/Logs/TeamViewer."
        reportLog "Removing TeamViewer from /Users/$i/Library/Logs/TeamViewer."
        rm -r "/Users/$i/Library/Logs/TeamViewer"
        if [ ! -d "/Users/$i/Library/Logs/TeamViewer" ]; then
            reportLog "TeamViewer has been removed from /Users/$i/Library/Logs/TeamViewer."
        else
            reportLog "Failed to remove TeamViewer from /Users/$i/Library/Logs/TeamViewer."
        fi
    else
        reportLog "TeamViewer is not installed in /Users/$i/Library/Logs/TeamViewer."
    fi
done