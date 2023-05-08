#!/bin/bash # script BuildLoopCaregiver.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------

############################################################
# this code must be repeated in any build script that uses build_functions.sh
############################################################

BUILD_DIR=~/Downloads/"BuildLoop"
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"

############################################################
# Common functions used by multiple build scripts
#    - Start of build_functions.sh common code
############################################################

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

# Prepare date-time stamp for folder
DOWNLOAD_DATE=$(date +'%y%m%d-%H%M')

# BUILD_DIR=~/Downloads/"BuildLoop"
# OVERRIDE_FILE=LoopConfigOverride.xcconfig
OVERRIDE_FULLPATH="${BUILD_DIR}/${OVERRIDE_FILE}"

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
    # Skip initial greeting if already displayed or opted out using env variable
    if [ "${SKIP_INITIAL_GREETING}" = "1" ]; then return; fi
    SKIP_INITIAL_GREETING=1

    local documentation_link="${1:-}"

    section_separator
    echo -e "${RED}${BOLD}*** IMPORTANT ***${NC}\n"
    echo -e "${BOLD}This project is:${RED}${BOLD}"
    echo -e "  Open Source software"
    echo -e "  Not \"approved\" for therapy\n"

    echo -e "  You take full responsibility for reading and"
    if [ -n "${documentation_link}" ]; then
        echo -e "  understanding the documentation found at"
        echo -e "      ${documentation_link},"
    else
        echo -e "  understanding the documentation"
    fi
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
    exit 0
}

function return_when_ready() {
    echo -e "${RED}${BOLD}Return when ready to continue${NC}"
    read -p "" dummy
}

function ensure_a_year() {
    section_separator

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
    echo -e "\n${RED}${BOLD}If you have iOS 16, you must enable Developer Mode${NC}"
    echo -e "${RED}${BOLD}  Phone Settings->Privacy & Security${NC}"
    echo -e "  https://loopkit.github.io/loopdocs/build/step14/#prepare-your-phone-and-watch"
}

function clone_repo() {
    section_separator
    if [ "$SUPPRESS_BRANCH" == "true" ]; then
        LOCAL_DIR="${BUILD_DIR}/${APP_NAME}-${DOWNLOAD_DATE}"
    else
        LOCAL_DIR="${BUILD_DIR}/${APP_NAME}_${BRANCH}-${DOWNLOAD_DATE}"
    fi
    if [ ${FRESH_CLONE} == 1 ]; then
        mkdir "${LOCAL_DIR}"
    else
        LOCAL_DIR="${STARTING_DIR}"
    fi
    cd "${LOCAL_DIR}"
    if [ ${FRESH_CLONE} == 1 ]; then
        if [ "$SUPPRESS_BRANCH" == "true" ]; then
            echo -e " -- Downloading ${APP_NAME} to your Downloads folder --"
        else
            echo -e " -- Downloading ${APP_NAME} ${BRANCH} to your Downloads folder --"
        fi
        echo -e "      ${LOCAL_DIR}\n"
        echo -e "Issuing this command:"
        echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
        git clone --branch=$BRANCH --recurse-submodules $REPO
        clone_exit_status=$?
    else
        clone_exit_status=${CLONE_STATUS}
    fi
}

function automated_clone_download_error_check() {
    # Check if the clone was successful
    if [ $clone_exit_status -eq 0 ]; then
        # Use this flag to modify exit_message
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
    echo -e " *** Optional: For Apple Watch - if you never built app on it"
<<<<<<< HEAD
    echo -e "              Pair watch to phone, unlocked and on your wrist"
    echo -e "              Trust computer if asked"
=======
    echo -e "               Pair watch to phone, unlocked and on your wrist"
    echo -e "               Trust computer if asked"
>>>>>>> new_buildfunctions
    ios16_warning
}

function before_final_return_message_without_watch() {
    echo -e "\n${RED}${BOLD}BEFORE you hit return:${NC}"
    echo -e " *** Unlock your phone and plug it into your computer"
    echo -e "     Trust computer if asked"
    ios16_warning
}

function report_persistent_config_override() {
    echo -e "Your Apple Developer ID was found automatically:"
    grep "^$DEV_TEAM_SETTING_NAME" ${OVERRIDE_FULLPATH}
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
                echo -e "     step 1: open finder, navigate to ${BUILD_DIR#*Users/*/}"
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
        # For other apps, create file with developer ID
        set_development_team $devID
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

function do_continue() {
  :
}

function menu_select() {
    choose_or_cancel

    local options=("${@:1:$#/2}")
    local actions=("${@:$(($#+1))/2+1}")

    while true; do
        select opt in "${options[@]}"; do
            for i in $(seq 0 $((${#options[@]} - 1))); do
                if [ "$opt" = "${options[$i]}" ]; then
                    eval "${actions[$i]}"
                    return
                fi
            done
            invalid_entry
            break
        done
    done
}

function delete_folders_except_latest() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))
    local total_size=0

    section_separator
    if [ ${#folders[@]} -le 1 ]; then
        echo "No folders to delete for pattern '$pattern'"
        return
    fi

    echo "Preserved folder for pattern '$pattern':"
    echo "${folders[0]}"
    echo

    echo "Folders to delete for pattern '$pattern':"
    for folder in "${folders[@]:1}"; do
        echo "$folder"
        total_size=$(($total_size + $(du -s "$folder" | awk '{print $1}')))
    done

    total_size_mb=$(echo "scale=2; $total_size / 1024" | bc)
    echo "Total size to be deleted: $total_size_mb MB"

    options=("Delete" "Keep" "Quit")
    actions=("delete_selected_folders \"$pattern\"" "return" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
}

function delete_selected_folders() {
    local pattern="$1"
    local folders=($(ls -dt ~/Downloads/$pattern))

    for folder in "${folders[@]:1}"; do
        #rm -rf "$folder"
        echo "now this folder would have been removed with: rm -rf $folder"
    done

    echo "Folders deleted."
}

function delete_old_downloads() {
    patterns=(
        "BuildLoopFollow/LoopFollow-*"
        "Build_iAPS/iAPS-*"
        "BuildLoop/Loop-*"
        "BuildLoop/LoopCaregiver-*"
        "BuildLoop/Loop_lnl_patches-*"
    )

    for pattern in "${patterns[@]}"; do
        delete_folders_except_latest "$pattern"
    done
    
    exit_message
}

function branch_select() {
    local url=$1
    local branch=$2
    local repo_name=$(basename $url .git)
    local app_name=${3:-$(basename $url .git)}
    local suppress_branch=${3:+true}

    REPO=$url
    BRANCH=$branch
    REPO_NAME=$repo_name
    APP_NAME=$app_name
    SUPPRESS_BRANCH=$suppress_branch
}

############################################################
# End of functions used by script
#    - end of build_functions.sh common code
############################################################


############################################################
# The rest of this is specific to  BuildLoopCaregiver.sh
############################################################

initial_greeting


############################################################
# Welcome & Branch Selection
############################################################

function choose_dev_branch() {
    branch_select https://github.com/LoopKit/LoopCaregiver.git dev
}

if [ -z "$CUSTOM_BRANCH" ]; then
    section_separator
    echo -e "\n ${RED}${BOLD}You are running the script for LoopCaregiver (LCG)"
    echo -e " This app is under development and may require frequent builds${NC}"
    echo -e " If you have not read this section of LoopDocs - please review before continuing"
    echo -e "    https://loopkit.github.io/loopdocs/nightscout/remote-overrides"
    echo -e " If you have not joined zulipchat Loop Caregiver App stream - do so now"
    echo -e "    https://loop.zulipchat.com/#narrow/stream/358458-Loop-Caregiver-App"

    options=("Continue" "Cancel")
    actions=("choose_dev_branch" "cancel_entry")
    menu_select "${options[@]}" "${actions[@]}"
else
    branch_select https://github.com/LoopKit/LoopCaregiver.git $CUSTOM_BRANCH
fi

############################################################
# Standard Build train
############################################################

verify_xcode_path
clone_repo
automated_clone_download_error_check
check_config_override_existence_offer_to_configure
ensure_a_year


############################################################
# Open Xcode
############################################################

section_separator
echo -e "The following item will open (when you are ready)"
echo -e "* Xcode ready to prep your current download for build"
before_final_return_message_without_watch
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_message
