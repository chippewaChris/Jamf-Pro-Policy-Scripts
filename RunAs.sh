#!/bin/bash
################################################################################
#                                                                              #
#                     Chippewa Limited Liability Co.                           #
#                                                                              #
#                                                                              #
#                      Script Name:Run Command as User                         #
#                      Version: 1.0, 3/16/23                                   #
#                                                                              #
################################################################################
#
# Author
# Chris Cohoon | Chippewa Limited Liability Co.
#
# License Grant and Restrictions
# This script (the "Work") is licensed to Parachute Inc. (the "Licensee") for use
# in their internal business operations only. The Licensee is granted a
# non-exclusive, non-transferable, and non-assignable license to use the Work for
# lawful purposes only, and may not modify, reverse engineer, decompile, or
# disassemble the Work without prior written consent from Chippewa Limited
# Liability Co.
#
# Ownership and Warranty
# Chippewa Limited Liability Co. retains all ownership and intellectual property
# rights in the Work. The Work is provided "AS IS" without warranty of any kind,
# express or implied.
#
# All rights reserved 2023 Chippewa Limited Liability Co.
#
################################################################################
#
#           This new script replaces the old script which relied on Python
#
#!/bin/bash
#
#currentUser=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
#
#
#sudo -u "$currentUser" $4
#
#
#################################################################################

#
# Define function to log output
function logOutput() {
    echo "$(date): $1"
}

# Get current console user
currentUser=$(stat -f '%Su' /dev/console)
logOutput "Current user is $currentUser"
logOutput "Running command: $4"

# Execute specified command as current console user
sudo -u "$currentUser" $4

# Check exit code and log output
if [[ $? -eq 0 ]]; then
    logOutput "Script completed successfully."
    exit 0
else
    logOutput "Script failed with exit code $?."
    exit 1
fi
