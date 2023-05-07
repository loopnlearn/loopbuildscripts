function confirm_delete_old_downloads() {
    section_separator

    # List all top-level folders below $BUILD_DIR
    echo "These folders will be deleted in $BUILD_DIR:"
    find $BUILD_DIR -mindepth 1 -maxdepth 1 -type d -name "${APP_NAME}-*" -exec basename {} \; | while read -r folder; do
        echo "  - $folder"
    done
    echo ""

    # Ask the user for confirmation
    options=("Continue" "Cancel")
    actions=("do_continue" "cancel_entry")
    echo "Do you want to delete the listed folders?"
    menu_select "${options[@]}" "${actions[@]}"

    find $BUILD_DIR -mindepth 1 -maxdepth 1 -type d -name "${APP_NAME}-*" -exec rm -rf {} +
}

function delete_old_downloads() {
    if [ $(find $BUILD_DIR -mindepth 1 -maxdepth 1 -type d -name "${APP_NAME}-*" | wc -l) -gt 0 ]; then
        section_separator
        echo -e "Would you like to delete prior downloads of $APP_NAME before proceeding?\n"
        echo -e "Type 1 and hit enter to delete.\nType 2 and hit enter to continue without deleting"

        options=("Delete old downloads" "Do not delete old downloads" "Cancel")
        actions=("confirm_delete_old_downloads" "do_continue" "cancel_entry")
        menu_select "${options[@]}" "${actions[@]}"
    fi
}