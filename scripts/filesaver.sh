#!/bin/bash

# Change to the parent directory of pollen-src and content
cd "$(dirname "$0")/.." || exit

# Watch for changes in *.rkt and *.p files in both pollen-src and content directories
inotifywait -m -e modify,create,delete -r --format '%w%f' pollen-src content | while read -r file; do
    if [[ "$file" == *.rkt || "$file" == *.p ]]; then
        echo "Change detected in $file"
        
        # If the change is in a .rkt file or in the pollen-src directory
        if [[ "$file" == *.rkt || "$file" == pollen-src/* ]]; then
            # "Save" all *.poly.pm files in content
            find content -name "*.pm" -type f -exec touch {} +
            echo "All *.pm files in content have been 'saved'"
        fi
        
        # If the change is in a .p file
        if [[ "$file" == *.p ]]; then
            # Call raco pollen render for the changed .p file
            raco pollen render "$file"
            echo "Rendered $file using raco pollen"
            
            # "Save" all *.poly.pm files in the directory of the changed file
            find "$(dirname "$file")" -name "*.pm" -type f -exec touch {} +
            echo "All *.pm files in $(dirname "$file") have been 'saved'"
        fi
    fi
done