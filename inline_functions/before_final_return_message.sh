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
