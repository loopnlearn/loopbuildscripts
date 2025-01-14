#!/bin/bash # script CustomizationSelect.sh

BUILD_DIR=~/Downloads/BuildLoop

# Customization parameters for Loop
app_name="Loop"
app_folder_name="LoopWorkspace"

#!inline patch_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

message_incompatible_count=0

# this is always used - it is the introductory message - it can be blank
# it comes before any customizations are presented
function message_generic() {
    echo "  These Customizations are documented on the Loop and Learn web site"
    echo "        https://www.loopandlearn.org/custom-code/#custom-list"
    echo
    echo "  These customizations are only for Loop 3.4.4"
    echo
}

# this is always used - it is the incompatible patches message - it can be blank
function message_incompatible() {
    :
}

# This section contains optional messages used for some of the customization lines
#   In order for optional messages to appear when added to the add_customization line
#   must use printf

function message_to_add_blank_line() {
    printf "\n"
}

function message_for_profiles() {
    printf "        This feature enables save and restore of named profiles\n"
    printf "          https://www.loopandlearn.org/loop-features-in-development/#pr-2002\n"
}

function message_for_basal_lock() {
    printf "        This feature enables override of Loop behavior for high glucose\n"
    printf "          https://www.loopandlearn.org/loop-features-in-development/#basal-lock\n"
}

function message_for_live_activity() {
    printf "        ${INFO_FONT}Xcode MUST be closed${NC}\n"
    printf "        This feature adds Live Activity and Dynamic Island\n"
    printf "          Requires iPhone 14 or newer; iOS 16.2 or newer\n"
    printf "          https://www.loopandlearn.org/loop-features-in-development/#live-activity\n"
}

function message_for_negative_insulin() {
    printf "        This adds a new model that mitigates accumulated negative insulin\n"
    printf "          https://www.loopandlearn.org/loop-features-in-development/#negative-insulin\n"
}

function message_for_bolus_display() {
    printf "        This fixes a display bug where bolus progress might report a stale value\n"
    printf "          https://github.com/LoopKit/Loop/pull/2264\n\n"
}

# list patches in this order with args:
#   User facing information for option
#   Folder name in the patch repo
#   (Optional) message function shown prior to option

add_customization "Change Default to Upload Dexcom Readings" "dexcom_upload_readings"
add_customization "Increase Future Carbs Limit to 4 hours" "future_carbs_4h"
add_customization "Modify Carb Warning & Limit: Low Carb to 49 & 99" "low_carb_limit"
add_customization "Modify Carb Warning & Limit: High Carb to 201 & 300" "high_carb_limit"
add_customization "Disable Authentication Requirement" "no_auth" "message_to_add_blank_line"

add_customization "Override Insulin Needs Picker (50% to 200%, steps of 5%)" "override_sens"
add_customization "Add now line to charts" "now_line"
add_customization "Modify Logo to include LnL icon" "lnl_icon"
add_customization "Remove Loop Title on Watch App" "watch_title"
add_customization "2 hour Absorption Time for Lollipop" "2hlollipop" "message_to_add_blank_line"

add_customization "Display 2 Days of Meal History" "meal_days"
add_customization "Display a Week of Meal History (Slow after Restart)" "meal_week" "message_to_add_blank_line"

add_customization "Profile Save & Load" "profiles" "message_for_profiles"
add_customization "Basal Lock" "basal_lock" "message_for_basal_lock" "1"
# live_activity changes the minimum iOS allowed and therefore requires xcode to be closed
add_customization "Live Activity/Dynamic Island" "live_activity" "message_for_live_activity" "1" "Verify that Xcode is closed before continuing!"
add_customization "Negative Insulin Damper" "negative_insulin" "message_for_negative_insulin"

add_customization "Bolus Progress Display Fix" "bolus_display" "message_for_bolus_display"

add_translation "2002" "profiles"

param_zero_is_customization
param_zero_result=$?

if [ $param_zero_result -eq 0 ]; then
    patch_command_line $0 "$@"
elif [ $# -gt 0 ] && [ -n "$1" ]; then
    patch_command_line "$@"
else
    if [ "$GITHUB_ACTIONS" != "true" ]; then
        patch_menu
    else
        echo -e "${ERROR_FONT}  Customization in Browser Build executed without parameters, check that there is no empty line after CustomizationSelect.sh.{NC}"
        exit 1
    fi
fi