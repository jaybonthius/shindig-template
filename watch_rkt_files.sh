#!/bin/bash

# Directory to watch
WATCH_DIR="."

# File extension to watch
EXTENSION=".rkt"

# Command to run
CMD="raco fmt -i --width 88"

inotifywait -m -e close_write -e moved_to --format "%w%f" "${WATCH_DIR}" | while read FILE
do
    if [[ "${FILE}" == *"${EXTENSION}" ]]; then
        echo "File ${FILE} has been modified--formatting..."
        $CMD "${FILE}"
    fi
done
