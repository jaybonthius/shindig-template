#!/bin/bash

# Directory to watch
WATCH_DIR="."

# File extensions to watch and their corresponding commands
# Use semicolons to separate multiple commands
declare -A EXTENSIONS
EXTENSIONS[".html.p"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path"
EXTENSIONS[".pm"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path"
EXTENSIONS[".rkt"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path;raco fmt -i --width 88"

# Function to process file based on its extension
process_file() {
    local file="$1"
    for ext in "${!EXTENSIONS[@]}"; do
        if [[ "${file}" == *"${ext}" ]]; then
            IFS=';' read -ra COMMANDS <<< "${EXTENSIONS[$ext]}"
            for cmd in "${COMMANDS[@]}"; do
                eval "$cmd \"$file\""
            done
            break
        fi
    done
}

# Watch for file changes
inotifywait -m -e close_write -e moved_to --format "%w%f" "${WATCH_DIR}" | while read FILE
do
    process_file "${FILE}"
done