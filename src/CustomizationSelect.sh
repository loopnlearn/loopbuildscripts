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
    :
}

# optional message to go with add_customization line
function message_for_cto() {
    echo
    echo "  CustomTypeOne LoopPatches"
    echo "        https://www.loopandlearn.org/custom-type-one-loop-patches/"
    echo "        Update automatic when Glucose Based Application Factor also selected"
}

# optional message to go with add_customization line
function message_for_pr1988() {
    echo
    echo "  Glucose Based Application Factor"
    echo "     This feature in development gradually increases AB factor with glucose"
    echo -e "     (replaces ${INFO_FONT}\"switcher patch\"${NC}, CustomTypeOne Loop Patches)"
    echo "        https://github.com/LoopKit/Loop/pull/1988"
}

# optional message to go with add_customization line
function message_for_pr2002() {
    echo
    echo "  Profile Switching"
    echo "     This feature in development enables save and restore of named profiles"
    echo "        https://github.com/LoopKit/Loop/pull/2002"
}

function message_for_pr2008() {
    echo
    echo "  Integral Retrospective Correction"
    echo "     This feature in development modifies retrospective correction."
    echo "     Helps when glucose is different than Loop predicts for longer times."
    echo "        https://github.com/LoopKit/Loop/pull/2008"
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
add_customization "Modify Logo to include LnL icon" "lnl_icon"

add_customization "CustomTypeOne LoopPatches" "customtypeone_looppatches" "message_for_cto"

add_customization "Profile Save & Load" "2002" "message_for_pr2002"
add_customization "Glucose Based Application Factor" "1988" "message_for_pr1988"
add_customization "Integral Retrospective Correction" "2008" "message_for_pr2008"


patch_menu
