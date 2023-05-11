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
: ${FRESH_CLONE:="1"}
# CLONE_STATUS used to test error messages
#   Default value is 0, which means no errors with clone
: ${CLONE_STATUS:="0"}

# CLONE_OBTAINED is used as a flag
#   if the script goes through the process to download a clone
#   this is set to 1, and the exit_message is updated to
#   inform the user how to cd to LOOP_DIR / LoopWorkspace
CLONE_OBTAINED=0

# Prepare date-time stamp for folder
DOWNLOAD_DATE=$(date +'%y%m%d-%H%M')

# BUILD_DIR=~/Downloads/"BuildLoop"
# OVERRIDE_FILE=LoopConfigOverride.xcconfig
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
    #Skip innitial greeting if already displayed or opted out using env variable
    if [ "${SKIP_INITIAL_GREETING}" = "1" ]; then return; fi

    SKIP_INITIAL_GREETING=1

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
    elif [ -n "$clone_exit_status" ] && [ "$clone_exit_status" -eq 0 ]; then
        echo -e "To configure this terminal to LoopWorkspace folder of new download;"
        echo -e " copy and paste the following line into the terminal\n"
        echo -e "cd ${LOOP_DIR}/LoopWorkspace\n"
        echo -e "  If you need to reopen Xcode while in the LoopWorkspace folder"
        echo -e "  Type or copy"
        echo -e "xed ."
        echo -e "  After pasting the cd ... LoopWorkspace command"
        exit 0
    fi
    exit 0
}

function return_when_ready() {
    echo -e "${RED}${BOLD}Return when ready to continue${NC}"
    read -p "" dummy
}

function ensure_a_year() {
    echo -e "${RED}${BOLD}Ensure a year by deleting old provisioning profiles${NC}"
    echo -e "  Unless you have a specific reason, choose option 1\n"
    options=("Ensure a Year" "Skip" "Quit Scipt")
    select opt in "${options[@]}"
    do
        case $opt in
            "Ensure a Year")
                rm -rf ~/Library/MobileDevice/Provisioning\ Profiles
                echo -e "✅ Profiles were cleaned"
                echo -e "   Next app you build with Xcode will last a year"
                return_when_ready
                break
                ;;
            "Skip")
                break
                ;;
            "Quit Scipt")
                cancel_entry
                ;;
            *) # Invalid option
                invalid_entry
                ;;
        esac
    done
}

function ios16_warning() {
    echo -e "\n${RED}${BOLD}  If you have iOS 16 (watchOS 9), you must enable Developer Mode${NC}"
    echo -e "${RED}${BOLD}  Check in Phone Settings->Privacy & Security${NC}"
    echo -e "  For more information:"
    echo -e "  https://loopkit.github.io/loopdocs/build/step14/#prepare-your-phone-and-watch"
}

# This is no longer used by BuildLoop.sh, kept here until it has been removed from all the build scripts
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
# new function to use for all Build scripts - will take time to convert
function automated_clone_download_error_check() {
    # Check if the clone was successful
    if [ $clone_exit_status -eq 0 ]; then
        # Use this flag to modify exit_message
        CLONE_OBTAINED=1
        echo -e "✅ Successful Download. Proceed to the next step..."
        return_when_ready
    else
        echo -e "${RED}❌ An error occurred during download. Please investigate the issue.${NC}"
        exit_message
    fi
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
    echo -e "Your Apple Developer ID was found automatically:"
    tail -1 "${OVERRIDE_FULLPATH}"
    echo -e "\nIf that is correct your app will be automatically signed\n"
    options=("ID is OK" "Editing Instructions" "Quit Scipt")
    select opt in "${options[@]}"
    do
        case $opt in
            "ID is OK")
                break
                ;;
            "Editing Instructions")
                echo -e "    Edit the ${OVERRIDE_FILE} before hitting return"
                echo -e "     step 1: open finder, navigate to ${BUILD_DIR}"
                echo -e "     step 2: locate and double click on "${OVERRIDE_FILE}""
                echo -e "             this will open that file in Xcode"
                echo -e "     step 3: edit in Xcode and save file\n"
                echo -e "  When ready to proceed, hit return"
                return_when_ready
                break
                ;;
            "Quit Scipt")
                cancel_entry
                ;;
            *) # Invalid option
                invalid_entry
                ;;
        esac
    done
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
        echo -e "Creating ${OVERRIDE_FULLPATH}"
        echo -e "   with your Apple Developer ID\n"
        # For Loop, copy the file and add developer ID
        # For LoopFollow, will create file and add developer ID
        if [ -f ${OVERRIDE_FILE} ]; then
            cp -p "${OVERRIDE_FILE}" "${OVERRIDE_FULLPATH}"
        fi
        echo -e "${DEV_TEAM_SETTING_NAME} = ${devID}" >> "${OVERRIDE_FULLPATH}"
        report_persistent_config_override
        echo -e "\nXcode uses the permanent file to automatically sign your targets"
    fi
}

set_development_team() {
    team_id="$1"
    if [ -f ${OVERRIDE_FILE} ]; then
        cp -p "${OVERRIDE_FILE}" "${OVERRIDE_FULLPATH}"
    fi
    echo "$DEV_TEAM_SETTING_NAME = $team_id" >> ${OVERRIDE_FULLPATH}
}

function check_config_override_existence_offer_to_configure() {
    section_separator

    # Automatic signing functionality:
    # 1) Use existing Override file
    # 2) Copy team from latest provisioning profile
    # 3) Enter team manually with option to skip
    if [ -f ${OVERRIDE_FULLPATH} ] && grep -q "^$DEV_TEAM_SETTING_NAME" ${OVERRIDE_FULLPATH}; then
        # how_to_find_your_id
        report_persistent_config_override
    else
        PROFILES_DIR="$HOME/Library/MobileDevice/Provisioning Profiles"

        if [ -d "${PROFILES_DIR}" ]; then
            latest_file=$(find "${PROFILES_DIR}" -type f -name "*.mobileprovision" -print0 | xargs -0 ls -t | head -n1)
            if [ -n "$latest_file" ]; then
                # Decode the .mobileprovision file using the security command
                decoded_xml=$(security cms -D -i "$latest_file")

                # Extract the Team ID from the XML
                DEVELOPMENT_TEAM=$(echo "$decoded_xml" | awk -F'[<>]' '/<key>TeamIdentifier<\/key>/ { getline; getline; print $3 }')
            fi
        fi

        if [ -n "$DEVELOPMENT_TEAM" ]; then
            echo -e "Using TeamIdentifier from the latest provisioning profile\n"
            set_development_team "$DEVELOPMENT_TEAM"
            report_persistent_config_override
        else
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
        fi
    fi
}

function verify_xcode_path() {
    section_separator

    echo -e "Verifying xcode-select path...\n"

    # Get the path set by xcode-select
    xcode_path=$(xcode-select -p)

    # Check if the path contains "Xcode.app"
    if [[ "$xcode_path" == *Xcode.app* ]]; then
        echo -e "${GREEN}xcode-select path is correctly set: $xcode_path${NC}"
        echo -e "Continuing the script..."
        sleep 2
    else
        echo -e "${RED}${BOLD}xcode-select is not pointing to the correct Xcode path."
        echo -e "     It is set to: $xcode_path${NC}"
        echo -e "Please choose an option below to proceed:\n"
        options=("Correct xcode-select path" "Skip" "Quit Script")
        select opt in "${options[@]}"
        do
            case $opt in
                "Correct xcode-select path")
                    echo -e "You might be prompted for your password."
                    echo -e "  Use the password for logging into your Mac."
                    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

                    # Check if the path was corrected successfully
                    xcode_path=$(xcode-select -p)
                    if [[ "$xcode_path" == *Xcode.app* ]]; then
                        echo -e "✅ xcode-select path has been corrected."
                        return_when_ready
                        break
                    else
                        echo -e "${RED}❌ Failed to set xcode-select path correctly.${NC}"
                        exit_message
                    fi
                    ;;
                "Skip")
                    break
                    ;;
                "Quit Script")
                    cancel_entry
                    ;;
                *) # Invalid option
                    invalid_entry
                    ;;
            esac
        done
    fi
}

# call functions that are always used
# initial_greeting

############################################################
# End of functions used by script
#    - end of helper_functions.sh common code
############################################################
