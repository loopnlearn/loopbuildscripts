function before_final_return_message() {
    # Default (no argument) prints watch message
    # An other argument, skips watch message
    local default_watch_flag="include_watch_message"
    local watch_flag=${1:-$default_watch_flag}
    echo ""
    echo -e "${INFO_FONT}BEFORE you hit return:${NC}"
    echo " *** Unlock your phone and plug it into your computer"
    echo "     Trust computer if asked"
    echo ""
    echo -e "${INFO_FONT}AFTER you hit return, Xcode will open automatically${NC}"
    echo "  For new phone or new watch (never used with Xcode),"
    echo "    review Developer Mode Information:"
    echo -e "  https://loopkit.github.io/loopdocs/build/step14/#prepare-your-phone-and-watch"
    echo ""
    echo "  For phones that have Developer Mode enabled continue with these steps"
    echo "  Upper middle of Xcode:"
    echo "    Confirm your phone or simulator choice is selected"
    echo "  Upper right of Xcode:"
    echo "    Wait for packages to finish being copied or downloaded"
    echo "    When you see indexing, you can build to phone or simulator"
    echo "  Click on Play button or Command-B or Xcode Menu: Product, Build"
}
