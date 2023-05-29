#!/bin/bash # script CustomizationSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################


add_customization "CAGE: Upload Pod Start to Nightscout" "omnipod_cage"
add_customization "SAGE: Upload Dexcom Sensor Start to Nightscout" "dexcom_sage"
add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"
add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth"
add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"

add_customization "Libre Users: Limit Loop to <5 minutes" "limit_loop_cycle_time"
add_customization "Modify Logo with LnL icon" "lnl_icon"
add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches"

add_customization "Profiles (Loop PR#2002)" "profile"
add_customization "Enhanced AutoBolus (Loop PR#1988)" "ab_ramp"
add_customization "Enhanced AutoBolus with Modified CustomTypeOne LoopPatches" "ab_ramp_cto"


function customization_info {
    echo "The Prepared Customizations are documented on the Loop and Learn web site"
    echo "  https://www.loopandlearn.org/custom-code/#custom-list"
}

patch_menu