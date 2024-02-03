#!/bin/bash # script BuildLoopReleased.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/BuildLoop
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


URL_THIS_SCRIPT="https://github.com/LoopKit/LoopWorkspace.git"

if [ -z "$CUSTOM_BRANCH" ]; then
    function choose_loop() {
        branch_select ${URL_THIS_SCRIPT} main Loop
    }
    
    section_separator
    echo -e "${INFO_FONT}You should be familiar with the documenation found at:${NC}"
    echo -e "   https://loopdocs.org"
    echo -e ""
    echo -e "You will be building"
    echo -e "   Loop:"
    echo -e "      This is always the current released version"
    echo -e "      More info at https://github.com/LoopKit/Loop/releases"
    echo -e "You need Xcode and Xcode command line tools installed"
    section_divider

    options=("Loop" "$(exit_or_return_menu)")
    actions=("choose_loop" "exit_script")
    menu_select "${options[@]}" "${actions[@]}"
else
    section_separator
    echo -e "You are about to download $CUSTOM_BRANCH branch from"
    echo -e "  ${CUSTOM_URL:-${URL_THIS_SCRIPT}}\n"
    return_when_ready
    branch_select ${CUSTOM_URL:-${URL_THIS_SCRIPT}} $CUSTOM_BRANCH
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

