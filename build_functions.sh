#!/bin/bash # build_functions.sh

# These are used for more than one BuildLoopXXX.sh script

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

BUILD_DIR=~/Downloads/BuildLoop
SCRIPT_DIR=$BUILD_DIR"/"Scripts

OVERRIDE_FILE=LoopConfigOverride.xcconfig
OVERRIDE_FULLPATH=$BUILD_DIR"/"$OVERRIDE_FILE


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

function report_persistent_config_override() {
    echo -e "The file used by Xcode to sign your app is found at:"
    echo -e "   ~/Downloads/BuildLoop/${OVERRIDE_FILE}"
    echo -e "The last 3 lines of that file are shown next:\n"
    tail -3 $OVERRIDE_FULLPATH
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
        cp -p LoopConfigOverride.xcconfig $OVERRIDE_FULLPATH
        echo -e "LOOP_DEVELOPMENT_TEAM = ${devID}" >> $OVERRIDE_FULLPATH
        report_persistent_config_override
        echo -e "\nXcode uses the permanent file to automatically sign your targets"
    fi
}

function check_config_override_existence_offer_to_configure() {
    echo -e "\n--------------------------------\n"
    if [ -e $OVERRIDE_FULLPATH ]; then
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