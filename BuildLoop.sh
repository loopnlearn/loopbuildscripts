#!/bin/bash # script BuildLoop.sh

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/BuildLoop
SCRIPT_DIR=$BUILD_DIR/Scripts

if [ ! -d ${BUILD_DIR} ]; then
    mkdir $BUILD_DIR
fi
if [ ! -d ${SCRIPT_DIR} ]; then
    mkdir $SCRIPT_DIR
fi

# change directory to $SCRIPT_DIR before curl calls
cd $SCRIPT_DIR

# define branch (to make it easier when updating)
# typically branch is main
SCRIPT_BRANCH=main

# store a copy of build_functions.sh in script directory
curl -fsSLo ./build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/build_functions.sh

# Verify build_functions.sh was downloaded.
if [ ! -f ./build_functions.sh ]; then
    echo -e "Error, build_functions.sh not downloaded "
    echo -e "Please attempt to download manually by issuing this command:"
    echo -e "curl -SLo ~/Downloads/BuildLoop/Scripts/build_functions.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/build_functions.sh"
    exit
fi

# This brings in functions from build_functions.sh
source ./build_functions.sh

############################################################
# The rest of this is specific to BuildLoop.sh
############################################################

# store a copy of this script.sh in script directory
curl -fsSLo ./BuildLoop.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/BuildLoop.sh

echo -e "\n--------------------------------\n"
echo -e "${BOLD}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo -e "This script will assist you in one of these actions:"
echo -e "  1 Download and build Loop"
echo -e "      You will be asked to choose from Loop or FreeAPS"
echo -e "  2 Download and build LoopFollow"
echo -e "  3 Prepare your computer using a Utility Script"
echo -e "     when updating your computer or an app"
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
    echo -e "\n--------------------------------\n"
    echo -e "Before you begin, please ensure that you have Xcode installed,"
    echo -e "  Xcode command line tools installed, and"
    echo -e "  your phone is plugged into your computer\n"
    echo -e "Please select which version of Loop you would like to download and build.\n"
    echo -e "\n ${RED}${BOLD}You are running the script for the released version${NC}\n"
    echo -e "  These webpages will tell you the date of the last release for:"
    echo -e "  Loop:    https://github.com/LoopKit/Loop/releases"
    echo -e "  FreeAPS: https://github.com/loopnlearn/LoopWorkspace/releases"
    BRANCH_LOOP=master
    BRANCH_FREE=freeaps
    LOOPCONFIGOVERRIDE_VALID=0
    choose_or_cancel
    options=("Loop" "FreeAPS" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Loop")
                FORK_NAME=Loop
                REPO=https://github.com/LoopKit/LoopWorkspace
                BRANCH=$BRANCH_LOOP
                break
                ;;
            "FreeAPS")
                FORK_NAME=FreeAPS
                REPO=https://github.com/loopnlearn/LoopWorkspace
                BRANCH=$BRANCH_FREE
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

    LOOP_DIR=$BUILD_DIR"/"$FORK_NAME"-"$DOWNLOAD_DATE
    if [ ${FRESH_CLONE} == 1 ]; then
        mkdir $LOOP_DIR
        cd $LOOP_DIR
    fi
    echo -e "\n\n\n\n"
    echo -e "\n--------------------------------\n"
    if [ ${FRESH_CLONE} == 1 ]; then
        echo -e " -- Downloading ${FORK_NAME} ${BRANCH} to your Downloads folder --"
        echo -e "      ${LOOP_DIR}\n"
        echo -e "Issuing this command:"
        echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
        git clone --branch=$BRANCH --recurse-submodules $REPO
    fi
    echo -e "\n--------------------------------\n"
    echo -e "🛑 Please check for errors in the window above before proceeding."
    echo -e "   If there are no errors listed, code has successfully downloaded.\n"
    echo -e "Type 1 and return to continue if and ONLY if"
    echo -e "  there are no errors (scroll up in terminal window to look for the word error)"
    choose_or_cancel
    options=("Continue" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Continue")
                cd LoopWorkspace
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]; then
                    check_config_override_existence_offer_to_configure
                fi
                echo -e "\nThe following items will open (when you are ready)"
                echo -e "* Webpage with abbreviated build steps (Loop and Learn)"
                echo -e "* Webpage with detailed build steps (LoopDocs)"
                echo -e "* Xcode ready to prep your current download for build\n"
                echo -e "     Do not forget to select Loop(Workspace)\n"
                return_when_ready
                # the helper page displayed depends on validity of persistent override
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]; then
                    # change this page to the one (not yet written) for persistent override
                    open https://www.loopandlearn.org/workspace-build-loop
                else
                    open https://www.loopandlearn.org/workspace-build-loop
                fi
                sleep 5
                open "https://loopkit.github.io/loopdocs/build/step14/#prepare-to-build"
                sleep 5
                xed .
                echo -e "\nShell Script Completed\n"
                echo -e " * You may close the terminal window now if you want"
                echo -e "  or"
                echo -e " * You can press the up arrow ⬆️  on the keyboard"
                echo -e "    and return to repeat script from beginning.\n\n";
                exit 0
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
    echo -e "3 ➡️  Clean Profiles & Derived Data:\n"
    echo -e "    For those with a paid Apple Developer ID,"
    echo -e "      this action configures you to have a full year"
    echo -e "      before you are forced to rebuild your app."
    echo -e "\n--------------------------------\n"
    echo -e "${RED}${BOLD}You may need to scroll up in the terminal to see details about options${NC}"
    choose_or_cancel
    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles & Derived Data" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Clean Derived Data")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Derived Data Script"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./CleanCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh
                echo -e "\n\n\n\n"
                source ./CleanCartDerived.sh
                break
                ;;
            "Xcode Cleanup (The Big One)")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Xcode Cleanup Script"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh
                echo -e "\n\n\n\n"
                source ./XcodeClean.sh
                break
                ;;
            "Clean Profiles & Derived Data")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Profiles and Derived Data Script"
                echo -e "\n--------------------------------\n"
                curl -fsSLo ./CleanProfCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanProfCartDerived.sh
                echo -e "\n\n\n\n"
                source ./CleanProfCartDerived.sh
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

