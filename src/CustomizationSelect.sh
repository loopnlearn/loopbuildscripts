#!/bin/bash # script CustomizationSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

add_customization "Profiles" "profile"
add_customization "AutoBolus Ramp" "ab_ramp"
add_customization "AutoBolus Ramp incl CTO" "ab_ramp_cto"
add_customization "CAGE update for Omnipod" "cage"
add_customization "Dexcom Upload readings" "dexcom_upload_readings"

function customization_info {
    echo "The Prepared Customizations are documented on the Loop and Learn web site"
    echo "  https://www.loopandlearn.org/custom-code/#custom-list"
}

patch_menu