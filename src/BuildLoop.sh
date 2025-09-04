#!/bin/bash # script BuildLoop.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

# use app_name instead of hard-coded strings
app_name="Loop"

BUILD_DIR=~/Downloads/"Build${app_name}"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh

############################################################
# The rest of this is specific to the particular script
############################################################

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}

open_source_warning

############################################################
# Welcome & Branch Selection
############################################################

URL_THIS_SCRIPT="https://github.com/LoopKit/LoopWorkspace.git"

function select_main() {
    branch_select ${URL_THIS_SCRIPT} main Loop
}

function select_dev() {
    branch_select ${URL_THIS_SCRIPT} dev Loop_dev
}

# Keep this for when we need a special branch name
# If not used, make this empty string and comment out the menu option
special_branch_name=""


if [ -z "$CUSTOM_BRANCH" ]; then
    while [ -z "$BRANCH" ]; do
        section_separator
        echo -e "${INFO_FONT}You are running the script to build ${app_name}${NC}"
        echo -e "${INFO_FONT}You should be familiar with LoopDocs found at:${NC}"
        echo
        echo -e "    https://loopdocs.org"
        echo
        echo -e "  ${INFO_FONT}Option 1: ${app_name} main branch is recommended${NC}"
        echo -e ""
        echo -e "  If you choose dev branch, you should be prepared to build frequently"
        echo "    You should be following zulipchat and have read:"
        echo
        echo "    https://loopkit.github.io/loopdocs/version/development/#whats-going-on-in-the-dev-branch"
        echo
        echo -e "  Before you continue, please ensure"
        echo -e "    you have Xcode and Xcode command line tools installed\n"
        section_divider

        options=(\
            "${app_name} main" \
            "${app_name} dev" \
            # "${app_name} ${special_branch_name}" \
            "$(exit_or_return_menu)")
        actions=(\
            "select_main" \
            "select_dev" \
            # "select_special_branch" \
            "exit_script")
        menu_select "${options[@]}" "${actions[@]}"
    done
else
    section_separator
    echo -e "You are about to download ${CUSTOM_BRANCH} branch from"
    echo -e "  ${CUSTOM_URL:-${URL_THIS_SCRIPT}}\n"
    return_when_ready
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

