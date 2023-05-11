STARTING_DIR="${PWD}"

############################################################
# define some font styles and colors
############################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

function section_divider() {
    echo -e "--------------------------------\n"
}

function section_separator() {
    clear
    section_divider
}

function return_when_ready() {
    echo -e "${RED}${BOLD}Return when ready to continue${NC}"
    read -p "" dummy
}

# Inform the user about env variables set, but only once
if [ -z ${any_variable_set+x} ]; then
    # Variables definition
    variables=(
        "SCRIPT_BRANCH: The branch other scripts will be sourced from."
        "FRESH_CLONE: Lets you use an existing clone (saves time)."
        "CLONE_STATUS: Can be set to 0 for success (default) or 1 for error."
        "SKIP_INITIAL_GREETING: If set, skips the initial greeting when running the script."
        "CUSTOM_URL: Overrides the repo url."
        "CUSTOM_BRANCH: Overrides the branch used for git clone."
        "CUSTOM_MACOS_VER: Overrides the detected macOS version."
        "CUSTOM_XCODE_VER: Overrides the detected Xcode version."
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
                echo -e "with environment variables set:"
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
    select opt in "${options[@]}"; do
        case $opt in
        "Agree")
            break
            ;;
        "Cancel")
            echo -e "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n"
            exit_message
            ;;
        *)
            echo -e "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n"
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

function do_continue() {
    :
}

function menu_select() {
    choose_or_cancel

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
