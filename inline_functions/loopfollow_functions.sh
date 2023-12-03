############################################################
# Special functions used by LoopFollow build script
############################################################

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
    # Check if the target file exists
    if [ -f "$target_file" ]; then
        # If it exists, remove the current file
        rm -f "$current_file"

        # Report current display name
        echo -e "${INFO_FONT}Display name file exists: ${NC}"
    else
        # If it doesn't exist, move the current file to the target location
        mv "$current_file" "$target_file"

        echo -e "${INFO_FONT}Display name set to default: ${NC}"
        tail -1 "$target_file"
        echo -e ""
        options=("Use Default" "Modify Display Name")
        select opt in "${options[@]}"
        do
            case $opt in
                "Use Default")
                    break
                    ;;
                "Modify Display Name")
                    read -p "Enter desired display name to show on Follow app: " looperID
                    sed -i '' "s|${default_display_name}|${looperID}|"  "$target_file"
                    break
                    ;;
            esac
        done
    fi
    echo "// The original file has been moved to $target_file. Please edit the display name there." > "$current_file"

    echo -e ""
    # Update Config.xcconfig
    local config_file="Config.xcconfig"
    local include_line="#include? \"$target_file\""

    # Replace the include line with the new target file
    # sed -i '' "s|#include\? \"\.\./\.\./${base_target}\.xcconfig\"|$include_line|" "$config_file"
    sed -i '' "s|\"\.\./\.\./${base_target}|\"\.\./\.\./${base_target_name}|" "$config_file"

    # report the display name and provide editing instructions
    tail -1 "$target_file"
    echo -e "To modify the display_name, edit this file before you continue:"
    echo -e "${target_file}"
    echo -e ""
    return_when_ready

    cd ..
}

############################################################
# End of functions used by LoopFollow build script
############################################################
