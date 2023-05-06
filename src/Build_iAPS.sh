#!/bin/bash # script Build_iAPS.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"Build_iAPS"
# For iAPS, OVERRIDE_FILE is inside newly downloaded iAPS folder
# it will be generated with branch and date
OVERRIDE_FILE=file-cannot-exist-so-build_functions-will-work.txt
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"

#!inline build_functions.sh

initial_greeting

############################################################
# The rest of this is specific to  Build_iAPS.sh
############################################################

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
choose_or_cancel
options=("iAPS main" "iAPS dev" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "iAPS main")
            REPO_NAME=iAPS
            REPO=https://github.com/Artificial-Pancreas/iAPS.git
            BRANCH=main
            break
            ;;
        "iAPS dev")
            REPO_NAME=iAPS
            REPO=https://github.com/Artificial-Pancreas/iAPS.git
            BRANCH=dev
            break
            ;;
        "Cancel")
            cancel_entry
            ;;
        *)
            invalid_entry
            ;;
    esac
done

LOCAL_DIR="${BUILD_DIR}/${REPO_NAME}-${BRANCH}-${DOWNLOAD_DATE}"
if [ ${FRESH_CLONE} == 1 ]; then
    mkdir "${LOCAL_DIR}"
else
    LOCAL_DIR="${STARTING_DIR}"
fi
# special for iAPS:
OVERRIDE_FULLPATH="${LOCAL_DIR}/iAPS/ConfigOverride.xcconfig"

cd "${LOCAL_DIR}"
section_separator
verify_xcode_path
if [ ${FRESH_CLONE} == 1 ]; then
    echo -e " -- Downloading ${REPO_NAME} ${BRANCH} to your Downloads folder --"
    echo -e "      ${LOCAL_DIR}\n"
    echo -e "Issuing this command:"
    echo -e "    git clone --branch=${BRANCH} ${REPO}"
    git clone --branch=$BRANCH $REPO
    clone_exit_status=$?
else
    clone_exit_status=${CLONE_STATUS}
fi

automated_clone_download_error_check

cd iAPS
check_config_override_existence_offer_to_configure
ensure_a_year
section_separator
echo -e "The following item will open (when you are ready)"
echo -e "* Xcode ready to prep your current download for build"
before_final_return_message
echo -e ""
# needed for main but not dev - remove when no longer required
echo -e "Check to make sure FreeAPS X is selected before building"
echo -e "  top middle of Xcode - next to phone"
return_when_ready
xed .
exit_message