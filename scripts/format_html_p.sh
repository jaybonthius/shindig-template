#!/bin/bash

# Directory to watch
WATCH_DIR="."

# File extension to watch
EXTENSION=".html.p"

# Command to run
TW_SORT_CMD="python -m scripts.tailwind_sorter.tailwind_sorter --file_path"

inotifywait -m -e close_write -e moved_to --format "%w%f" "${WATCH_DIR}" | while read FILE
do
    if [[ "${FILE}" == *"${EXTENSION}" ]]; then
        $TW_SORT_CMD "${FILE}"
    fi
done
