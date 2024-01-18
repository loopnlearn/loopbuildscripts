#!/bin/bash # script BuildGlucoseDirect.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/"BuildGlucoseDirect"
OVERRIDE_FILE=GlucoseDirectOverride.xcconfig
DEV_TEAM_SETTING_NAME="DEVELOPMENT_TEAM"

#  1 create the file in the repo and add development team
USE_OVERRIDE_IN_REPO="1"

# sub modules are not required
CLONE_SUB_MODULES="0"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/creepymonster/GlucoseDirect.git"

function choose_main_branch() {
    branch_select ${URL_THIS_SCRIPT} main GlucoseDirect
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n${INFO_FONT}You are running the script to build GlucoseDirect${NC}"
    echo -e " You need Xcode and Xcode command line tools installed"
    echo -e ""
    echo -e " If you have not read the docs - please review before continuing"
    echo -e "    https://github.com/creepymonster/GlucoseDirect#readme"
    section_divider

    options=("Continue" "$(exit_or_return_menu)")
    actions=("choose_main_branch" "exit_script")
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
echo -e " *** Be patient while packages are downloaded"
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_script
