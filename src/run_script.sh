# run_script Function:
# This function accepts two parameters:
# 1. script_name: The name of the script to be executed.
# 2. extra_arg (optional): An additional argument to be passed to the script.
# The function fetches and executes the script either from a local directory (if LOCAL_SCRIPT is set to "1") or from a remote GitHub repository.
# If the script fails to execute, the function prints an error message and terminates the entire shell script with a non-zero status code.
run_script() {
    local script_name=$1
    local extra_arg=$2
    echo -e "\n--------------------------------\n"
    echo -e "Executing Script: $script_name"
    echo -e "\n--------------------------------\n"

    if [[ ${LOCAL_SCRIPT:-0} -eq 1 ]]; then
        /bin/bash -c "$(cat $script_name)" _ "$extra_arg"
    else
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/loopnlearn/LoopBuildScripts/$SCRIPT_BRANCH/$script_name)" _ "$extra_arg"
    fi

    if [ $? -ne 0 ]; then
        echo "Error: Failed to execute $script_name"
        exit 1
    fi
}
