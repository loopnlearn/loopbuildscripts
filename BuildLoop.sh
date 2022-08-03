#!/bin/bash # script BuildLoop.sh

# copy from helper_functions.sh to beginning of scripts
# for each different script that uses this, modify script name
#    first line of script and
#    in function download_script

############################################################
# define some font styles and colors
############################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

############################################################
# set up nominal values
#   these can be later overwritten by flags
#   for convenience when testing (or for advanced usersS)
############################################################

# FRESH_CLONE
#   Default value is 1, which means:
#     Download fresh clone every time script is run
FRESH_CLONE=1

# Prepare date-time stamp for folder
DOWNLOAD_DATE=$(date +'%y%m%d-%H%M')

function usage() {
    echo -e "Allowed arguments:"
    echo -e "  -h or --help : print this help message"
    echo -e "  -t or --test : sets FRESH_CLONE=0"
    echo -e "      To test script, execute while in folder "
    echo -e "          between BuildLoop and LoopWorkspace"
}

############################################################
# Process flags, input options as positional parameters
############################################################
while [ "$1" != "" ]; do
    case $1 in
        -h | --help ) # usage function for help
            usage
            exit
            ;;
        -t | --test )  # Do not download clone - useful for testing
            echo -e "  -t or --test selected, sets FRESH_CLONE=0"
            FRESH_CLONE=0
            ;;
        * )  # argument not recognized
            echo -e "\n${RED}${BOLD}Input argument not recognized${NC}\n"
            usage
            exit 1
    esac
    shift
done

sleep 1

############################################################
# Define the rest of the functions (usage defined above):
############################################################

function initial_greeting() {
    echo -e "${RED}${BOLD}\n\n--------------------------------\n\n"
    echo -e "IMPORTANT\n"
    echo -e "Please understand that this project:\n"
    echo -e "- Is Open Source software"
    echo -e "- Is not \"approved\" for therapy\n"
    echo -e "And that:"
    echo -e "- You take full responsibility for"
    echo -e "  reading and understanding the documenation"
    echo -e "  (LoopsDocs is found at https://loopdocs.org)"
    echo -e "  before building and running this system,"
    echo -e "  and do so at your own risk.\n"
    echo -e "${NC}If you find the font too small to read comfortably"
    echo -e "  Hold down the CMD key and hit + (or -)"
    echo -e "  to increase (decrease) size"
    accept_or_cancel
}

function accept_or_cancel() {
    echo -e "\n${RED}${BOLD}By typing 1 and ENTER, you indicate you agree"
    echo -e "  Any other entry cancels"
    echo -e "\n--------------------------------\n${NC}"
}

function choose_or_cancel() {
    echo -e "\nType a number from the list below and return to proceed."
    echo -e "${RED}${BOLD}  To cancel, any entry not in list also works${NC}"
    echo -e "\n--------------------------------\n"
}

function cancel_entry() {
    echo -e "\n${RED}${BOLD}User canceled${NC}\n"
    exit_message
}

function invalid_entry() {
    echo -e "\n${RED}${BOLD}User canceled by entering an invalid option${NC}\n"
    exit_message
}

function exit_message() {
    echo -e "You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning.\n\n";
    exit 0
}

function return_when_ready() {
    read -p "Return when ready to continue  " dummy
}

function configure_folders() {

    BUILD_DIR=~/Downloads/BuildLoop
    SCRIPT_DIR=$BUILD_DIR"/"Scripts

    if [ ! -d ${BUILD_DIR} ]; then
        mkdir $BUILD_DIR
    fi
    if [ ! -d ${SCRIPT_DIR} ]; then
        mkdir $SCRIPT_DIR
    fi
}

############################################################
# function download_script
#
# downloads copy of this script (from main branch)
#
# This function call should be AFTER user accepts terms of use
#    DO NOT MOVE call to this function before that question
#
############################################################
function download_script() {
    # store a copy of this script in script directory
    curl -fsSLo ${SCRIPT_DIR}/BuildLoop.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoop.sh
}

function report_persistent_config_override() {
    OVERRIDE_FILE=$BUILD_DIR"/"LoopConfigOverride.xcconfig
    echo -e "The file used by Xcode to sign your app is found at:"
    echo -e "   ~/Downloads/BuildLoop/LoopConfigOverride.xcconfig"
    echo -e "The last 3 lines of that file are shown next:\n"
    tail -3 $OVERRIDE_FILE
    echo -e "\nIf the last line has your Apple Developer ID"
    echo -e "   with no slashes at the beginning of the line"
    echo -e "   your targets will be automatically signed"
    echo -e "Any line that starts with // is ignored"
    echo -e "  If ID is OK, hit return"
    echo -e "  If ID is not OK:"
    echo -e "    Edit the file before hitting return"
    echo -e "     step 1: open finder, navigate to Downloads/BuildLoop"
    echo -e "     step 2: double click on LoopConfigOverride.xcconfig"
    echo -e "     step 3: edit and save file"
    return_when_ready
}

function create_persistent_config_override() {
    echo -e "\n--------------------------------\n"
    echo -e "The Apple Developer page will open when you hit return"
    echo -e " * Log in if needed"
    echo -e " * If the Membership page does not show, you may need to select it"
    echo -e "     Your Apple Developer ID is the 10-character Team ID"
    echo -e " * If you already have your account open in your browser, you may need to go to the already opened page"
    echo -e " * Once you get your ID, return to terminal window"
    echo -e "This is the page that will open after you hit return:"
    echo -e "   https://developer.apple.com/account/#!/membership\n"
    return_when_ready
    open "https://developer.apple.com/account/#!/membership"
    echo -e "\n * Click in terminal window"
    read -p "Enter the ID and return: " devID
    echo -e "\n--------------------------------\n"
    if [ ${#devID} -ne 10 ]; then
        echo -e "Something was wrong with entry"
        echo -e "You can manually sign each target in Xcode"
    else 
        echo -e "Creating ~/Downloads/BuildLoop/LoopConfigOverride.xcconfig"
        echo -e "   with your Apple Developer ID\n"
        cp -p LoopConfigOverride.xcconfig $OVERRIDE_FILE
        echo -e "LOOP_DEVELOPMENT_TEAM = ${devID}" >> $OVERRIDE_FILE
        report_persistent_config_override
        echo -e "\nXcode uses the permanent file to automatically sign your targets"
    fi
}

function check_config_override_existence_offer_to_configure() {
    echo -e "\n--------------------------------\n"
    if [ -e $OVERRIDE_FILE ]; then
        report_persistent_config_override
    else
        # make sure the LoopConfigOverride.xcconfig exists in clone
        if [ -e $OVERRIDE_FILE ]; then
            echo -e "Choose to enter Apple Developer ID or wait and Sign Manually (later in Xcode)"
            echo -e "\nIf you choose Apple Developer ID, script will help you find it"
            choose_or_cancel
            options=("Enter Apple Developer ID" "Sign Manually" "Cancel")
            select opt in "${options[@]}"
            do
                case $opt in
                    "Enter Apple Developer ID")
                        create_persistent_config_override
                        break
                        ;;
                    "Sign Manually")
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
        else
            echo -e "This project requires you to sign the targets individually"
            LOOPCONFIGOVERRIDE_VALID=0
        fi
    fi
    echo -e "\n--------------------------------\n"
}

# call functions that are always used
initial_greeting

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

# user agreed;
#    DO NOT MOVE call to download_script
#       before user agrees to terms of use
configure_folders
download_script

echo -e "${NC}\n\n\n\n"

############################################################
# End of functions used by script
#    - end of helper_functions.sh common code
############################################################


############################################################
# begin script specific to BuildLoop.sh
############################################################


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

