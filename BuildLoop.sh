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
#   This determines the branch for git clone command
#   Default value is master
#   To build Loop with dev or FreeAPS with freeaps_dev:
#      use -d flag
BRANCH_TYPE=master

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
         echo "Optional Flags:"
         echo "  -h : print this help message"
         echo "  -t : sets FRESH_CLONE=0"
         echo "  -d : use dev branches (not master)"
         exit;;
      t) # Do not download a fresh clone - useful for testing
         echo "  -t flag, sets FRESH_CLONE=0"
         FRESH_CLONE=0
         sleep 1
         ;;
      d) # set flag to download dev branches
         echo "  -d flag, sets BRANCH_TYPE=dev"
         BRANCH_TYPE=dev
         LOOP_BUILD="dev"-${LOOP_BUILD}
         sleep 1
         ;;
      \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

if [ ! -d ${LOOP_DIR} ]
then
    mkdir $LOOP_DIR
fi
if [ ! -d ${SCRIPT_DIR} ]
then
    mkdir $SCRIPT_DIR
fi

# make a copy of this script in script directory
if [ -e ${SCRIPT_DIR}/BuildLoop.sh ]
then
    rm ${SCRIPT_DIR}/BuildLoop.sh
fi
curl -fsSLo ${SCRIPT_DIR}/BuildLoop.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/BuildLoop.sh

# clear

echo "${RED}${BOLD}\n\n--------------------------------\n\n"
echo "IMPORTANT\n"
echo "Please understand that this project:\n"
echo "- Is Open Source software"
echo "- Is not \"approved\" for therapy\n"
echo "And that:"
echo "- You take full responsibility for"
echo "  reading and understanding the documenation"
echo "  (LoopsDocs is found at https://loopdocs.org)"
echo "  before building and running this system,"
echo "  and do so at your own risk.\n"
echo "${NC}If you find the font too small to read comfortably"
echo "  Hold down the CMD key and hit + (or -)"
echo "  to increase (decrease) size\n"
echo "${RED}${BOLD}By typing 1 and ENTER, you indicate you agree"
echo "  Any other entry cancels"
echo "\n--------------------------------\n"
options=("Agree")
select opt in "${options[@]}"
do
    case $opt in
        "Agree")
            break
            ;;
        *)
            echo "\n${RED}${BOLD}User did not agree to terms of use.${NC}\n\n";
            echo "You can press the up arrow ⬆️  on the keyboard"
            echo "    and return to repeat script from beginning.\n\n";
            exit 0
            break
            ;;
    esac
done

echo "${NC}\n\n\n\n"

echo "\n--------------------------------\n"
echo "${BOLD}Welcome to the Loop and Learn\n  Build-Select Script\n${NC}"
echo "This script will assist you in one of these actions:"
echo "  1 Download and build Loop"
echo "      You will be asked to choose from Loop or FreeAPS"
echo "  2 Download and build LoopFollow"
echo "  3 Prepare your computer using a Utility Script"
echo "     when updating your computer or an app"
echo "\n--------------------------------\n"
echo "Type a number from the list below and return to proceed."
echo "${RED}${BOLD}  Any other entry cancels\n${NC}"
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
            echo "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
            echo "You can press the up arrow ⬆️  on the keyboard"
            echo "    and return to repeat script from beginning.\n\n";
            exit 0
            break
            ;;
    esac
done

echo "\n\n\n\n"

if [ "$WHICH" = "Loop" ]
then
    echo "\n--------------------------------\n"
    echo "Before you begin, please ensure that you have Xcode installed,"
    echo "  Xcode command line tools installed, and"
    echo "  your phone is plugged into your computer\n"
    echo "Please select which version of Loop you would like to download and build.\n"
    echo "Type a number from the list below and return"
    if [ "$BRANCH_TYPE" = "dev" ]
    then
        BRANCH_LOOP=dev
        BRANCH_FREE=freeaps_dev
        LOOPCONFIGOVERRIDE_VALID=1
        echo "\n ${RED}${BOLD}You are running the script with a -d flag${NC}\n"
        echo " -- If you choose Loop,    branch is ${RED}${BOLD}${BRANCH_LOOP}${NC}"
        echo " -- If you choose FreeAPS, branch is ${RED}${BOLD}${BRANCH_FREE}${NC}\n"
    else
        BRANCH_LOOP=master
        BRANCH_FREE=freeaps
        LOOPCONFIGOVERRIDE_VALID=0
    fi
    echo "${RED}${BOLD}  Any other entry cancels\n${NC}"
    options=("Loop" "FreeAPS")
    select opt in "${options[@]}"
    do
        case $opt in
            "Loop")
                FOLDERNAME=Loop
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
                echo "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo "You can press the up arrow ⬆️  on the keyboard"
                echo "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done

    echo "\n\n\n\n"
    LOOP_DIR=~/Downloads/BuildLoop/$FOLDERNAME-$LOOP_BUILD
    if [ ${FRESH_CLONE} == 1 ]
    then
        mkdir $LOOP_DIR
        cd $LOOP_DIR
    fi
    echo "\n\n\n\n"
    echo "\n--------------------------------\n"
    if [ ${FRESH_CLONE} == 1 ]
    then
        echo " -- Downloading ${FOLDERNAME} ${BRANCH} to your Downloads folder --"
        echo "      ${LOOP_DIR}\n"
        echo "Issuing this command:"
        echo "    git clone --branch=${BRANCH} --recurse-submodules ${REPO}"
        git clone --branch=$BRANCH --recurse-submodules $REPO
    fi
    echo "\n--------------------------------\n"
    echo "🛑 Please check for errors in the window above before proceeding."
    echo "   If there are no errors listed, code has successfully downloaded.\n"
    echo "Type 1 and return to continue if and ONLY if"
    echo "  there are no errors (scroll up in terminal window to look for the word error)\n"
    echo "${RED}${BOLD}  Any entry (other than 1) cancels\n${NC}"


    options=("Continue")
    select opt in "${options[@]}"
    do
        case $opt in
            "Continue")
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]
                then
                    echo "\n--------------------------------\n"
                    # echo "Checking status of persistent override file"
                    # determine if the persistent file exists
                    # if so, remind user
                    if [ -e ../LoopConfigOverride.xcconfig ]
                    then
                        echo "You have a persistent override file:"
                        echo "   ~/Downloads/BuildLoop/LoopConfigOverride.xcconfig"
                        echo "The last 3 lines of that file are shown next:\n"
                        tail -3 ../LoopConfigOverride.xcconfig
                        echo "\nIf the last line has your Apple Developer ID"
                        echo "   with no slashes at the beginning of the line"
                        echo "   your targets will be automatically signed"
                        echo "Any line that starts with // is ignored"
                        echo "If ID is wrong - you can manually edit the file now\n"
                        read -p "Return when ready to continue  " dummy
                    else
                        # make sure the LoopConfigOverride.xcconfig exists in clone
                        if [ -e LoopWorkspace/LoopConfigOverride.xcconfig ]
                        then
                            echo "Choose to enter Apple ID or wait and Sign Manually (later in Xcode)"
                            echo "\nIf you choose Apple ID, script will help you find it\n"
                            options=("Enter Apple ID" "Sign Manually")
                            select opt in "${options[@]}"
                            do
                                case $opt in
                                    "Enter Apple ID")
                                        echo "The Apple Developer page will open"
                                        echo "* Log in to the page and note your 10-character Team ID"
                                        echo " * If the Memebship page does not show, you may need to select it"
                                        echo " * If you already have your account open in your browser, you may need to go to the already opened page"
                                        echo " * For reference, this is the page that will open:"
                                        echo "   https://developer.apple.com/account/#!/membership\n"
                                        echo "Then, return to terminal window"
                                        open "https://developer.apple.com/account/#!/membership"
                                        read -p "Enter the ID and return: " devID
                                        if [ ${#devID} -ne 10 ]
                                        then
                                            echo "Something was wrong with entry"
                                            echo "You can manually edit the file later or"
                                            echo "  just sign each target in Xcode"
                                        else 
                                            echo "Copying LoopConfigOverride.xcconfig to ~/Downloads/BuildLoop"
                                            echo "Adding a new line with your Apple Developer ID"
                                            cp -p LoopWorkspace/LoopConfigOverride.xcconfig ..
                                            echo "LOOP_DEVELOPMENT_TEAM = ${devID}" >> ../LoopConfigOverride.xcconfig
                                            echo "You now have a persistent override file:"
                                            echo "   ~/Downloads/BuildLoop/LoopConfigOverride.xcconfig"
                                            echo "The last 3 lines of that file are shown next:\n"
                                            tail -3 ../LoopConfigOverride.xcconfig
                                            echo "\nIf the last line has your Apple Developer ID"
                                            echo "   with no slashes at the beginning of the line"
                                            echo "   your targets will be automatically signed"
                                            echo "Any line that starts with // is ignored"
                                            echo "If ID is wrong - you can manually edit the file now\n"
                                            read -p "Return when ready to continue  " dummy
                                            echo "\nThe next time you build, this permanent file with automatically sign your targets"
                                        fi
                                        break
                                        ;;
                                    "Sign Manually")
                                        break
                                        ;;
                                      *) # Invalid option
                                         echo "Error: Invalid option"
                                         exit;;
                                esac
                            done
                        else
                            echo "This project does not have a persistent override file"
                            echo "You must sign the targets individually"
                            LOOPCONFIGOVERRIDE_VALID=0
                        fi
                    fi
                    echo "\n--------------------------------\n"
                fi
                # the helper page displayed depends on validity of persistent override
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]
                then
                    # change this page to the one (not yet written) for persistent override
                    echo "* The Loop and Learn webpage with abbreviated build steps will be displayed in your browser"
                    sleep 2
                    open https://www.loopandlearn.org/workspace-build-loop
                else
                    echo "* The Loop and Learn webpage with abbreviated build steps will be displayed in your browser"
                    sleep 2
                    open https://www.loopandlearn.org/workspace-build-loop
                fi
                echo "* The LoopDocs webpage with detailed build steps will be displayed in your browser"
                sleep 2
                open "https://loopkit.github.io/loopdocs/build/step14/#prepare-to-build"
                cd LoopWorkspace
                sleep 2
                echo "* Xcode will open with your current download (wait for it)\n"
                sleep 2
                xed .
                echo "\nShell Script Completed\n"
                echo " * You may close the terminal window now if you want"
                echo "  or"
                echo " * You can press the up arrow ⬆️  on the keyboard"
                echo "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
            *)
                echo "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo "* You can press the up arrow ⬆️  on the keyboard"
                echo "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done

elif [ "$WHICH" = "LoopFollow" ]
then
    # Note that BuildLoopFollow.sh has a warning about Xcode and phone, not needed here
    cd $LOOP_DIR/Scripts
    echo "\n\n--------------------------------\n\n"
    echo "Downloading Loop Follow Script\n"
    echo "\n--------------------------------\n\n"
    rm ./BuildLoopFollow.sh
    curl -fsSLo ./BuildLoopFollow.sh https://raw.githubusercontent.com/jonfawcett/LoopFollow/Main/BuildLoopFollow.sh
    echo "\n\n\n\n"
    source ./BuildLoopFollow.sh
else
    cd $LOOP_DIR/Scripts
    echo "\n\n\n\n"
    echo "\n--------------------------------\n"
    echo "${BOLD}These utility scripts automate several cleanup actions${NC}"
    echo "\n--------------------------------\n"
    echo "1 ➡️  Clean Derived Data:\n"
    echo "    This script is used to clean up data from old builds."
    echo "    In other words, it frees up space on your disk."
    echo "    Xcode should be closed when running this script.\n"
    echo "2 ➡️  Xcode Cleanup (The Big One):\n"
    echo "    This script clears even more disk space filled up by using Xcode."
    echo "    It is typically used after uninstalling Xcode"
    echo "      and before installing a new version of Xcode."
    echo "    It can free up a substantial amount of disk space."
    echo "\n    You might be directed to use this script to resolve a problem."
    echo "\n${RED}${BOLD}    Beware that you might be required to fully uninstall"
    echo "      and reinstall Xcode if you run this script with Xcode installed.\n${NC}"
    echo "    Always a good idea to reboot your computer after Xcode Cleanup.\n"
    echo "3 ➡️  Clean Profiles & Derived Data:\n"
    echo "    For those with a paid Apple Developer ID,"
    echo "      this action configures you to have a full year"
    echo "      before you are forced to rebuild your app."
    echo "\n--------------------------------\n"
    echo "Type a number from the list below and return to proceed."
    echo "${RED}${BOLD}  Any other entry - ENTER cancels\n"
    echo "You may need to scroll up in the terminal to see details about options${NC}\n"
    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles & Derived Data")
    select opt in "${options[@]}"
    do
        case $opt in
            "Clean Derived Data")
                echo "\n--------------------------------\n"
                echo "Downloading Derived Data Script"
                echo "\n--------------------------------\n"
                rm ./CleanCartDerived.sh
                curl -fsSLo ./CleanCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh
                echo "\n\n\n\n"
                source ./CleanCartDerived.sh
                break
                ;;
            "Xcode Cleanup (The Big One)")
                echo "\n--------------------------------\n"
                echo "Downloading Xcode Cleanup Script"
                echo "\n--------------------------------\n"
                rm ./XcodeClean.sh
                curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh
                echo "\n\n\n\n"
                source ./XcodeClean.sh
                break
                ;;
            "Clean Profiles & Derived Data")
                echo "\n--------------------------------\n"
                echo "Downloading Profiles and Derived Data Script"
                echo "\n--------------------------------\n"
                rm ./CleanProfCartDerived.sh
                curl -fsSLo ./CleanProfCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanProfCartDerived.sh
                echo "\n\n\n\n"
                source ./CleanProfCartDerived.sh
                break
                ;;
            *)
                echo "\n${RED}${BOLD}User cancelled - selected an invalid option${NC}\n"
                echo "You can press the up arrow ⬆️  on the keyboard"
                echo "    and return to repeat script from beginning.\n\n";
                exit 0
                break
                ;;
        esac
    done
fi

