#!/bin/bash

# Directory to watch
WATCH_DIR="."

# File extension to watch
EXTENSION=".rkt"

# Command to run
TW_SORT_CMD="python -m scripts.tailwind_sorter.tailwind_sorter --file_path"
FMT_CMD="raco fmt -i --width 88"

inotifywait -m -e close_write -e moved_to --format "%w%f" "${WATCH_DIR}" | while read FILE
do
    if [[ "${FILE}" == *"${EXTENSION}" ]]; then
        $TW_SORT_CMD "${FILE}"
        $FMT_CMD "${FILE}"
    fi
done
