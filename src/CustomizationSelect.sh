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

# this is always used - it is the incompatible intro message - it can be blank
function message_incompatible() {
    echo
    echo "  PR 1988 Glucose Based Application Factor and "
    echo "  PR 2002 Profile Switching must be added together or they are incompatible"
    echo "  CustomTypeOne LoopPatches (original) cannot be combined with PR 1988"
}

# these are modified when a PR is added or removed
function message_for_pr1988() {
    echo
    echo "  PR 1988 Glucose Based Application Factor"
    echo "        https://github.com/LoopKit/Loop/pull/1988"
    echo -e "        This experimental feature replaces CustomTypeOne ${INFO_FONT}\"switcher patch\"${NC}"
    echo
}

function message_for_pr2002() {
    echo
    echo "  PR 2002 Profile Switching"
    echo "        https://github.com/LoopKit/Loop/pull/2002"
    echo
}

function message_for_merged_pr1988_pr2002() {
    echo
    echo "  If you want both PR 1988 and PR 2002, choose one of these options"
    echo "  (Switcher Patch Replacement, Ability to Save and Load Profiles)"
    echo
}

function message_for_cto_original() {
    echo
    echo "  CustomTypeOne LoopPatches (original); cannot combine with PR 1988"
    echo "    see https://www.loopandlearn.org/custom-type-one-loop-patches/"
    echo
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

add_customization "CustomTypeOne LoopPatches (original)" "customtypeone_looppatches" "message_for_cto_original"
add_customization "Combined PR 1988 and PR 2002" "pr1998_pr2002" "message_for_merged_pr1988_pr2002"
add_customization "Combined PR 1988 and PR 2002 with modified LoopPatches" "pr1998_pr2002_modified_cto"
add_customization "Glucose Based Application Factor (PR 1988)" "ab_ramp" "message_for_pr1988"
add_customization "Glucose Based Application Factor (PR 1988) with modified LoopPatches" "ab_ramp_cto"
add_customization "Profiles (PR 2002)" "profile" "message_for_pr2002"

patch_menu
