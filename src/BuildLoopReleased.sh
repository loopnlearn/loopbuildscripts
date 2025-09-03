#!/bin/bash # script BuildLoopReleased.sh

script_name="BuildLoopReleased.sh"

# add special font
NC='\033[0m'
ERROR_FONT='\033[1;31m'

# redirect message
echo -e "${ERROR_FONT}The ${script_name} script has been superceded:${NC}"
echo "  Use the BuildLoop script instead:"
echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/loopandlearn/lnl-scripts/main/BuildLoop.sh)\""
