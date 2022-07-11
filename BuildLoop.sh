# !/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'
WHICH=Loop
LOOP_BUILD=$(date +'%y%m%d-%H%M')
LOOP_DIR=~/Downloads/BuildLoop/
SCRIPT_DIR=~/Downloads/BuildLoop/Scripts

# set up default values - overwrite with flags.

# FRESH_CLONE
#   Default value is 1, which means:
#     Download fresh clone every time script is run
#   When testing:
#      use -t flag
#      run script one folder up from existing LoopWorkspace 
FRESH_CLONE=1

# BRANCH_TYPE
BRANCH_TYPE=master
#   Default value is master - determine branch for clone
#   To build Loop-dev or FreeAPS-dev:
#      use -d flag

############################################################
# Process the input options                                #
# -h : print help                                          #
# -t : use to test, sets FRESH_CLONE=0                     #
# -d : use dev branches instead of master branches         #
############################################################
# Get the options
while getopts 'dht' OPTION; do
   case "${OPTION}" in
      h) # display Help
         echo -e "Optional Flags:"
         echo -e "  -h : print this help message"
         echo -e "  -t : sets FRESH_CLONE=0"
         echo -e "  -d : use dev branches (not master)"
         exit;;
      t) # Do not download a fresh clone - useful for testing
         echo -e "  -t flag, sets FRESH_CLONE=0"
         FRESH_CLONE=0
         sleep 1
         ;;
      d) # set flag to download dev branches
         echo -e "  -d flag, sets BRANCH_TYPE=dev"
         BRANCH_TYPE=dev
         sleep 1
         ;;
      \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done
# shift "$(($OPTIND -1))"
# echo -e "There were ${OPTIND} options processed"

if [ "$BRANCH_TYPE" = "dev" ]
then
    # To test prior to release, uncomment these 3 rows
    BRANCH_LOOP=dev
    BRANCH_FREE=freeaps_dev
    LOOPCONFIGOVERRIDE_VALID=1
    echo -e " -- BRANCH_LOOP set to  ${BRANCH_LOOP}  --"
    echo -e " -- BRANCH_FREE set to  ${BRANCH_FREE}  --"
else
    BRANCH_LOOP=master
    BRANCH_FREE=freeaps
    LOOPCONFIGOVERRIDE_VALID=0
fi

mkdir $LOOP_DIR
mkdir $SCRIPT_DIR

# clear

echo -e "${RED}${BOLD}\n\n--------------------------------\n\n"
echo -e "IMPORTANT\n"
echo -e "Please understand that this project:\n"
echo -e "- Is Open Source software"
echo -e "- Is not \"approved\" for therapy\n"
echo -e "And that:"
echo -e "- You take full responsibility for"
echo -e "  reading and understanding the documenation"
echo -e "  (LoopsDocs is found at https://loopdocs.org)"
echo -e "  before building and running this system,"
echo -e "  and do so at your own risk.\n"
echo -e "${NC}If you find the font too small to read comfortably"
echo -e "  Hold down the CMD key and hit + (or -)"
echo -e "  to increase (decrease) size\n"
echo -e "${RED}${BOLD}By typing 1 and ENTER, you indicate you agree"
echo -e "  Any other entry cancels"
echo -e "\n--------------------------------\n"
options=("Agree")
select opt in "${options[@]}"
do
    case $opt in
        "Agree")
            break
            ;;
        *)
            echo -e "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n";
            echo -e "You can press the up arrow ⬆️  on the keyboard"
            echo -e "    and return to repeat script from beginning.\n\n";
            exit 0
            break
            ;;
    esac
done

echo -e "${NC}\n\n\n\n"

echo -e "\n--------------------------------\n"
echo -e "${BOLD}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo -e "This script will assist you in one of these actions:"
echo -e "  1 Download and build Loop"
echo -e "      You will be asked to choose from the"
echo -e "      released versions of Loop or FreeAPS"
echo -e "  2 Download and build LoopFollow"
echo -e "  3 Prepare your computer using a Utility Script"
echo -e "     when updating your computer or an app"
echo -e "\n--------------------------------\n"
echo -e "Type a number from the list below and return to proceed."
echo -e "${RED}${BOLD}  Any other entry cancels\n${NC}"
options=("Build Loop" "Build LoopFollow" "Utility Scripts")
select opt in "${options[@]}"
do
    case $opt in
        "Build Loop")
            WHICH=Loop
            break
            ;;
        "Build LoopFollow")
            WHICH=LoopFollow
            break
            ;;
        "Utility Scripts")
            WHICH=UtilityScripts
            break
            ;;
        *)
            echo -e "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
            echo -e "You can press the up arrow ⬆️  on the keyboard"
            echo -e "    and return to repeat script from beginning.\n\n";
            exit 0
            break
            ;;
    esac
done

echo -e "\n\n\n\n"

if [ "$WHICH" = "Loop" ]
then
    echo -e "\n--------------------------------\n"
    echo -e "Before you begin, please ensure that you have Xcode installed,"
    echo -e "  Xcode command line tools installed, and"
    echo -e "  your phone is plugged into your computer\n"
    echo -e "Please select which version of Loop you would like to download and build.\n"
    echo -e "Type a number from the list below and return"
    echo -e "${RED}${BOLD}  Any other entry cancels\n${NC}"
    options=("Loop Master" "FreeAPS")
    select opt in "${options[@]}"
    do
        case $opt in
            "Loop Master")
                FOLDERNAME=Loop-Master
                REPO=https://github.com/LoopKit/LoopWorkspace
                BRANCH=$BRANCH_LOOP
                break
                ;;
            "FreeAPS")
                FOLDERNAME=FreeAPS
                REPO=https://github.com/loopnlearn/LoopWorkspace
                BRANCH=$BRANCH_FREE
                break
                ;;
            *)
                echo -e "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo -e "You can press the up arrow ⬆️  on the keyboard"
                echo -e "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done

    echo -e "\n\n\n\n"
    LOOP_DIR=~/Downloads/BuildLoop/$FOLDERNAME-$LOOP_BUILD
    if [ ${FRESH_CLONE} == 1 ]
    then
        mkdir $LOOP_DIR
        cd $LOOP_DIR
    fi
    echo -e "\n\n\n\n"
    echo -e "\n--------------------------------\n"
    if [ ${FRESH_CLONE} == 1 ]
    then
        echo -e " -- Downloading ${FOLDERNAME} ${BRANCH} to your Downloads folder --"
        echo -e "      ${LOOP_DIR}\n"
        echo -e "Issuing this command:"
        echo -e "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
        git clone --branch=$BRANCH --recurse-submodules $REPO
    fi
    echo -e "\n--------------------------------\n"
    echo -e "🛑 Please check for errors in the window above before proceeding."
    echo -e "   If there are no errors listed, code has successfully downloaded.\n"
    echo -e "Type 1 and return to continue if and ONLY if"
    echo -e "  there are no errors (scroll up in terminal window to look for the word error)"
    echo -e "\nAfter you Type 1 and return:"
    echo -e "* The Loop and Learn webpage with abbreviated build steps will be displayed in your browser"
    echo -e "* The LoopDocs webpage with detailed build steps will be displayed in your browser"
    echo -e "* Xcode will open with your current download (wait for it)\n"
    echo -e "${RED}${BOLD}  Any entry (other than 1) cancels\n${NC}"

    options=("Continue")
    select opt in "${options[@]}"
    do
        case $opt in
            "Continue")
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]
                then
                    echo -e "\n--------------------------------\n"
                    # echo -e "Checking status of persistent override file"
                    # determine if the persistent file exists
                    # if so, remind user
                    if [ -e ../LoopConfigOverride.xcconfig ]
                    then
                        echo -e "You have a persistent override file:"
                        echo -e "   ~/Downloads/BuildLoop/LoopConfigOverride.xcconfig"
                        echo -e "The last 3 lines of that file are shown next:\n"
                        tail -3 ../LoopConfigOverride.xcconfig
                        echo -e "\n If the last line has your Apple Developer ID"
                        echo -e "   with no slashes at the beginning of the line"
                        echo -e "   your targets will be automatically signed"
                        read -p "Hit return when ready to continue  " dummy
                    else
                        # make sure the LoopConfigOverride.xcconfig exists in clone
                        if [ -e LoopWorkspace/LoopConfigOverride.xcconfig ]
                        then
                            echo -e "Choose to enter Apple ID or Sign Manually (later in Xcode)"
                            options=("Enter Apple ID" "Sign Manually")
                            select opt in "${options[@]}"
                            do
                                case $opt in
                                    "Enter Apple ID")
                                        echo -e "The Apple Developer page will open"
                                        echo -e "Log in to the page and note your 10-character Team ID"
                                        echo -e "Then, return to terminal window"
                                        open "https://developer.apple.com/account/#!/membership"
                                        read -p "Enter the ID and hit return: " devID
                                        if [ ${#devID} -ne 10 ]
                                        then
                                            echo -e "Something was wrong with entry"
                                            echo -e "You can manually edit the file later or"
                                            echo -e "  just sign each target in Xcode"
                                        else 
                                            echo -e "Copying LoopConfigOverride.xcconfig to ~/Downloads/BuildLoop"
                                            echo -e "Adding a new line with your Apple Developer ID"
                                            cp -p LoopWorkspace/LoopConfigOverride.xcconfig ..
                                            echo -e "LOOP_DEVELOPMENT_TEAM = ${devID}" >> ../LoopConfigOverride.xcconfig
                                            tail -3 ../LoopConfigOverride.xcconfig
                                        fi
                                        break
                                        ;;
                                    "Sign Manually")
                                        break
                                        ;;
                                esac
                            done
                        else
                            echo -e "This project does not have a persistent override file"
                            echo -e "You must sign the targets individually"
                            LOOPCONFIGOVERRIDE_VALID=0
                        fi
                    fi
                    echo -e "\n--------------------------------\n"
                fi
                # the helper page displayed depends on validity of persistent override
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]
                then
                    # change this page to the one (not yet written) for persistent override
                    echo -e "Opening your browser with abbreviated build instructions"
                    sleep 2
                    open https://www.loopandlearn.org/workspace-build-loop
                else
                    echo -e "Opening your browser with abbreviated build instructions"
                    sleep 2
                    open https://www.loopandlearn.org/workspace-build-loop
                fi
                echo -e "Opening your browser with step-by-step build instructions"
                sleep 2
                open "https://loopkit.github.io/loopdocs/build/step14/#prepare-to-build"
                cd LoopWorkspace
                sleep 2
                echo -e "Opening your project in Xcode . . ."
                sleep 2
                xed .
                echo -e "\nShell Script Completed successfully\n"
                echo -e "You may close the terminal window now if you want"
                echo -e "  or"
                echo -e "You can press the up arrow ⬆️  on the keyboard"
                echo -e "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
            *)
                echo -e "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo -e "You can press the up arrow ⬆️  on the keyboard"
                echo -e "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done

elif [ "$WHICH" = "LoopFollow" ]
then
    # Note that BuildLoopFollow.sh has a warning about Xcode and phone, not needed here
    cd $LOOP_DIR/Scripts
    echo -e "\n\n--------------------------------\n\n"
    echo -e "Downloading Loop Follow Script\n"
    echo -e "\n--------------------------------\n\n"
    rm ./BuildLoopFollow.sh
    curl -fsSLo ./BuildLoopFollow.sh https://raw.githubusercontent.com/jonfawcett/LoopFollow/Main/BuildLoopFollow.sh
    echo -e "\n\n\n\n"
    source ./BuildLoopFollow.sh
else
    cd $LOOP_DIR/Scripts
    echo -e "\n\n\n\n"
    echo -e "\n--------------------------------\n"
    echo -e "${BOLD}These utility scripts automate several cleanup actions${NC}"
    echo -e "\n--------------------------------\n"
    echo -e "1 ➡️  Clean Derived Data:\n"
    echo -e "    This script is used to clean up data from old builds."
    echo -e "    In other words, it frees up space on your disk."
    echo -e "    Xcode should be closed when running this script.\n"
    echo -e "2 ➡️  Xcode Cleanup (The Big One):\n"
    echo -e "    This script clears even more disk space filled up by using Xcode."
    echo -e "    It is typically used after uninstalling Xcode"
    echo -e "      and before installing a new version of Xcode."
    echo -e "    It can free up a substantial amount of disk space."
    echo -e "\n    You might be directed to use this script to resolve a problem."
    echo -e "\n${RED}${BOLD}    Beware that you might be required to fully uninstall"
    echo -e "      and reinstall Xcode if you run this script with Xcode installed.\n${NC}"
    echo -e "    Always a good idea to reboot your computer after Xcode Cleanup.\n"
    echo -e "3 ➡️  Clean Profiles & Derived Data:\n"
    echo -e "    For those with a paid Apple Developer ID,"
    echo -e "      this action configures you to have a full year"
    echo -e "      before you are forced to rebuild your app."
    echo -e "\n--------------------------------\n"
    echo -e "Type a number from the list below and return to proceed."
    echo -e "${RED}${BOLD}  Any other entry - ENTER cancels\n"
    echo -e "You may need to scroll up in the terminal to see details about options${NC}\n"
    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles & Derived Data")
    select opt in "${options[@]}"
    do
        case $opt in
            "Clean Derived Data")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Derived Data Script"
                echo -e "\n--------------------------------\n"
                rm ./CleanCartDerived.sh
                curl -fsSLo ./CleanCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh
                echo -e "\n\n\n\n"
                source ./CleanCartDerived.sh
                break
                ;;
            "Xcode Cleanup (The Big One)")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Xcode Cleanup Script"
                echo -e "\n--------------------------------\n"
                rm ./XcodeClean.sh
                curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh
                echo -e "\n\n\n\n"
                source ./XcodeClean.sh
                break
                ;;
            "Clean Profiles & Derived Data")
                echo -e "\n--------------------------------\n"
                echo -e "Downloading Profiles and Derived Data Script"
                echo -e "\n--------------------------------\n"
                rm ./CleanProfCartDerived.sh
                curl -fsSLo ./CleanProfCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanProfCartDerived.sh
                echo -e "\n\n\n\n"
                source ./CleanProfCartDerived.sh
                break
                ;;
            *)
                echo -e "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo -e "You can press the up arrow ⬆️  on the keyboard"
                echo -e "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done
fi

