# !/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'
CARTHAGEEXISTS=false
SKIPCARTHAGE=false

clear
echo -e "\n\n--------------------------------\n\nWelcome to Loop. This script will assist you in downloading and building Loop. Before you begin, please ensure that you have Xcode installed and your phone is plugged into your computer\n\n--------------------------------\n\n"
echo -e "Type 1 and hit enter to begin.\nType 2 and hit enter to cancel."
options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Continue")
            break
            ;;
        "Cancel")
            echo -e "\n${RED}User cancelled!${NC}";
            exit 0
            break
            ;;
        *)
    esac
done

clear

if [ ! -f /usr/local/bin/carthage ]
then
    CARTHAGEEXISTS=false
else
    CARTHAGEEXISTS=true
    echo -e "✅ Carthage installation found.\n\n"
fi

if [ "$CARTHAGEEXISTS" == "false" ]
then
    echo -e "⚠️ Carthage was not found on your system and must be installed to build Loop.\n\nWhen you continue, Safari will open and attempt to download the Carthage.pkg installation file to your Downloads folder. Please enter 1) to start downloading and then confirm the file is downloaded and return here.\n\n"
    options=("Download Carthage" "Skip Carthage Download")
    select opt in "${options[@]}"
    do
        case $opt in
            "Download Carthage")
                open https://github.com/Carthage/Carthage/releases/download/0.36.0/Carthage.pkg
                break
                ;;
            "Skip Carthage Download")
                SKIPCARTHAGE=true
                break
                ;;
            *)
        esac
    done
fi

clear

if [ "$SKIPCARTHAGE" = "false" ]
then
    if [ "$CARTHAGEEXISTS" = "false" ]
    then
        echo -e "⚠️ Did you confirm Carthage.pkg was saved to your Downloads folder?  \n\nWe will now try to install Carthage for you. When prompted, type your computer password. Do not be concerned that the password will not be displayed as your type. Once you type it, hit the enter command.\n\n"
        options=("Install Carthage" "Skip Carthage Install")
        select opt in "${options[@]}"
        do
            case $opt in
                "Install Carthage")
                    sudo installer -allowUntrusted -pkg ~/Downloads/Carthage.pkg -target /
                    break
                    ;;
                "Skip Carthage Install")
                    SKIPCARTHAGE=true
                    break
                    ;;
                *)
            esac
        done
    fi
fi

clear

if [ "$SKIPCARTHAGE" == "false" ]
then
    if [ -f /usr/local/bin/carthage ]
    then
        echo -e "Carthage installation may have failed. Please hold install manually. Hold the Option key while right clicking on /Downloads/Carthage.pkg and select open from the menu. If presented with the option to trust or allow the installer to run, you must allow it."
    else
        CARTHAGEEXISTS=true
        echo -e "Carthage installation successful. Proceeding to download Loop.\n\n"
    fi

fi

clear

echo -e "Please select which version of Loop you would like to download and build.\n\nType the number for the branch and hit enter to select the branch.\nType 4 and hit enter to cancel.\n\n"
options=("Master Branch" "Automatic Bolus Branch" "FreeAPS" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Master Branch")
            FOLDERNAME=Loop-Master
            REPO=https://github.com/LoopKit/LoopWorkspace
            BRANCH=master
            break
            ;;
        "Automatic Bolus Branch")
            FOLDERNAME=Loop-Automatic-Bolus
            REPO=https://github.com/LoopKit/LoopWorkspace
            BRANCH=automatic-bolus
            break
            ;;
        "FreeAPS")
            FOLDERNAME=FreeAPS
            REPO=https://github.com/ivalkou/LoopWorkspace
            BRANCH=freeaps
            break
            ;;
        "Cancel")
            echo -e "\n${RED}User cancelled!${NC}";
            exit 0
            break
            ;;
        *)
    esac
done

clear
echo -e "Would you like to delete prior downloads of Loop before proceeding?\n\n"
echo -e "Type 1 and hit enter to delete.\nType 2 and hit enter to continue without deleting.\n\n"
options=("Delete old downloads" "Do not delete old downloads")
select opt in "${options[@]}"
do
    case $opt in
        "Delete old downloads")
            rm -rf ~/Downloads/BuildLoop/*
            break
            ;;
        "Do not delete old downloads")
            break
            ;;
        *)
    esac
done

clear
echo -e "The code will now begin downloading. The files will be saved in your Downloads folder and Xcode will automatically open when the download is complete.\n\n"
echo -e "Type 1 and hit enter to begin downloading.\nType 2 and hit enter to cancel.\n\n"
options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Continue")
            break
            ;;
        "Cancel")
            echo -e "\n${RED}User cancelled!${NC}";
            exit 0
            break
            ;;
        *)
    esac
done

clear

LOOP_BUILD=$(date +'%y%m%d-%H%M')
LOOP_DIR=~/Downloads/BuildLoop/$FOLDERNAME-$LOOP_BUILD
mkdir ~/Downloads/BuildLoop/
mkdir $LOOP_DIR
cd $LOOP_DIR
pwd
clear
echo -e "\n\n Downloading Loop to your Downloads folder.\n--------------------------------\n"
git clone --branch=$BRANCH --recurse-submodules $REPO

echo -e "--------------------------------\n\n🛑 Please check for errors listed above before proceeding. If there are no errors listed, code has successfully downloaded.\n"
echo -e "Type 1 and hit enter to open Xcode. You may close the terminal after Xcode opens\n\n"

options=("Continue" "Cancel")
select opt in "${options[@]}"
do
    case $opt in
        "Continue")
            xed ./Loop.xcworkspace
            exit 0
            break
            ;;
        "Cancel")
        echo -e "\n${RED}User cancelled!${NC}";
        exit 0
        break
        ;;
        *)
    esac
done
