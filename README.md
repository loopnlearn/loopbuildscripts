# loopbuildscripts

## Introduction

These scripts simplify some tasks for building Loop and other DIY code from the GitHub repositories.

Most users should use the BuildSelectScript.sh script, otherwise known as the **Build Select Script**. This script has a menu for users to choose the option they want.

* Menu options are updated and expanded
* Script returns to top-menu after each option completes
* All Build scripts include automatic signing

The **Build Select Script** will help you to:

1. Download and Build Loop
2. Download and Build Related Apps
3. Run Maintenance Utilities
4. Run Customization Utilities

The `Download and Build Loop` option offers the released version of Loop and a released version with some commonly requested patches added (Loop with Patches).

The `Download and Build Related Apps` option includes Loop Follow, LoopCaregiver, xDrip4iOS and GlucoseDirect.

The `Run Maintenance Utilities` option includes Delete Old Downloads as well as other Xcode clean-up options.

The `Run Customization Utilities` option leads to the Customization Select script and Profile Feature Customization script.

In addition to selecting options from the top-menu of **BuildSelectScript.sh**, each of the scripts can be run directly.

There are several build scripts for specific code not included in **BuildSelectScript.sh**. These are:

* [BuildLoopDev.sh](#buildloopdev)
* [BuildFreeAPS.sh](#buildfreeaps)
* [Build_iAPS.sh](#build_iaps)


### Build Select Script

This is documented in

* [LnL: Build Select Script](https://www.loopandlearn.org/build-select)
* [LoopDocs: Build Select Script](https://loopkit.github.io/loopdocs/build/step14/#download-loop)

#### main branch

Note: the commands in the README are for the main branch of the scripts. If you are a developer or tester using a different branch, please read [Developer Tips](#developer-tips).

### Command to Execute Build Select Script

1. Open terminal
2. Copy/Paste this code into terminal (use copy icon, bottom right): 

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildSelectScript.sh)"
```

3. Hit Enter and follow prompts


### Individual Scripts

Each scripts can be run directly with the commands listed below.

1. Open terminal
2. Copy/Paste selected code into terminal (use copy icon, bottom right):
3. Hit Enter and follow prompts

#### Scripts included in BuildSelectScript.sh

Use these commands to run a script directly instead of using the **BuildSelectScript.sh** menu.

#### BuildLoopReleased

This builds the released version of Loop or Loop with Patches.

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildLoopReleased.sh)"
```
#### BuildLoopFollow

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildLoopFollow.sh)"
```

#### BuildLoopCaregiver

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildLoopCaregiver.sh)"
```

#### BuildxDrip4iOS

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildxDrip4iOS.sh)"
```

#### DeleteOldDownloads

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/DeleteOldDownloads.sh)"
```

#### CustomizationSelect

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/CustomizationSelect.sh)"
```

#### ProfileSelect

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/ProfileSelect.sh)"
```

### Scripts not included in Build Select Script

These scripts can only be run directly.

#### BuildLoopDev

This script enables building the Loop dev branch. The menu provides the choice of dev or a lightly tested version (specific commit) of the dev branch.

If you want to build a different branch, for example `branch_name`

* Add ` - branch_name` to the end of the command below
* There must be a space after the ending quote followed by hyphen, another space and then the branch name
* This bypasses the menu and downloads the desired branch from LoopKit/LoopWorkspace

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildLoopDev.sh)"
```

#### BuildFreeAPS

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/BuildFreeAPS.sh)"
```

#### Build_iAPS

```
/bin/bash -c "$(curl -fsSL \
  https://raw.githubusercontent.com/loopnlearn/loopbuildscripts/main/Build_iAPS.sh)"
```

## Developer Tips

As of 20-May-2023, the **BuildSelectScript.sh** replaces the old BuildLoop.sh. If anyone executes the old BuildLoop script, they are given the correct command to run the BuildSelectScript.sh.

The scripts are now significantly easier to create and maintain.

When these scripts are being modified and tested, the developers will be working in a feature or development (dev) branch. In addition, they can use some special flags to simplify and speed up testing.

In order to test with a different branch, first configure that branch in your terminal with the export command. If using a branch other than dev, then modify the command with that branch name:

```
export SCRIPT_BRANCH=dev
```

Then for all commands found earlier in this README, replace the word main with $SCRIPT_BRANCH.

When testing locally, there are other test variables you can configure. Be sure to read these two files:
* custom_config.sh
* clear_custom_config.sh

### Inlining Scripts

This project uses a script inlining system to generate executable scripts from source files. The source files for each script are located in the src directory, and the generated scripts are output to the root directory.

To modify a script, simply edit the corresponding source file in the src directory, and then run the build script (./build.sh) to regenerate the output file. The build script will inline any required files and generate the final executable script.

For example, if you want to modify the BuildSelectScript.sh script, you would edit the src/BuildSelectScript.sh file, and then run type `./build.sh` in the root directory. The build.sh script will then generate the BuildSelectScript.sh file in the root directory, which can be executed.

Note that the build system uses special comments to indicate which files should be inlined. Any line in a script that starts with #!inline will be replaced with the contents of the specified file. The build system will inline files up to a maximum depth of 10, to prevent infinite recursion.

To learn more about the inlining process and how it works, please see the comments in the build.sh script.

### Environment Variable

The available environment variables used by the scripts are set using the `export` command and cleared with the `unset` command.

Once you use an export command, that environment variable stays set in that terminal and will be used by the script. 

* You can use the unset command to stay in the same terminal
* You can use CMD-N while in any terminal window to open a new terminal window, then switch to the new window
