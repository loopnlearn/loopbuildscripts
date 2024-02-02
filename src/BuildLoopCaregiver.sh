#!/bin/bash # script BuildLoopCaregiver.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/LoopKit/LoopCaregiver.git"

function choose_dev_branch() {
    branch_select ${URL_THIS_SCRIPT} dev
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n ${INFO_FONT}You are running the script for LoopCaregiver (LCG)"
    echo -e " This app is under development and may require frequent builds${NC}"
    echo -e " You need Xcode and Xcode command line tools installed"
    echo -e ""
    echo -e " If you have not read this section of LoopDocs - please review before continuing"
    echo -e "    https://loopkit.github.io/loopdocs/nightscout/remote-overrides"
    echo -e ""
    echo -e " If you have not joined zulipchat Loop Caregiver App stream - do so now"
    echo -e "    https://loop.zulipchat.com/#narrow/stream/358458-Loop-Caregiver-App"

    options=("Continue" "$(exit_or_return_menu)")
    actions=("choose_dev_branch" "exit_script")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select ${URL_THIS_SCRIPT} $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

standard_build_train


############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
after_final_return_message
exit_script
