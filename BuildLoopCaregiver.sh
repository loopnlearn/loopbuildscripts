#!/bin/bash # script BuildLoopCaregiver.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
SCRIPT_DIR="${BUILD_DIR}/Scripts"
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi
if [ ! -d "${SCRIPT_DIR}" ]; then
    mkdir "${SCRIPT_DIR}"
fi

STARTING_DIR="${PWD}"

# change directory to $SCRIPT_DIR before curl calls
cd "${SCRIPT_DIR}"

# define branch (to make it easier when updating)
# typically branch is main
SCRIPT_BRANCH=main

# store a copy of build_functions.sh in script directory
curl -fsSLo ./build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/build_functions.sh

# Verify build_functions.sh was downloaded.
if [ ! -f ./build_functions.sh ]; then
    echo -e "\n *** Error *** build_functions.sh not downloaded "
    echo -e "Please attempt to download manually"
    echo -e "  Copy the following line and paste into terminal\n"
    echo -e "curl -SLo ~/Downloads/BuildLoop/Scripts/build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/build_functions.sh"
    echo -e ""
    exit
fi

# This brings in functions from build_functions.sh
#   When testing update to build_functions.sh, set to 1 for testing only
DEBUG_FLAG=0
if [ ${DEBUG_FLAG} == 0 ]; then
    source ./build_functions.sh
else
    source ~/Downloads/ManualClones/lnl/loopbuildscripts/build_functions.sh
fi

############################################################
# The rest of this is specific to  BuildLoopCaregiver.sh
############################################################

# store a copy of this script.sh in script directory
curl -fsSLo ./BuildLoopCaregiver.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/BuildLoopCaregiver.sh

section_separator
BRANCH_LOOP=dev
LOOPCONFIGOVERRIDE_VALID=1
echo -e "\n ${RED}${BOLD}You are running the script for LoopCaregiver (LCG)"
echo -e " This app is under development and may require frequent builds${NC}"
echo -e " If you have not read this section of LoopDocs - please review before continuing"
echo -e "    https://loopkit.github.io/loopdocs/nightscout/remote-overrides"
echo -e " If you have not joined zulipchat Loop Caregiver App stream - do so now"
echo -e "    https://loop.zulipchat.com/#narrow/stream/358458-Loop-Caregiver-App"
choose_or_cancel
options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Continue")
            FORK_NAME=LoopCaregiver
            REPO=https://github.com/LoopKit/LoopCaregiver
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

LOOP_DIR="${BUILD_DIR}/${FORK_NAME}-${BRANCH}-${DOWNLOAD_DATE}"
if [ ${FRESH_CLONE} == 1 ]; then
    mkdir "${LOOP_DIR}"
else
    LOOP_DIR="${STARTING_DIR}"
fi
cd "${LOOP_DIR}"
section_separator
if [ ${FRESH_CLONE} == 1 ]; then
    echo -e " -- Downloading ${FORK_NAME} ${BRANCH} to your Downloads folder --"
    echo -e "      ${LOOP_DIR}\n"
    echo -e "Issuing this command:"
    echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
    git clone --branch=$BRANCH --recurse-submodules $REPO
fi
#
clone_download_error_check
options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    section_separator
    case $opt in
        "Continue")
            cd LoopCaregiver
            this_dir="$(pwd)"
            echo -e "In ${this_dir}"
            if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]; then
                check_config_override_existence_offer_to_configure
            fi
            section_separator
            echo -e "Xcode will open (when you are ready)"
            section_separator
            echo -e "The following items will open (when you are ready)"
            echo -e "* Xcode ready to prep your current download for build"
            echo -e "\n${RED}${BOLD}BEFORE you hit return:${NC}"
            echo -e " *** Unlock your phone and plug it into your computer"
            echo -e "     Trust computer if asked"
            ios16_warning
            echo -e "\nAFTER you hit return:"
            echo -e " *** Surprise ${RED}${BOLD}LoopCaregiver${NC} is already selected\n"
            echo -e "  ${RED}${BOLD}Wait${NC} until all packages are downloaded and resolved"
            echo -e "  Confirm your phone is selected"
            echo -e "  Hit build after indexing starts (upper right)"
            return_when_ready
            xed .
            #exit_message
            # the regular exist message uses LoopWorkspace
            section_divider
            echo -e "\nShell Script Completed\n"
            echo -e " * You may close the terminal window now if you want"
            echo -e "   or"
            echo -e " * You can press the up arrow ⬆️  on the keyboard"
            echo -e "    and return to repeat script from beginning.\n\n"
            if [[ -z ${LOOP_DIR} ]]; then
                exit 0
            else
                echo -e "To configure this terminal to LoopCaregiver folder of new download;"
                echo -e " copy and paste the following line into the terminal\n"
                echo -e "cd ${LOOP_DIR}/LoopCaregiver\n"
                exit 0
            fi
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
