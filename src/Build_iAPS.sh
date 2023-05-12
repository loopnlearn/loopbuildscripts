#!/bin/bash # script Build_iAPS.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/"Build_iAPS"
# For iAPS, OVERRIDE_FILE is inside newly downloaded iAPS folder
USE_OVERRIDE_IN_REPO="1"
OVERRIDE_FILE="ConfigOverride.xcconfig"
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"
# iAPS is not using sub modules
CLONE_SUB_MODULES="0"

#!inline build_functions.sh


############################################################
# The rest of this is specific to the particular script
############################################################

initial_greeting


############################################################
# Welcome & Branch Selection
############################################################


function select_iaps_main() {
    branch_select https://github.com/Artificial-Pancreas/iAPS.git main
}

function select_iaps_dev() {
    branch_select https://github.com/Artificial-Pancreas/iAPS.git dev
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n ${RED}${BOLD}You are running the script to build iAPS${NC}"
    echo -e "Before you continue, please ensure"
    echo -e "  you have Xcode and Xcode command line tools installed\n"
    echo -e "Please select which branch of iAPS to download and build."
    echo -e "Most people should choose main branch"
    echo -e ""
    echo -e "Documentation is found at:"
    echo -e "  https://github.com/Artificial-Pancreas/iAPS#iaps"
    echo -e "       and"
    echo -e "  https://iaps.readthedocs.io/en/latest/"
    echo -e ""

    options=("iAPS main" "iAPS dev" "Cancel")
    actions=("select_iaps_main" "select_iaps_dev" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select https://github.com/Artificial-Pancreas/iAPS.git $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

standard_build_train


############################################################
# Open Xcode
############################################################

section_separator
echo -e "The following item will open (when you are ready)"
echo -e "* Xcode ready to prep your current download for build"
before_final_return_message
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_message
