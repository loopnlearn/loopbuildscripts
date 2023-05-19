#!inline common.sh

############################################################
# used by all scripts that build an app
############################################################

function open_source_warning() {
    echo "inside open_source_warning"
    echo "SKIP_OPEN_SOURCE_WARNING = ${SKIP_OPEN_SOURCE_WARNING}"
    # Skip initial greeting if opted out using env variable or previously used
    if [ "${SKIP_OPEN_SOURCE_WARNING}" = "1" ]; then return; fi

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
            exit_message
            ;;
        *)
            echo -e "\n${INFO_FONT}User did not agree to terms of use.${NC}\n\n"
            exit_message
            ;;
        esac
    done

    # Warning has been issued
    SKIP_OPEN_SOURCE_WARNING=1

    echo -e "${NC}\n\n\n\n"
}

function choose_or_cancel() {
    echo -e "Type a number from the list below and return to proceed."
    echo -e "${INFO_FONT}  To cancel, any entry not in list also works${NC}"
    section_divider
}

function cancel_entry() {
    echo -e "\n${INFO_FONT}User canceled${NC}\n"
    exit_message
}

function invalid_entry() {
    echo -e "\n${ERROR_FONT}User canceled by entering an invalid option${NC}\n"
    exit_message
}

function exit_message() {
    section_divider
    echo -e "${SUCCESS_FONT}Shell Script Completed${NC}"
    echo -e " * You may close the terminal window now if you want"
    echo -e " or"
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
