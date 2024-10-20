#!/bin/bash

# Change to the content directory relative to CWD
cd "$(dirname "$0")/../content" || exit

# Watch for changes in *.rkt and *.p files
inotifywait -m -e modify,create,delete -r --format '%w%f' . | while read -r file; do
    if [[ "$file" == *.rkt ]]; then
        echo "Change detected in $file"
        
        # "Save" all *.poly.pm files
        find . -name "*.poly.pm" -type f -exec touch {} +
        echo "All *.poly.pm files have been 'saved'"
    elif [[ "$file" == *.p ]]; then
        echo "Change detected in $file"
        
        # Call raco pollen render for the changed .p file
        raco pollen render "$file"
        echo "Rendered $file using raco pollen"
        
        # "Save" all *.poly.pm files
        find . -name "*.poly.pm" -type f -exec touch {} +
        echo "All *.poly.pm files have been 'saved'"
    fi
done