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


mkdir $LOOP_DIR
mkdir $SCRIPT_DIR

echo -e "\n\n     ----------\n\n"

echo -e "${RED}\n\n--------------------------------\n\nImportant\n\nPlease understand that this project:\n-Is highly experimental\n-Is not approved for therapy\n-You take full responsibility for building and running this system and do so at your own risk.\n\nYou may only proceed if you agree..\n\n--------------------------------\n\n${NC}"
echo -e "Type the number from below and hit enter to proceed."
options=("Agree" "Disagree")
select opt in "${options[@]}"
do
    case $opt in
        "Agree")
            break
            ;;
        "Disagree")
            echo -e "\n${RED}Did not agree to terms of use.${NC}\n\n";
            exit 0
            break
            ;;
        *)
    esac
done

echo -e "\n\n     ----------\n\n"

echo -e "\n\n--------------------------------\n\nWelcome to Loop and Learn Scripts.\n\n This script will assist you in preparing your computer as well as downloading and building Loop and Loop Follow. Before you begin, please ensure that you have Xcode installed and your phone is plugged into your computer\n\n--------------------------------\n\n"
echo -e "Type the number from below and hit enter to proceed."
options=("Build Loop" "Build Loop Follow" "Utility Scripts" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Build Loop")
            WHICH=Loop
            break
            ;;
        "Build Loop Follow")
            WHICH=LoopFollow
            break
            ;;
        "Utility Scripts")
            WHICH=UtilityScripts
            break
            ;;
        "Cancel")
            echo -e "\n\n     ----------\n\n"
            echo -e "\n${RED}User cancelled!${NC}\n\n⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
            exit 0
            break
            ;;
        *)
    esac
done

echo -e "\n\n     ----------\n\n"

if [ "$WHICH" = "Loop" ]
then

    echo -e "Please select which version of Loop you would like to download and build.\n\nType the number for the branch and hit enter to select the branch.\nType 4 and hit enter to cancel.\n\n"
    options=("Master Branch" "FreeAPS" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Master Branch")
                FOLDERNAME=Loop-Master
                REPO=https://github.com/LoopKit/LoopWorkspace
                BRANCH=master
                # change LOOPCONFIGOVERRIDE_VALID to 1 when signing is enabled for this version
                LOOPCONFIGOVERRIDE_VALID=0
                break
                ;;
            "FreeAPS")
                FOLDERNAME=FreeAPS
                REPO=https://github.com/loopnlearn/LoopWorkspace
                BRANCH=freeaps
                # change LOOPCONFIGOVERRIDE_VALID to 1 when signing is enabled for this version
                LOOPCONFIGOVERRIDE_VALID=0
                break
                ;;
            "Cancel")
                echo -e "\n\n     ----------\n\n"
                echo -e "\n${RED}User cancelled!${NC}\n\n⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
                exit 0
                break
                ;;
            *)
        esac
    done

    echo -e "\n\n     ----------\n\n"
    LOOP_DIR=~/Downloads/BuildLoop/$FOLDERNAME-$LOOP_BUILD
    mkdir $LOOP_DIR
    cd $LOOP_DIR
    pwd
    echo -e "\n\n     ----------\n\n"
    echo -e "\n\n Downloading Loop to your Downloads folder.\n--------------------------------\n"
    git clone --branch=$BRANCH --recurse-submodules $REPO
    echo -e "--------------------------------\n\n🛑 Please check for errors listed above before proceeding. If there are no errors listed, code has successfully downloaded.\n"
    echo -e "Type 1 to continue (ONLY when there are no errors) and then:"
    echo -e "* A helpful graphic will be displayed in your browser"
    echo -e "* Xcode will open with your current download."
    echo -e "You may close the terminal after Xcode opens\n\n"

    options=("Continue" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Continue")
                if [ ${LOOPCONFIGOVERRIDE_VALID} == 1 ]
                then
                    echo -e "Checking status of persistent sign-in file"
                    # determine if the persistent file exists
                    # if so, remind user
                    if [ -e ../LoopConfigOverride.xcconfig ]
                    then
                        echo -e "You have a persistent LoopConfigOverride.xcconfig located in ~/Downloads/BuildLoop"
                        echo -e "Check it to confirm your Apple Developer ID is correct"
                        echo -e "If so, your project will be automatically signed"
                    else
                        # make sure the LoopConfigOverride.xcconfig exists in clone
                        if [ -e LoopWorkspace/LoopConfigOverride.xcconfig ]
                        then
                            echo -e "Copying the LoopConfigOverride file to ~/Downloads/BuildLoop"
                            echo -e "If you edit this file with your Apple Developer ID"
                            echo -e "then your project will be automatically signed"
                            cp -p LoopWorkspace/LoopConfigOverride.xcconfig ..
                        else
                            echo -e "This project does not have a persistent sign-in file"
                            echo -e "You must sign the targets the individually"
                        fi
                    fi
                fi
                open https://www.loopandlearn.org/workspace-build-loop/?fromscript
                cd LoopWorkspace
                xed .
                echo -e "Shell Script Completed successfully"
                exit 0
                break
                ;;
            "Cancel")
            echo -e "\n\n     ----------\n\n"
                echo -e "\n${RED}User cancelled!${NC}\n\n⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
                exit 0
                break
                ;;
            *)
        esac
    done

elif [ "$WHICH" = "LoopFollow" ]
then
    cd $LOOP_DIR/Scripts
    echo -e "\n\n--------------------------------\n\nDownloading Loop Follow Script\n\n--------------------------------\n\n"
    rm ./BuildLoopFollow.sh
    curl -fsSLo ./BuildLoopFollow.sh https://git.io/JTKEt
    echo -e "\n\n     ----------\n\n"
    source ./BuildLoopFollow.sh
else
    cd $LOOP_DIR/Scripts
    echo -e "\n\n     ----------\n\n"
    echo -e "\n\n--------------------------------\n\nThese scripts will automate several cleanup options for you.\n\n--------------------------------\n\n➡️  Clean Carthage and Derived Data:\nThis script is used to clean up data from old builds from Xcode. Xcode should be closed when running this script.\n\n➡️  Xcode Cleanup (The Big One):\nThis script is used to clean up “stuff” from Xcode. It is typically used after uninstalling Xcode and before installing a new version of Xcode. It can free up a substantial amount of space. Sometimes you might be directed to use this script to resolve a problem, ‼️  beware that you might be required to fully uninstall and reinstall Xcode after running this script.‼️  Usually, Xcode will recover the simulator and other files it needs without needing to be reinstalled.\n\n"
    echo -e "Type the number from below and hit enter to proceed."
    options=("Clean Derived Data" "Xcode Cleanup (The Big One)" "Clean Profiles and Derived Data" "Cancel")
    select opt in "${options[@]}"
    do
        case $opt in
            "Clean Derived Data")
                echo -e "\n\n--------------------------------\n\nDownloading Derived Data Script\n\n--------------------------------\n\n"
                rm ./CleanCartDerived.sh
                curl -fsSLo ./CleanCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanCartDerived.sh
                echo -e "\n\n     ----------\n\n"
                source ./CleanCartDerived.sh
                break
                ;;
            "Xcode Cleanup (The Big One)")
                echo -e "\n\n--------------------------------\n\nDownloading Xcode Cleanup Script\n\n--------------------------------\n\n"
                rm ./XcodeClean.sh
                curl -fsSLo ./XcodeClean.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/XcodeClean.sh
                echo -e "\n\n     ----------\n\n"
                source ./XcodeClean.sh
                break
                ;;
            "Clean Profiles and Derived Data")
                echo -e "\n\n--------------------------------\n\nDownloading Profiles and Derived Data Script\n\n--------------------------------\n\n"
                rm ./CleanProfCartDerived.sh
                curl -fsSLo ./CleanProfCartDerived.sh https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/main/CleanProfCartDerived.sh
                echo -e "\n\n     ----------\n\n"
                source ./CleanProfCartDerived.sh
                break
                ;;
            "Cancel")
                echo -e "\n\n     ----------\n\n"
                echo -e "\n${RED}User cancelled!${NC}\n\n⬆️  You can press the up arrow on the keyboard followed by the Enter key to start the script from the beginning.\n\n";
                exit 0
                break
                ;;
            *)
        esac
    done
fi

