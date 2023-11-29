############################################################
# Special functions used by LoopFollow build script
############################################################

function loop_follow_display_name_config_override() {
    cd "$REPO_NAME"
    # Define the base file names
    local current_file="LoopFollowDisplayNameConfig.xcconfig"
    local base_target_file="LoopFollowDisplayNameConfig"
    local target_file

    # Check the value of REPO_NAME and set the target_file accordingly
    case $REPO_NAME in
        "LoopFollow_Second")
            target_file="${BUILD_DIR}/${base_target_file}_Second.xcconfig"
            ;;
        "LoopFollow_Third")
            target_file="${BUILD_DIR}/${base_target_file}_Third.xcconfig"
            ;;
        *)
            target_file="${BUILD_DIR}/${base_target_file}.xcconfig"
            ;;
    esac

    # Check if the target file exists
    if [ -f "$target_file" ]; then
        # If it exists, remove the current file
        rm -f "$current_file"
    else
        # If it doesn't exist, move the current file to the target location
        mv "$current_file" "$target_file"
    fi
    echo "# The original file has been moved to $target_file. Please edit the display name there." > "$current_file"

    # Update Config.xcconfig
    local config_file="Config.xcconfig"
    local include_line="#include? \"$target_file\""

    # Replace the include line with the new target file
    sed -i '' "s|#include\? \"\.\./\.\./${base_target_file}\.xcconfig\"|$include_line|" "$config_file"

    cd ..
}

############################################################
# End of functions used by LoopFollow build script
############################################################
