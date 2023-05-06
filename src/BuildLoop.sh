#!/bin/bash # script BuildLoop.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

#!inline build_functions.sh

############################################################
# The rest of this is specific to BuildLoop.sh
############################################################
initial_greeting "https://loopdocs.org"

section_separator
echo -e "${BOLD}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo -e "This script will help you to:"
echo -e "  1 Download and build Loop"
echo -e "  2 Download and build LoopFollow"
echo -e "  3 Prepare your computer using a Utility Script"
echo -e "     when updating your computer or an app"
echo -e "\nRun the script again to choose a different task"
choose_or_cancel
options=("Build Loop" "Build LoopFollow" "Utility Scripts" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Build Loop")
            WHICH=Loop
            break
            ;;
        "Build LoopFollow")
            WHICH=LoopFollow
            break
            ;;
        "Utility Scripts")
            WHICH=UtilityScripts
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

echo -e "\n\n\n\n"

if [ "$WHICH" = "Loop" ]; then
    section_separator
    echo -e "Before you continue, please ensure"
    echo -e "  you have Xcode and Xcode command line tools installed\n"
    echo -e "Please select which version of Loop to download and build."
    echo -e "\n  Loop:"
    echo -e "      This is always the current released version"
    echo -e "      More info at https://github.com/LoopKit/Loop/releases"
    echo -e "\n  Loop with Patches:"
    echo -e "      adds 2 CGM options, CustomTypeOne LoopPatches, new Logo"
    echo -e "      More info at https://www.loopandlearn.org/main-lnl-patches"
    BRANCH_LOOP=main
    BRANCH_PATCHES=main_lnl_patches
    LOOPCONFIGOVERRIDE_VALID=1
    choose_or_cancel
    options=("Loop" "Loop with Patches" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Loop")
                FORK_NAME=Loop
                REPO=https://github.com/LoopKit/LoopWorkspace
                BRANCH=$BRANCH_LOOP
                break
                ;;
            "Loop with Patches")
                FORK_NAME=Loop_lnl_patches
                REPO=https://github.com/loopnlearn/LoopWorkspace
                BRANCH=$BRANCH_PATCHES
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

    LOOP_DIR="${BUILD_DIR}/${FORK_NAME}-${DOWNLOAD_DATE}"
    if [ ${FRESH_CLONE} == 1 ]; then
        mkdir "${LOOP_DIR}"
    else
        LOOP_DIR="${STARTING_DIR}"
    fi
    cd "${LOOP_DIR}"
    section_separator
    verify_xcode_path
    if [ ${FRESH_CLONE} == 1 ]; then
        echo -e " -- Downloading ${FORK_NAME} ${BRANCH} to your Downloads folder --"
        echo -e "      ${LOOP_DIR}\n"
        echo -e "Issuing this command:"
        echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
        git clone --branch=$BRANCH --recurse-submodules $REPO
        clone_exit_status=$?
    else
        clone_exit_status=${CLONE_STATUS}
    fi

    automated_clone_download_error_check

    cd LoopWorkspace
    if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]; then
        check_config_override_existence_offer_to_configure
    fi
    section_separator
    ensure_a_year
    section_separator
    echo -e "The following item will open (when you are ready)"
    echo -e "* Xcode ready to prep your current download for build"
    before_final_return_message
    echo -e "\n${RED}${BOLD}As of Loop 3.2${NC}, LoopWorkspace is already configured."
    echo -e "LoopWorkspace shows up in 2 places at top of Xcode."
    echo -e "LoopDocs graphics will be updated soon.\n"
    return_when_ready
    xed .
    exit_message

elif [ "$WHICH" = "LoopFollow" ]
then
    # Note that BuildLoopFollow.sh has a warning about Xcode and phone, not needed here
    cd $SCRIPT_DIR
    echo -e "\n\n--------------------------------\n\n"
    echo -e "Downloading Loop Follow Script\n"
    echo -e "\n--------------------------------\n\n"
    curl -fsSLo ./BuildLoopFollow.sh https://raw.githubusercontent.com/jonfawcett/LoopFollow/Main/BuildLoopFollow.sh
    echo -e "\n\n\n\n"
    source ./BuildLoopFollow.sh
else
    cd $SCRIPT_DIR
    echo -e "\n\n\n\n"
    echo -e "\n--------------------------------\n"
    echo -e "${BOLD}These utility scripts automate several cleanup actions${NC}"
    echo -e "\n--------------------------------\n"
    echo -e "1 ➡️  Clean Derived Data:\n"
    echo -e "    This script is used to clean up data from old builds."
    echo -e "    In other words, it frees up space on your disk."
    echo -e "    Xcode should be closed when running this script.\n"
    echo -e "2 ➡️  Xcode Cleanup (The Big One):\n"
    echo -e "    This script clears even more disk space filled up by using Xcode."
    echo -e "    It is typically used after uninstalling Xcode"
    echo -e "      and before installing a new version of Xcode."
    echo -e "    It can free up a substantial amount of disk space."
    echo -e "\n    You might be directed to use this script to resolve a problem."
    echo -e "\n${RED}${BOLD}    Beware that you might be required to fully uninstall"
    echo -e "      and reinstall Xcode if you run this script with Xcode installed.\n${NC}"
    echo -e "    Always a good idea to reboot your computer after Xcode Cleanup.\n"
    echo -e "3 ➡️  Clean Profiles:\n"
    echo -e "    Incorporated in the BuildLoop section"
    echo -e "    No longer needed as a stand-alone step.\n"
    echo -e "4 ➡️  Apply Customizations to Loop:\n"
    echo -e "    The customizations are documented here:"
    echo -e "    https://www.loopandlearn.org/custom-code/#custom-list"
    echo -e "\n--------------------------------\n"
    echo -e "${RED}${BOLD}You may need to scroll up in the terminal to see details about options${NC}"
    choose_or_cancel
    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles" "Apply Customizations to Loop" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Clean Derived Data")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Script: CleanDerived.sh"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./CleanDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanDerived.sh
                source ./CleanDerived.sh
                break
                ;;
            "Xcode Cleanup (The Big One)")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Script: XcodeClean.sh"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh
                source ./XcodeClean.sh
                break
                ;;
            "Clean Profiles")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Script: CleanProfiles.sh"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./CleanProfiles.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanProfiles.sh
                source ./CleanProfiles.sh
                break
                ;;
            "Apply Customizations to Loop")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Script: CustomizationSelect.sh"
                echo -e "\n--------------------------------\n"
                curl -fsSLOJ https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/CustomizationSelect.sh
                source ./CustomizationSelect.sh
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
fi

