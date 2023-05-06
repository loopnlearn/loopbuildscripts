#!/bin/bash

# Define the source and destination directories
SRC_DIR="."
DEST_DIR=".."

# List of scripts to process
SCRIPTS=("BuildLoop.sh" "Build_iAPS.sh" "BuildLoopCaregiver.sh" "BuildLoopFollow.sh")

generated_comment="# -----------------------------------------------------------------------------\n\
# This file is GENERATED. DO NOT EDIT directly.\n\
# If you want to modify this file, edit the corresponding file in the src/\n\
# directory and then run the build script to regenerate this output file.\n\
# -----------------------------------------------------------------------------"

# Function to inline the specified file
inline_file() {
  local input_file=$1
  local output_file=$2

  # Copy the shebang (first line) from the input file to the output file
  head -n 1 "$input_file" > "$output_file"

  # Append the generated comment to the output file
  echo -e "$generated_comment" >> "$output_file"

  # Process the rest of the input file and inline the specified files
  tail -n +2 "$input_file" | while IFS= read -r line
  do
    if [[ $line == "#!inline "* ]]; then
      COMMON_FILE=${line#*#!inline }
      cat "$SRC_DIR/$COMMON_FILE" >> "$output_file"
    else
      echo "$line" >> "$output_file"
    fi
  done
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

  # Inline the specified file into the script
  inline_file "$input_file" "$output_file"
  chmod +x "$output_file"
  echo "Done. Created $output_file."
done

echo "All scripts processed."