#!/bin/bash # script CustomizationSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

show_cto_warning_count=0

# this is always used - it is the introductory message
function message_generic() {
    show_cto_warning
    echo "The Prepared Customizations are documented on the Loop and Learn web site"
    echo "  https://www.loopandlearn.org/custom-code/#custom-list"
    echo
}

# these are modified when a PR is added or removed
function message_for_profiles() {
    echo
    echo "Loop PR 2002 Profile Switching"
}

function message_for_ab_ramp() {
    echo
    echo "Loop PR 1988 Automatic Bolus Dosing Strategy Enhancement"
    show_cto_warning
}

function show_cto_warning() {
    # echo "show_cto_warning_count = $show_cto_warning_count"
    if [ $show_cto_warning_count -le 2 ]; then
        echo -e "${INFO_FONT}  You cannot have the (original) CustomTypeOne LoopPatches installed${NC}"
        echo -e "${INFO_FONT}  with the Enhanced Automatic Bolus customization${NC}"
        echo -e "  This enhancement replaces the ${INFO_FONT}\"switcher patch\"${NC}"
        echo
        ((show_cto_warning_count++))
    fi
}

# index 0 to 4
add_customization "CAGE: Upload Pod Start to Nightscout" "omnipod_cage"
add_customization "SAGE: Upload Dexcom Sensor Start to Nightscout" "dexcom_sage"
add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"
# index 5 to 9
add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth"
add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"
add_customization "Libre Users: Limit Loop to <5 minutes" "limit_loop_cycle_time"
add_customization "Modify Logo with LnL icon" "lnl_icon"
# index 10 to 13
add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches"
add_customization "Profiles (PR#2002)" "profile" "message_for_profiles"
add_customization "Enhanced AutoBolus (PR#1988)" "ab_ramp" "message_for_ab_ramp"
add_customization "Enhanced AutoBolus (PR#1988) with Modified CustomTypeOne LoopPatches" "ab_ramp_cto"

patch_menu
