#!/bin/bash # build_functions.sh

# Common functions used by multiple build scripts

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

# CLONE_OBTAINED is used as a flag
#   if the script goes through the process to download a clone
#   this is set to 1, and the exit_message is updated to
#   inform the user how to cd to LOOP_DIR / LoopWorkspace
CLONE_OBTAINED=0

# Prepare date-time stamp for folder
DOWNLOAD_DATE=$(date +'%y%m%d-%H%M')

BUILD_DIR=~/Downloads/"BuildLoop"
SCRIPT_DIR="${BUILD_DIR}/Scripts"

OVERRIDE_FILE=LoopConfigOverride.xcconfig
OVERRIDE_FULLPATH="${BUILD_DIR}/${OVERRIDE_FILE}"

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

function section_separator() {
    clear
    echo -e "--------------------------------\n"
}

function section_divider() {
    echo -e "--------------------------------\n"
}

function initial_greeting() {
    section_separator
    echo -e "${RED}${BOLD}*** IMPORTANT ***${NC}\n"
    echo -e "${BOLD}This project is:${RED}${BOLD}"
    echo -e "  Open Source software"
    echo -e "  Not \"approved\" for therapy\n"
    echo -e "  You take full responsibility for reading and"
    echo -e "  understanding the documenation, LoopsDocs, found at "
    echo -e "      https://loopdocs.org,"
    echo -e "  before building or running this system, and"
    echo -e "  you do so at your own risk.${NC}\n"
    echo -e "To increase (decrease) font size"
    echo -e "  Hold down the CMD key and hit + (-)"
    echo -e "\n${RED}${BOLD}By typing 1 and ENTER, you indicate you understand"
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
    section_divider
    echo -e "\nShell Script Completed\n"
    echo -e " * You may close the terminal window now if you want"
    echo -e "   or"
    echo -e " * You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning.\n\n"
    if [[ -z ${LOOP_DIR} ]]; then
        exit 0
    else
        echo -e "To configure this terminal to LoopWorkspace folder of new download;"
        echo -e " copy and paste the following line into the terminal\n"
        echo -e "cd ${LOOP_DIR}/LoopWorkspace\n"
        echo -e "  If you need to reopen Xcode while in the LoopWorkspace folder"
        echo -e "  Type"
        echo -e "xed ."
        echo -e "  After pasting the cd ... LoopWorkspace command"
        exit 0
    fi
}

function return_when_ready() {
    echo -e "${RED}${BOLD}Return when ready to continue${NC}"
    read -p "" dummy
}

function ios16_warning() {
    echo -e "\n${RED}${BOLD}  If you have iOS 16 (watchOS 9), you must enable Developer Mode${NC}"
    echo -e "${RED}${BOLD}  Check in Phone Settings->Privacy & Security${NC}"
    echo -e "  For more information:"
    echo -e "  https://loopkit.github.io/loopdocs/build/step14/#prepare-your-phone-and-watch"
}

function clone_download_error_check() {
    # indicate that a clone was created
    CLONE_OBTAINED=1
    echo -e "--------------------------------\n"
    echo -e "🛑 Check for successful Download\n"
    echo -e "   Please scroll up and look for the word ${BOLD}error${NC} in the window above."
    echo -e "   OR use the Find command for terminal, hold down CMD key and tap F,"
    echo -e "      then type error (in new row, top of terminal) and hit return"
    echo -e "      Be sure to click in terminal again if you use CMD-F"
    echo -e "   If there are no errors listed, code has successfully downloaded, Continue."
    echo -e "   If you see the word error in the download, Cancel and resolve the problem."
    choose_or_cancel
}

function before_final_return_message() {
    echo -e "\n${RED}${BOLD}BEFORE you hit return:${NC}"
    echo -e " *** Unlock your phone and plug it into your computer"
    echo -e "     Trust computer if asked"
    echo -e " *** Optional (New Apple Watch - never built Loop on it)"
    echo -e "              Paired to phone, on your wrist and unlocked"
    echo -e "              Trust computer if asked"
    ios16_warning
}

function report_persistent_config_override() {
    echo -e "The file used by Xcode to sign your app is found at:"
    echo -e "   ~/Downloads/BuildLoop/${OVERRIDE_FILE}"
    echo -e "   The last line of that file is shown next:"
    tail -1 "${OVERRIDE_FULLPATH}"
    echo -e "\nIf the last line has your Apple Developer ID"
    echo -e "   your targets will be automatically signed"
    echo -e "WARNING: Any line that starts with // is ignored\n"
    echo -e "  If ID is not OK:"
    echo -e "    Edit the ${OVERRIDE_FILE} before hitting return"
    echo -e "     step 1: open finder, navigate to Downloads/BuildLoop"
    echo -e "     step 2: locate and double click on "${OVERRIDE_FILE}""
    echo -e "             this will open that file in Xcode"
    echo -e "     step 3: edit in Xcode and save file\n"
    echo -e "  If ID is OK, hit return"
    return_when_ready
}

function how_to_find_your_id() {
    echo -e "Your Apple Developer ID is the 10-character Team ID"
    echo -e "  found on the Membership page after logging into your account at:"
    echo -e "   https://developer.apple.com/account/#!/membership\n"
    echo -e "It may be necessary to click on the Membership Details icon"
}

function create_persistent_config_override() {
    section_separator
    echo -e "The Apple Developer page will open when you hit return\n"
    how_to_find_your_id
    echo -e "That page will be opened for you."
    echo -e "  Once you get your ID, you will enter it in this terminal window"
    return_when_ready
    #
    open "https://developer.apple.com/account/#!/membership"
    echo -e "\n *** \nClick in terminal window so you can"
    read -p "Enter the ID and return: " devID
    #
    section_separator
    if [ ${#devID} -ne 10 ]; then
        echo -e "Something was wrong with the entry"
        echo -e "You can manually sign each target in Xcode"
    else 
        echo -e "Creating ~/Downloads/BuildLoop/${OVERRIDE_FILE}"
        echo -e "   with your Apple Developer ID\n"
        cp -p "${OVERRIDE_FILE}" "${OVERRIDE_FULLPATH}"
        echo -e "LOOP_DEVELOPMENT_TEAM = ${devID}" >> "${OVERRIDE_FULLPATH}"
        report_persistent_config_override
        echo -e "\nXcode uses the permanent file to automatically sign your targets"
    fi
}

function check_config_override_existence_offer_to_configure() {
    section_separator
    if [ -e "${OVERRIDE_FULLPATH}" ]; then
        how_to_find_your_id
        report_persistent_config_override
    else
        # make sure the "${OVERRIDE_FILE}" exists in clone
        if [ -e "${OVERRIDE_FILE}" ]; then
            echo -e "Choose 1 to Sign Automatically or "
            echo -e "       2 to Sign Manually (later in Xcode)"
            echo -e "\nIf you choose Sign Automatically, script guides you"
            echo -e "  to create a permanent signing file"
            echo -e "  containing your Apple Developer ID"
            choose_or_cancel
            options=("Sign Automatically" "Sign Manually" "Cancel")
            select opt in "${options[@]}"
            do
                case $opt in
                    "Sign Automatically")
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

echo -e "${NC}\n\n\n\n"

############################################################
# End of functions used by script
#    - end of helper_functions.sh common code
############################################################
