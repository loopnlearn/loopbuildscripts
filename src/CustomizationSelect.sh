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
        echo "  CustomTypeOne LoopPatches (original)"
        echo "  (Incompatible with Glucose Based Application Factor (PR 1988))"
        echo "        https://www.loopandlearn.org/custom-type-one-loop-patches/"
        ((message_incompatible_count++))
    fi
}

# optional message to go with add_customization line
function message_for_cto() {
    message_incompatible
}

# optional message to go with add_customization line
function message_for_pr1988() {
    echo
    echo "  PR 1988 Glucose Based Application Factor"
    echo -e "     This experimental feature replaces CustomTypeOne ${INFO_FONT}\"switcher patch\"${NC}"
    echo "        https://github.com/LoopKit/Loop/pull/1988"
    message_incompatible
}

# optional message to go with add_customization line
function message_for_pr2002() {
    echo
    echo "  PR 2002 Profile Switching"
    echo "     This experimental feature enables save and restore of named profiles"
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

add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches" "message_for_cto"
# 2023-06-05 rearrangement note:
#   PR 2002 is first to encourage people to update it first
#           - it must be updated before PR 1988 update is valid
add_customization "Profiles (PR 2002)" "profile" "message_for_pr2002"
add_customization "Glucose Based Application Factor (PR 1988)" "ab_ramp" "message_for_pr1988"
add_customization "Glucose Based Application Factor (PR 1988) with Modified CustomTypeOne LoopPatches" "ab_ramp_cto"

patch_menu
