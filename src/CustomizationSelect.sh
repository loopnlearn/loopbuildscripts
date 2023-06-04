#!/bin/bash # script CustomizationSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

message_incompatible_count=0

# this is always used - it is the introductory message - it can be blank
function message_generic() {
    echo "  These Customizations are documented on the Loop and Learn web site"
    echo "        https://www.loopandlearn.org/custom-code/#custom-list"
    echo
}

# this is always used - it is the incompatible patches message - it can be blank
function message_incompatible() {
    if [ $message_incompatible_count -lt 1 ]; then
        echo
        echo "  CustomTypeOne LoopPatches (original) and"
        echo "    Glucose Based Application Factor (PR 1988) are incompatible"
        ((message_incompatible_count++))
    fi
}

function message_for_pr1988() {
    echo
    echo "  PR 1988 Glucose Based Application Factor"
    echo "        https://github.com/LoopKit/Loop/pull/1988"
    echo -e "        This experimental feature replaces CustomTypeOne ${INFO_FONT}\"switcher patch\"${NC}"
    message_incompatible
}

# these are modified when a PR is added or removed
function message_for_pr2002() {
    echo
    echo "  PR 2002 Profile Switching"
    echo "        https://github.com/LoopKit/Loop/pull/2002"
}

# list patches in this order with args:
#   User facing information for option
#   Folder name in the patch repo
#   (Optional) message function shown prior to option

add_customization "CAGE: Upload Pod Start to Nightscout" "omnipod_cage"
add_customization "SAGE: Upload Dexcom Sensor Start to Nightscout" "dexcom_sage"
add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"

add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth"
add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"
add_customization "Libre Users: Limit Loop to 5 minute update" "limit_loop_cycle_time"
add_customization "Modify Logo with LnL icon" "lnl_icon"

add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches" "message_incompatible"
add_customization "Glucose Based Application Factor (PR 1988)" "ab_ramp" "message_for_pr1988"
add_customization "Glucose Based Application Factor (PR 1988) with Modified CustomTypeOne LoopPatches" "ab_ramp_cto"
add_customization "Profiles (PR 2002)" "profile" "message_for_pr2002"

patch_menu
