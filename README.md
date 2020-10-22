# LoopBuildScripts

These scripts simplify some tasks for building Loop and FreeAPS.

### Workspace Build Prep
The latest FreeAPS or Loop workspace files will download to Downloads/BuildLoop/FreeAPS or Downloads/BuildLoop/Loop. Each folder will be timestamped with date-HHMM  and branch (for Loop) so you can easily know what each folder is in the future. As soon as the download is complete, xcode will open the the downloaded workspace file to sign and build.

#### To Build FreeAPS
1. Open terminal. Tip: press command-space to open spotlight search. Start typing term... and you will see the terminal application icon in the box. Hit enter to open.
2. Copy/Paste this code into terminal: 
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildFreeAPS.sh)"`*
3. Hit Enter

#### To Build Loop
1. Open terminal
2. Copy/Paste this code into terminal: 

Master Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildLoopMaster.sh)"`*

Dev Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildLoopDev.sh)"`*

Automatic Bolus Branch
*`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildLoopAutomaticBolus.sh)"`*

3. Hit Enter

