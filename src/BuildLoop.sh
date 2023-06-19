#!/bin/bash # script BuildLoop.sh

# remove and add special font
NC='\033[0m'
ERROR_FONT='\033[1;31m'

echo -e "${ERROR_FONT}The Build Select Script can be reached with this command:${NC}"
echo ""
echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildSelectScript.sh)\""
