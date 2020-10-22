# LoopBuildScripts

These scripts simplify some tasks for building Loop and FreeAPS.

### Workspace Build Prep

#### To Build FreeAPS
1. Open terminal
2. Copy/Paste this code: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildFreeAPS.sh)"`
3. Hit Enter

The latest FreeAPS workspace files will download to your downloads folder /BuildLoop/FreeAPS. Each folder will be timestamped with date-HHMM so if you download in the future, you can easily know which is the latest. As soon as the download is complete, xcode will open the FreeAPS workspace file.


#### To Build Loop Master branch
1. Open terminal
2. Copy/Paste this code: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/jonfawcett/LoopBuildScripts/main/BuildLoopMaster.sh)"`
3. Hit Enter

The latest Loop workspace files will download to your downloads folder /BuildLoop/Loop. Each folder will be timestamped with date-HHMM so if you download in the future, you can easily know which is the latest. As soon as the download is complete, xcode will open the Loop workspace file.
