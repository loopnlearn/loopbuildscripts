#!/bin/bash # script BuildTrio.sh

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

# use app_name instead of hard-coded strings
app_name="Trio"

BUILD_DIR=~/Downloads/"Build${app_name}"
USE_OVERRIDE_IN_REPO="0"
OVERRIDE_FILE="ConfigOverride.xcconfig"
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"

# sub modules are required
CLONE_SUB_MODULES="1"

# leave this code here, not in use now
FLAG_USE_SHA=0  # Initialize FLAG_USE_SHA to 0
FIXED_SHA=""    # Initialize FIXED_SHA with an empty string

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

# when public:
URL_THIS_SCRIPT="https://github.com/nightscout/Trio.git"
# use next while in beta testing - takes user to Beta-Testing-Welcome
# URL_FOR_DISCORD=https://discord.gg/kyjG4333Wb
# after release, use the following - takes user to the rules channels
URL_FOR_DISCORD="discord.gg/FnwFEFUwXE"
URL_FOR_FACEBOOK="facebook.com/groups/diytrio"
URL_FOR_WEBSITE="diy-trio.org"
URL_FOR_DOCS="triodocs.org"
URL_FOR_DOCS_PR="github.com/nightscout/trio-docs"

# Keep this for when we need a special branch name
# If not used, make this empty string and comment out the menu option
special_branch_name=""

function select_main() {
    #branch_select ${URL_THIS_SCRIPT} main
    branch_select ${URL_THIS_SCRIPT} main
}

function select_dev() {
    branch_select ${URL_THIS_SCRIPT} dev
}

function select_special_branch() {
    branch_select ${URL_THIS_SCRIPT} ${special_branch_name} ${app_name}_${special_branch_name}
}

if [ -z "$CUSTOM_BRANCH" ]; then
    while [ -z "$BRANCH" ]; do
        section_separator
        echo -e "${INFO_FONT}You are running the script to build ${app_name}${NC}"
        echo -e ""
        echo -e "  ${INFO_FONT}Welcome: You can get help for ${app_name} at:${NC}"
        echo -e "       Facebook      : ${URL_FOR_FACEBOOK}"
        echo -e "       Discord       : ${URL_FOR_DISCORD}"
        echo -e "       Website       : ${URL_FOR_WEBSITE}"
        echo -e "       Documentation : ${URL_FOR_DOCS}"
        echo -e ""
        echo -e "  ${INFO_FONT}Option 1: Trio main is recommended${NC}"
        echo -e ""
        echo -e "Before you continue, please ensure"
        echo -e "  you have Xcode and Xcode command line tools installed\n"

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
    branch_select ${URL_THIS_SCRIPT} $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

verify_xcode_path
check_versions
clone_repo
automated_clone_download_error_check

# special build train for lightly tested commit
cd $REPO_NAME

this_dir="$(pwd)"
echo -e "In ${this_dir}"
if [ ${FLAG_USE_SHA} == 1 ]; then
    echo -e "  Checking out commit ${FIXED_SHA}\n"
    git checkout ${FIXED_SHA} --recurse-submodules --quiet
    git describe --tags --exact-match
    git rev-parse HEAD
    echo -e "Continue if no errors reported"
    return_when_ready
fi

check_config_override_existence_offer_to_configure
ensure_a_year

############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
xed . 
after_final_return_message
exit_script
