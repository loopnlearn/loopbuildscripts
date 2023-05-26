#!/bin/bash

# Define the source and destination directories
SRC_DIR="src"
DEST_DIR="."

# List of scripts to process
SCRIPTS=(
  "BuildSelectScript.sh"
  "BuildLoop.sh"
  "BuildLoopReleased.sh"
  "BuildLoopFollow.sh"
  "BuildLoopCaregiver.sh"
  "CustomizationSelect.sh"
  "BuildFreeAPS.sh"
  "BuildLoopDev.sh"
  "BuildxDrip4iOS.sh"
  "BuildGlucoseDirect.sh"
  "Build_iAPS.sh"
  "CleanProfiles.sh"
  "CleanDerived.sh"
  "DeleteOldDownloads.sh"
  "XcodeClean.sh"
  "BuildLoopProfiles.sh"
  )

generated_comment="# -----------------------------------------------------------------------------\n\
# This file is GENERATED. DO NOT EDIT directly.\n\
# If you want to modify this file, edit the corresponding file in the src/\n\
# directory and then run the build script to regenerate this output file.\n\
# -----------------------------------------------------------------------------"

inline_file() {
  local input_file=$1
  local output_file=$2
  local depth=$3
  local max_depth=10

  echo $input_file

  if [[ $depth -gt $max_depth ]]; then
    echo "Max inline depth reached. Skipping the line: $line"
    return
  fi

  # Add a starting comment for the inlined file
  echo -e "\n# *** Start of inlined file: $input_file ***" >> "$output_file"

  # Copy the shebang (first line) from the input file to the output file
  if [[ $depth -eq 1 ]]; then
    head -n 1 "$input_file" > "$output_file"
    echo -e "$generated_comment" >> "$output_file"
  fi

  # Process the rest of the input file and inline the specified files
  while IFS= read -r line || [[ -n $line ]]
  do
    if [[ $line == "#!inline "* ]]; then
      COMMON_FILE=${line#*#!inline }
      inline_file "$SRC_DIR/$COMMON_FILE" "$output_file" $((depth+1))
    else
      echo "$line" >> "$output_file"
    fi
  done < <(if [[ $depth -eq 1 ]]; then tail -n +2 "$input_file"; else cat "$input_file"; fi)

  # Add an ending comment for the inlined file
  echo -e "# *** End of inlined file: $input_file ***\n" >> "$output_file"
}

# Process each script
for script in "${SCRIPTS[@]}"; do
  input_file="$SRC_DIR/$script"

  # Check if the source file exists
  if [[ ! -f "$input_file" ]]; then
    echo "Source file $input_file does not exist. Skipping."
    continue
  fi

  echo "Processing $script..."
  output_file="$DEST_DIR/$script"

  # Remove output file if it exists
  if [[ -f "$output_file" ]]; then
    rm "$output_file"
  fi

  # Inline the specified file into the script with the depth of 1
  inline_file "$input_file" "$output_file" 1
  chmod +x "$output_file"
  echo "Done. Created $output_file."
done

echo "All scripts processed."