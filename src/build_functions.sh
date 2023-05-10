############################################################
# Common functions used by multiple build scripts
#    - Start of build_functions.sh common code
############################################################

SCRIPT_DIR="${BUILD_DIR}/Scripts"

if [ ! -d "${BUILD_DIR}" ]; then
    mkdir "${BUILD_DIR}"
fi
if [ ! -d "${SCRIPT_DIR}" ]; then
    mkdir "${SCRIPT_DIR}"
fi

STARTING_DIR="${PWD}"

# Set default values only if they haven't been defined as environment variables
: ${SCRIPT_BRANCH:="main"}

############################################################
# set up nominal values
#   these can be later overwritten by flags
#   for convenience when testing (or for advanced usersS)
############################################################

# FRESH_CLONE
#   Default value is 1, which means:
#     Download fresh clone every time script is run
: ${FRESH_CLONE:="1"}
# CLONE_STATUS used to test error messages
#   Default value is 0, which means no errors with clone
: ${CLONE_STATUS:="0"}

# Prepare date-time stamp for folder
DOWNLOAD_DATE=$(date +'%y%m%d-%H%M')

# BUILD_DIR=~/Downloads/"BuildLoop"
# OVERRIDE_FILE=LoopConfigOverride.xcconfig
OVERRIDE_FULLPATH="${BUILD_DIR}/${OVERRIDE_FILE}"

############################################################
# Define the rest of the functions (usage defined above):
############################################################

#!inline common.sh
#!inline building.sh

############################################################
# End of functions used by script
#    - end of build_functions.sh common code
############################################################
