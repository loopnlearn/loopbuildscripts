#!/bin/bash # script BuildLoopFixedDev.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
SCRIPT_DIR="${BUILD_DIR}/Scripts"

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
#   When testing update to build_functions.sh,
#     uncomment next line to test, then comment before release
# source ~/Downloads/ManualClones/lnl/loopbuildscripts/build_functions.sh
#     comment next line to test, then uncomment before release
source ./build_functions.sh

############################################################
# The rest of this is specific to  BuildLoopFixedDev.sh
############################################################

# store a copy of this script.sh in script directory
curl -fsSLo ./BuildLoopFixedDev.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/BuildLoopFixedDev.sh

# Stable Dev SHA
LOOP_DEV_TESTED_SHA=dc8b7a7
LOOP_DEV_TESTED_DATE="Sep 18, 2022"
FAPS_DEV_TESTED_SHA=8b06d3e
FAPS_DEV_TESTED_DATE="Sep 19, 2022"
FIXED_SHA=0

section_separator
BRANCH_LOOP=dev
BRANCH_FREE=freeaps_dev
LOOPCONFIGOVERRIDE_VALID=1
echo -e "\n ${RED}${BOLD}You are running the script for the development version${NC}"
echo -e " -- If you choose Loop,    branch is ${RED}${BOLD}${BRANCH_LOOP}${NC}"
echo -e " -- If you choose FreeAPS, branch is ${RED}${BOLD}${BRANCH_FREE}${NC}"
echo -e " ${RED}${BOLD}Be aware that a development version may require frequent rebuilds${NC}\n"
echo -e " If you have not read this section of LoopDocs - please review before continuing"
echo -e "    https://loopkit.github.io/loopdocs/faqs/branch-faqs/#whats-going-on-in-the-dev-branch"
echo -e "\nThis script chooses a version (commit) of the development branch"
echo -e "    that has been built and lightly tested"
echo -e "${RED}${BOLD}Loop    development branch version:"
echo -e "     ${LOOP_DEV_TESTED_DATE} workspace revision ${LOOP_DEV_TESTED_SHA}"
echo -e "FreeAPS development branch version:"
echo -e "     ${FAPS_DEV_TESTED_DATE} workspace revision ${FAPS_DEV_TESTED_SHA}"
echo -e "${NC}\nBefore you begin, please ensure"
echo -e "  you have Xcode and Xcode command line tools installed\n"
echo -e "Please select which version of Loop you would like to download and build"

choose_or_cancel
options=("Loop dev" "FreeAPS dev" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Loop dev")
            FORK_NAME=Loop
            REPO=https://github.com/LoopKit/LoopWorkspace
            BRANCH=dev
            FIXED_SHA=$LOOP_DEV_TESTED_SHA
            LOOPCONFIGOVERRIDE_VALID=1
            break
            ;;
        "FreeAPS dev")
            FORK_NAME=FreeAPS
            REPO=https://github.com/loopnlearn/LoopWorkspace
            BRANCH=freeaps_dev
            FIXED_SHA=$FAPS_DEV_TESTED_SHA
            LOOPCONFIGOVERRIDE_VALID=1
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

LOOP_DIR="${BUILD_DIR}/${FORK_NAME}-${BRANCH}-${DOWNLOAD_DATE}_${FIXED_SHA}"
if [ ${FRESH_CLONE} == 1 ]; then
    mkdir "${LOOP_DIR}"
    cd "${LOOP_DIR}"
else
    cd "${STARTING_DIR}"
fi
section_separator
if [ ${FRESH_CLONE} == 1 ]; then
    echo -e " -- Downloading ${FORK_NAME} ${BRANCH} to your Downloads folder --"
    echo -e "      ${LOOP_DIR}\n"
    echo -e "Issuing this command:"
    echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
    git clone --branch=$BRANCH --recurse-submodules $REPO
fi

section_separator
clone_download_error_check
options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    section_separator
    case $opt in
        "Continue")
            cd LoopWorkspace
            this_dir="$(pwd)"
            echo -e "In ${this_dir}"
            if [ ${FRESH_CLONE} == 0 ]; then
                echo -e "\nScript used with test flag, extra steps to prepare downloaded code\n"
                echo -e "  Updating to latest commit"
                git checkout $BRANCH
                git pull
            fi
            echo -e "  Checking out commit ${FIXED_SHA}\n"
            git checkout $FIXED_SHA --recurse-submodules --quiet
            git branch
            echo -e "Continue if no errors reported"
            choose_or_cancel
            options=("Continue" "Cancel")
            select opt in "${options[@]}"
            do
                case $opt in
                    "Continue")
                        break
                        ;;
                    "Cancel")
                        cancel_entry
                        ;;
                      *) # Invalid option
                         invalid_entry
                         ;;
                esac
            done
            if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]; then
                check_config_override_existence_offer_to_configure
            fi

            section_separator
            echo -e "The following items will open (when you are ready)"
            echo -e "* Webpage with detailed build steps (LoopDocs)"
            echo -e "* Xcode ready to prep your current download for build"
            before_final_return_message
            return_when_ready
            if [ ${FIXED_SHA} == 0 ]; then
                open "https://loopkit.github.io/loopdocs/build/step14/#prepare-to-build"
            else
                open "https://loopkit.github.io/loopdocs/build/step13/#build-loop"
            fi
            sleep 5
            xed .
            exit_message
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
