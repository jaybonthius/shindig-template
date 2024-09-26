#!/bin/bash

# Directory to watch
WATCH_DIR="pollen"

# File extensions to watch and their corresponding commands
# Use semicolons to separate multiple commands
# Use {file} as a placeholder for the filename
declare -A EXTENSIONS
EXTENSIONS[".html.p"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file};poetry run djlint {file} --reformat;raco pollen render {file}"
EXTENSIONS[".pm"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file};raco pollen render {file}"
EXTENSIONS[".rkt"]="python -m scripts.tailwind_sorter.tailwind_sorter --file_path {file};raco fmt -i --width 88 {file};raco pollen render pollen"

# Function to process file based on its extension
process_file() {
    local file="$1"
    for ext in "${!EXTENSIONS[@]}"; do
        if [[ "${file}" == *"${ext}" ]]; then
            IFS=';' read -ra COMMANDS <<< "${EXTENSIONS[$ext]}"
            for cmd in "${COMMANDS[@]}"; do
                cmd="${cmd//\{file\}/$file}"
                eval "$cmd"
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