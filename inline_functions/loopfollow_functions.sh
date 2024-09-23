############################################################
# Special functions used by LoopFollow build script
############################################################

function display_name_suggestion() {
    # Display this message only once per call to BuildLoopFollow.sh
    echo ""
    if [ "${SKIP_DISPLAY_NAME_INFORMATION}" = "1" ]; then return; fi
    echo "The display name replaces the follow app name on the phone"
    echo "  and can be displayed on the home screen of the follow app"
    echo ""
    echo "  To assist in finding the renamed app in iOS Settings,"
    echo "    you might want to use LF as a prefix."
    echo "  For example: LF George"
    echo ""
    SKIP_DISPLAY_NAME_INFORMATION=1
}

function loop_follow_display_name_config_override() {
    cd "$REPO_NAME"
    # Define the base file names
    local current_file="LoopFollowDisplayNameConfig.xcconfig"
    local base_target="LoopFollowDisplayNameConfig"
    local default_display_name="LoopFollow"
    local target_file
    local base_target_name

    # Check the value of REPO_NAME and set the target_file accordingly
    case $REPO_NAME in
        "LoopFollow_Second")
            base_target_name="${base_target}_Second"
            default_display_name="${default_display_name}_Second"
            ;;
        "LoopFollow_Third")
            base_target_name="${base_target}_Third"
            default_display_name="${default_display_name}_Third"
            ;;
        *)
            base_target_name="${base_target}"
            ;;
    esac
    target_file="${BUILD_DIR}/${base_target_name}.xcconfig"


    section_divider
    # Check if the target (display_name) file exists
    if [ -f "$target_file" ]; then
        # If it exists, remove the file downloaded from repo
        # It will be replaced
        rm -f "$current_file"
        # Report current display name
        echo -e "${INFO_FONT}Display name file exists: ${NC}"
    else
        # Ask user for their display_name preference
        echo -e "${INFO_FONT}Display name set to default value of:${NC}"
        echo -e "${INFO_FONT}    ${default_display_name}${NC}"
        echo -e ""
        options=("Use Default" "Modify Display Name")
        select opt in "${options[@]}"
        # If user quits out of script, target not created, available for next attempt
        # Move the current file to the target location
        do
            mv "$current_file" "$target_file"
            case $opt in
                "Use Default")
                    break
                    ;;
                "Modify Display Name")
                    display_name_suggestion
                    read -p "Enter desired display name to show on Follow app: " looperID
                    sed -i '' "s|display_name = ${default_display_name}|display_name = ${looperID}|"  "$target_file"
                    break
                    ;;
            esac
        done
    fi
    echo "// The original file has been moved to:" > "$current_file"
    echo "//   $target_file" >> "$current_file"
    echo "//   Please edit the display name there." >> "$current_file"
    echo -e ""

    # Update Config.xcconfig to point to appropriate display_name file
    local config_file="Config.xcconfig"
    local include_line="#include? \"$target_file\""

    # Replace the include line with the new target file
    sed -i '' "s|\"\.\./\.\./${base_target}|\"\.\./\.\./${base_target_name}|" "$config_file"

    # report the display name and provide editing instructions
    tail -1 "$target_file"
    echo ""
    echo -e "To modify the display_name, edit this file before you continue:"
    echo -e "${target_file}"
    display_name_suggestion
    return_when_ready

    cd ..
}

############################################################
# End of functions used by LoopFollow build script
############################################################
