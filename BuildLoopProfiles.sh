#!/bin/bash # script BuildLoopProfiles.sh
# -----------------------------------------------------------------------------
# This file is GENERATED. DO NOT EDIT directly.
# If you want to modify this file, edit the corresponding file in the src/
# directory and then run the build script to regenerate this output file.
# -----------------------------------------------------------------------------

############################################################
# Required parameters for any build script that uses
#   inline build_functions
############################################################

BUILD_DIR=~/Downloads/BuildLoop
OVERRIDE_FILE=LoopConfigOverride.xcconfig
DEV_TEAM_SETTING_NAME="LOOP_DEVELOPMENT_TEAM"


# *** Start of inlined file: src/build_functions.sh ***

# *** Start of inlined file: src/common.sh ***
STARTING_DIR="${PWD}"

############################################################
# define some font styles and colors
############################################################

# remove special font
NC='\033[0m'
# add special font
#INFO_FONT='\033[1;36m'
INFO_FONT='\033[1m'
SUCCESS_FONT='\033[1;32m'
ERROR_FONT='\033[1;31m'

function section_divider() {
    echo -e ""
    echo -e "--------------------------------"
    echo -e ""
}

function section_separator() {
    clear
    section_divider
}

function return_when_ready() {
    echo -e "${INFO_FONT}Return when ready to continue${NC}"
    read -p "" dummy
}

# Skip if this script is called from another script, then this has already been displayed
if [ "$0" != "_" ]; then
    # Inform the user about env variables set
    # Variables definition
    variables=(
        "SCRIPT_BRANCH: Indicates the loopbuildscripts branch in use."
        "LOCAL_SCRIPT: Set to 1 to run scripts from the local directory."
        "FRESH_CLONE: Lets you use an existing clone (saves time)."
        "CLONE_STATUS: Can be set to 0 for success (default) or 1 for error."
        "SKIP_OPEN_SOURCE_WARNING: If set, skips the open source warning for build scripts."
        "CUSTOM_URL: Overrides the repo url."
        "CUSTOM_BRANCH: Overrides the branch used for git clone."
        "CUSTOM_MACOS_VER: Overrides the detected macOS version."
        "CUSTOM_XCODE_VER: Overrides the detected Xcode version."
        "DELETE_SELECTED_FOLDERS: Echoes folder names but does not delete them"
    )

    # Flag to check if any variable is set
    any_variable_set=false

    # Iterate over each variable
    for var in "${variables[@]}"; do
        # Split the variable name and description
        IFS=":" read -r name description <<<"$var"

        # Check if the variable is set
        if [ -n "${!name}" ]; then
            # If this is the first variable set, print the initial message
            if ! $any_variable_set; then
                section_separator
                echo -e "For your information, you are running this script in customized mode"
                echo -e "You might be using a branch other than main, and using SCRIPT_BRANCH"
                echo -e "Developers might have additional environment variables set:"
                any_variable_set=true
            fi

            # Print the variable name, value, and description
            echo "  - $name: ${!name}"
            echo "    $description"
        fi
    done
    if $any_variable_set; then
        echo -e "\nTo clear the values, close this terminal and start a new one."
        return_when_ready
    fi
fi

function choose_option() {
    echo -e "Type a number from the list below and return to proceed."
    section_divider
}

function invalid_entry() {
    echo -e "\n${ERROR_FONT}Invalid option${NC}\n"
}

function do_continue() {
    :
}

function menu_select() {
    choose_option

    local options=("${@:1:$#/2}")
    local actions=("${@:$(($# + 1))/2+1}")

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

function exit_or_return_menu() {
    if [ "$0" != "_" ]; then
        # Called directly
        echo "Exit Script"
    else
        # Called from BuildSelectScript
        echo "Return to Menu"
    fi
}

function exit_script() {
    if [ "$0" != "_" ]; then
        # Called directly
        exit_message
    else
        # Called from BuildSelectScript
        exit 0
    fi
}

function exit_message() {
    section_divider
    echo -e "${INFO_FONT}Exit from Script${NC}\n"
    echo -e "  You may close the terminal"
    echo -e "or"
    echo -e "  You can press the up arrow ⬆️  on the keyboard"
    echo -e "    and return to repeat script from beginning"
    section_divider
    exit 0
}
# *** End of inlined file: src/common.sh ***


############################################################
# Common functions used by multiple build scripts
#    - Explanation of variables, Default values
############################################################

# Variables set by BuildXXX script that calls this inline script
#
# Required: BUILD_DIR
#    it is where the download folder will be created
#    For example: BUILD_DIR=~/Downloads/BuildLoop
#
# Required: OVERRIDE_FILE
#    name of the automatic signing file
#    For example: OVERRIDE_FILE=LoopConfigOverride.xcconfig

# Required: DEV_TEAM_SETTING_NAME
#    keyword used in the automatic signing file
#    e.g., ${DEV_TEAM_SETTING_NAME} = Apple Developer TeamID
#    Loop and Loop associated apps use: "LOOP_DEVELOPMENT_TEAM"
#    iAPS uses: "DEVELOPER_TEAM"

# Default: some projects create or use the override file in the BUILD_DIR
# Some, like iAPS, use a file in the downloaded clone itself
#    in that case, set USE_OVERRIDE_IN_REPO to 1 in the src/Build script
: ${USE_OVERRIDE_IN_REPO:="0"}

# Default: some projects use submodules (and need --recurse-submodule)
# Some, like iAPS and LoopFollow, do not use submodules
#    in that case, set CLONE_SUB_MODULES to 0 in the src/Build script
: ${CLONE_SUB_MODULES:="1"}

# Accept build_warning before creating folders

# *** Start of inlined file: src/build_warning.sh ***
############################################################
# warning used by all scripts that build an app
############################################################

function open_source_warning() {
    # Skip open source warning if opted out using env variable or this script is run from another script
    if [ "${SKIP_OPEN_SOURCE_WARNING}" = "1" ] || [ "$0" = "_" ]; then return; fi

    local documentation_link="${1:-}"

    section_separator

    echo -e "${INFO_FONT}*** IMPORTANT ***${NC}\n"
    echo -e "This project is:"
    echo -e "${INFO_FONT}  Open Source software"
    echo -e "  Not \"approved\" for therapy${NC}"
    echo -e ""
    echo -e "  You take full responsibility when you build"
    echo -e "  or run an open source app, and"
    echo -e "  ${INFO_FONT}you do so at your own risk.${NC}"
    echo -e ""
    echo -e "To increase (decrease) font size"
    echo -e "  Hold down the CMD key and hit + (-)"
    echo -e "\n${INFO_FONT}By typing 1 and ENTER, you indicate you understand"
    echo -e "\n--------------------------------\n${NC}"

    options=("Agree" "Cancel")
    select opt in "${options[@]}"; do
        case $opt in
        "Agree")
            break
            ;;
        "Cancel")
            echo -e "\n${INFO_FONT}User did not agree to terms of use.${NC}\n\n"
            exit_script
            ;;
        *)
            echo -e "\n${INFO_FONT}User did not agree to terms of use.${NC}\n\n"
            invalid_entry
            exit_script
            ;;
        esac
    done

    # Warning has been issued
    SKIP_OPEN_SOURCE_WARNING=1

    echo -e "${NC}\n\n\n\n"
}
# *** End of inlined file: src/build_warning.sh ***


# Messages prior to opening xcode

# *** Start of inlined file: src/before_final_return_message.sh ***
function before_final_return_message() {
    # Default (no argument) prints watch message
    # An other argument, skips watch message
    local default_watch_flag="include_watch_message"
    local watch_flag=${1:-$default_watch_flag}
    echo ""
    echo -e "${INFO_FONT}BEFORE you hit return:${NC}"
    echo " *** Unlock your phone and plug it into your computer"
    echo "     Trust computer if asked"
    if [ "$watch_flag" = "$default_watch_flag" ]; then
        echo -e " *** Optional: For Apple Watch - if you never built app on it"
        echo -e "               Watch paired to phone and unlocked (on your wrist)"
        echo -e "               Trust computer if asked"
    fi
    ios16_warning
    echo ""
    echo -e "${INFO_FONT}Xcode will open automatically after you hit return${NC}"
    echo "  Upper middle of Xcode:"
    echo "    Confirm your phone or simulator choice is selected"
    echo "  Upper right of Xcode:"
    echo "    Wait for packages to finish being copied or downloaded"
    echo "    When you see indexing, you can build to phone or simulator"
    echo "  Click on Play button or Command-B or Xcode Menu: Product, Build"
}
# *** End of inlined file: src/before_final_return_message.sh ***


############################################################
# Common functions used by multiple build scripts
#    - Start of build_functions.sh common code
############################################################

SCRIPT_DIR="${BUILD_DIR}/Scripts"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi

############################################################
# set up nominal values
#   these can be later overwritten by flags
#   for convenience when testing (or for advanced users)
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

# This enables the selection of a custom branch via enviroment variable
# It can also be passed in as argument $1
#   If passed in, it overwrites the environment variable
#   When CUSTOM_BRANCH is set, the menu which asks which branch is skipped
CUSTOM_BRANCH=${1:-$CUSTOM_BRANCH}

############################################################
# Define the rest of the functions (usage defined above):
############################################################


# *** Start of inlined file: src/building_verify_version.sh ***
#This should be the latest iOS version
#This is the version we expect users to have on their iPhones
LATEST_IOS_VER="16.5"

#This should be the lowest xcode version required to build to LATEST_IOS_VER
LOWEST_XCODE_VER="14.3"

#This should be the latest known xcode version
#LOWEST_XCODE_VER and LATEST_XCODE_VER will probably be equal but we should have suport for a span of these
LATEST_XCODE_VER="14.3"

#This is the lowest version of macOS required to run LATEST_XCODE_VER
LOWEST_MACOS_VER="13.0"

# The compare_versions function takes two version strings as input arguments,
# sorts them in ascending order using the sort command with the -V flag (version sorting),
# and returns the first version (i.e., the lowest one) using head -n1.
#
# Example:
# compare_versions "1.2.3" "1.1.0" will return "1.1.0"
function compare_versions() {
    printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1
}

function check_versions() {
    section_divider
    echo "Verifying Xcode and macOS versions..."

    if ! command -v xcodebuild >/dev/null; then
        echo "Xcode not found. Please install Xcode and try again."
        exit_or_return_menu
    fi

    if [ -n "$CUSTOM_XCODE_VER" ]; then
        XCODE_VER="$CUSTOM_XCODE_VER"
    else
        XCODE_VER=$(xcodebuild -version | awk '/Xcode/{print $NF}')
    fi

    if [ -n "$CUSTOM_MACOS_VER" ]; then
        MACOS_VER="$CUSTOM_MACOS_VER"
    else
        MACOS_VER=$(sw_vers -productVersion)
    fi

    echo "Xcode found: Version $XCODE_VER"

    # Check if Xcode version is greater than the latest known version
    if [ "$(compare_versions "$XCODE_VER" "$LATEST_XCODE_VER")" = "$LATEST_XCODE_VER" ] && [ "$XCODE_VER" != "$LATEST_XCODE_VER" ]; then
        echo "You have a newer Xcode version ($XCODE_VER) than the latest known by this script ($LATEST_XCODE_VER)."
        echo "Please verify your versions using https://www.loopandlearn.org/version-updates/ and https://developer.apple.com/support/xcode/"

        options=("Continue" "Exit")
        actions=("return" "exit_or_return_menu")
        menu_select "${options[@]}" "${actions[@]}"
    # Check if Xcode version is less than the lowest required version
    elif [ "$(compare_versions "$XCODE_VER" "$LOWEST_XCODE_VER")" = "$XCODE_VER" ] && [ "$XCODE_VER" != "$LOWEST_XCODE_VER" ]; then
        if [ "$(compare_versions "$MACOS_VER" "$LOWEST_MACOS_VER")" != "$LOWEST_MACOS_VER" ]; then
            echo "Your macOS version ($MACOS_VER) is lower than $LOWEST_MACOS_VER. Please update macOS to version $LOWEST_MACOS_VER or later."
            echo "If you can't update, follow the GitHub build option here: https://loopkit.github.io/loopdocs/gh-actions/gh-overview/"
        fi

        echo "You need to upgrade Xcode to version $LOWEST_XCODE_VER or later to build for iOS $LATEST_IOS_VER."

        options=("Continue with lower iOS version" "Exit")
        actions=("return" "exit_or_return_menu")
        menu_select "${options[@]}" "${actions[@]}"
    else 
        echo "You have a Xcode version ($XCODE_VER) which can build for iOS $LATEST_IOS_VER."
    fi
}
# *** End of inlined file: src/building_verify_version.sh ***


# *** Start of inlined file: src/building_config_override.sh ***
function check_config_override_existence_offer_to_configure() {
    section_separator

    # Automatic signing functionality:
    # 1) Use existing Override file
    # 2) Copy team from latest provisioning profile
    # 3) Enter team manually with option to skip

    # Options for USE_OVERRIDE_IN_REPO
    #  0 means copy file in repo up 2 levels and use that
    #  1 create the file in the repo and add development team
    #  2 create the file in the repo with extra line(s) and the team
    if [[ $USE_OVERRIDE_IN_REPO -ge 1 ]]; then
        OVERRIDE_FULLPATH="${LOCAL_DIR}/$REPO_NAME/${OVERRIDE_FILE}"
    else
        OVERRIDE_FULLPATH="${BUILD_DIR}/${OVERRIDE_FILE}"
    fi

    if [ -f ${OVERRIDE_FULLPATH} ] && \
        grep -q "^$DEV_TEAM_SETTING_NAME" ${OVERRIDE_FULLPATH}; then
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
            choose_option
            options=("Sign Automatically" "Sign Manually" "$(exit_or_return_menu)")
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
                    "$(exit_or_return_menu)")
                        exit_script
                        ;;
                    *) # Invalid option
                        invalid_entry
                        ;;
                esac
            done
        fi
    fi
}

function report_persistent_config_override() {
    echo -e "Your Apple Developer ID was found automatically:"
    grep "^$DEV_TEAM_SETTING_NAME" ${OVERRIDE_FULLPATH}
    echo -e "\nIf that is correct your app will be automatically signed\n"
    options=("ID is OK" "Editing Instructions" "$(exit_or_return_menu)")
    select opt in "${options[@]}"
    do
        case $opt in
            "ID is OK")
                break
                ;;
            "Editing Instructions")
                section_divider
                echo -e " Part 1: How to find your Apple Developer ID"
                echo -e ""
                how_to_find_your_id
                echo -e ""
                echo -e " Part 2: Edit the automatic signing file before hitting return"
                echo -e "   step 1: open finder, "
                echo -e "   step 2: locate and double click on"
                echo -e "           ${OVERRIDE_FULLPATH/$HOME/~}"
                echo -e "           to open that file in Xcode"
                echo -e "   step 3: find the line that starts with "
                echo -e "           ${DEV_TEAM_SETTING_NAME}="
                echo -e "           and modify the value to be your "
                echo -e "           Apple Developer ID"
                echo -e "   step 4: save the file"
                echo -e ""
                echo -e " When ready to proceed, hit return"
                return_when_ready
                break
                ;;
            "$(exit_or_return_menu)")
                exit_script
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
    if [[ $USE_OVERRIDE_IN_REPO == "0" ]] && 
       [[ -f "${LOCAL_DIR}/$REPO_NAME/${OVERRIDE_FILE}" ]]; then
        cp -p "${LOCAL_DIR}/$REPO_NAME/${OVERRIDE_FILE}" "${OVERRIDE_FULLPATH}"
    elif [[ $USE_OVERRIDE_IN_REPO == "1" ]] || \
         [[ $USE_OVERRIDE_IN_REPO == "2" ]]; then
        echo "// Automatic Signing File" > ${OVERRIDE_FULLPATH}
    fi
    if [[ $USE_OVERRIDE_IN_REPO == "2" ]]; then
        for str in ${ADDED_LINE_FOR_OVERRIDE[@]}; do
            echo "$str" >> ${OVERRIDE_FULLPATH}
         done
    fi
    echo "$DEV_TEAM_SETTING_NAME = $team_id" >> ${OVERRIDE_FULLPATH}
}

# *** End of inlined file: src/building_config_override.sh ***


function standard_build_train() { 
    verify_xcode_path
    check_versions
    clone_repo
    automated_clone_download_error_check
    check_config_override_existence_offer_to_configure
    ensure_a_year
}

function ensure_a_year() {
    section_separator

    echo -e "${INFO_FONT}Ensure a year by deleting old provisioning profiles${NC}"
    echo -e "  Unless you have a specific reason, choose option 1\n"
    options=("Ensure a Year" "Skip" "$(exit_or_return_menu)")
    select opt in "${options[@]}"
    do
        case $opt in
            "Ensure a Year")
                rm -rf ~/Library/MobileDevice/Provisioning\ Profiles
                echo -e "✅ ${SUCCESS_FONT}Profiles were cleaned${NC}"
                echo -e "   Next app you build with Xcode will last a year"
                break
                ;;
            "Skip")
                break
                ;;
            "$(exit_or_return_menu)")
                exit_script
                ;;
            *) # Invalid option
                invalid_entry
                ;;
        esac
    done
}

function ios16_warning() {
    echo -e "\n${INFO_FONT}If you have iOS 16, you must enable Developer Mode${NC}"
    echo -e "${INFO_FONT}  Phone Settings->Privacy & Security${NC}"
    echo -e "  https://loopkit.github.io/loopdocs/build/step14/#prepare-your-phone-and-watch"
}

function clone_repo() {
    section_divider
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
        if [[ $CLONE_SUB_MODULES == "1" ]]; then
            echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
            git clone --branch=$BRANCH --recurse-submodules $REPO
        else
            echo -e "    git clone --branch=${BRANCH} ${REPO}"
            git clone --branch=$BRANCH $REPO
        fi
        clone_exit_status=$?
    else
        clone_exit_status=${CLONE_STATUS}
    fi
}

function automated_clone_download_error_check() {
    # Check if the clone was successful
    if [ $clone_exit_status -eq 0 ]; then
        # Use this flag to modify exit_or_return_menu
        echo -e "✅ ${SUCCESS_FONT}Successful Download. Proceed to the next step...${NC}"
        return_when_ready
    else
        echo -e "❌ ${ERROR_FONT}An error occurred during download. Please investigate the issue.${NC}"
        exit_or_return_menu
    fi
}

function verify_xcode_path() {
    section_divider

    echo -e "Verifying xcode-select path...\n"

    # Get the path set by xcode-select
    xcode_path=$(xcode-select -p)

    # Check if the path contains "Xcode.app"
    if [[ -x "$xcode_path/usr/bin/xcodebuild" ]]; then
        echo -e "✅ ${SUCCESS_FONT}xcode-select path correctly set: $xcode_path${NC}"
        echo -e "Continuing the script..."
    else
        echo -e "❌ ${ERROR_FONT}xcode-select is not pointing to the correct Xcode path."
        echo -e "     It is set to: $xcode_path${NC}"
        echo -e "Please choose an option below to proceed:\n"
        options=("Correct xcode-select path" "Skip" "$(exit_or_return_menu)")
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
                        echo -e "✅ ${SUCCESS_FONT}xcode-select path has been corrected.${NC}"
                        return_when_ready
                        break
                    else
                        echo -e "❌ ${ERROR_FONT}Failed to set xcode-select path correctly.${NC}"
                        exit_or_return_menu
                    fi
                    ;;
                "Skip")
                    break
                    ;;
                "$(exit_or_return_menu)")
                    exit_script
                    ;;
                *) # Invalid option
                    invalid_entry
                    ;;
            esac
        done
    fi
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
# *** End of inlined file: src/build_functions.sh ***


############################################################
# The rest of this is specific to the particular script
############################################################

open_source_warning


URL_THIS_SCRIPT="https://github.com/bjorkert/LoopWorkspace.git"
branch_select ${URL_THIS_SCRIPT} profiles Loop_profiles

section_separator
echo -e "${INFO_FONT}You are running the script for the development version for Loop"
echo -e "  with profiles functionality.${NC}"
echo
echo "  You should be following zulipchat and have read LoopDocs:"
echo
echo "https://loopkit.github.io/loopdocs/faqs/branch-faqs/#whats-going-on-in-the-dev-branch"
echo
echo -e "${INFO_FONT}Be aware that a development version may require frequent rebuilds${NC}"
section_divider

options=("Continue" "$(exit_or_return_menu)")
actions=(":" "exit_script")
menu_select "${options[@]}" "${actions[@]}"

############################################################
# Standard Build train
############################################################

standard_build_train

############################################################
# Open Xcode
############################################################

section_divider
before_final_return_message
echo -e ""
return_when_ready
cd $REPO_NAME
xed . 
exit_script
# *** End of inlined file: src/BuildLoopProfiles.sh ***

