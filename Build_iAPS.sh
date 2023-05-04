#!/bin/bash # script Build_iAPS.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"Build_iAPS"
# For iAPS, OVERRIDE_FILE is inside newly downloaded iAPS folder
# it will be generated with branch and date
OVERRIDE_FILE=file-cannot-exist-so-build_functions-will-work.txt
DEV_TEAM_SETTING_NAME="DEVELOPER_TEAM"
SCRIPT_DIR="${BUILD_DIR}/Scripts"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi
if [ ! -d "${SCRIPT_DIR}" ]; then
    mkdir "${SCRIPT_DIR}"
fi

STARTING_DIR="${PWD}"

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}
: ${LOCAL_BUILD_FUNCTIONS_PATH:=""}

# If CUSTOM_CONFIG_PATH is not set or empty, source build_functions.sh from GitHub
if [ -z "$LOCAL_BUILD_FUNCTIONS_PATH" ]; then
    # change directory to $SCRIPT_DIR before curl calls
    cd "${SCRIPT_DIR}"

    # store a copy of build_functions.sh in script directory
    if ! curl -fsSLo ./build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/build_functions.sh; then
        echo -e "\033[0;31m❌ An error occurred during download of build_functions.sh.\n   Please investigate the issue.\033[0m"
        echo -e
        exit 1
    fi    
    source ./build_functions.sh
else
  # Source the local build_functions.sh when CUSTOM_CONFIG_PATH is set
  echo -e "Using local build_functions.sh\n"
  source "$LOCAL_BUILD_FUNCTIONS_PATH"
fi

#initial_greeting
# use different greeting for iAPS:
function iaps_greeting() {
    #Skip innitial greeting if already displayed or opted out using env variable
    if [ "${SKIP_INITIAL_GREETING}" = "1" ]; then return; fi

    SKIP_INITIAL_GREETING=1

    section_separator
    echo -e "${RED}${BOLD}*** IMPORTANT ***${NC}\n"
    echo -e "${BOLD}This project is:${RED}${BOLD}"
    echo -e "  Open Source software"
    echo -e "  Not \"approved\" for therapy\n"
    echo -e "  You take full responsibility for reading and"
    echo -e "  understanding the documenation before building"
    echo -e "  or using this system, and"
    echo -e "  you do so at your own risk.${NC}\n"
    echo -e "To increase (decrease) font size"
    echo -e "  Hold down the CMD key and hit + (-)"
    echo -e "\n${RED}${BOLD}By typing 1 and ENTER, you indicate you understand"
    echo -e "\n--------------------------------\n${NC}"

    options=("Agree" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Agree")
                break
                ;;
            "Cancel")
                echo -e "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n";
                exit_message
                ;;
            *)
                echo -e "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n";
                exit_message
                ;;
        esac
    done

    echo -e "${NC}\n\n\n\n"
}

iaps_greeting

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
section_separator
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

