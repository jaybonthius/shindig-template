#!/bin/bash

# Change to the parent directory of shindig and content
cd "$(dirname "$0")/.." || exit

# Watch for changes in *.rkt, *.p, and *.tldr files in both shindig and content directories
inotifywait -m -e modify,create,delete -r --format '%w%f' shindig content | while read -r file; do
    if [[ "$file" == *.rkt || "$file" == *.p || "$file" == *.pm || "$file" == *.tldr ]]; then
        echo "Change detected in $file"
        
        # If the change is in a .rkt file or in the shindig directory
        if [[ "$file" == *.rkt || "$file" == shindig/* ]]; then
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


        if [[ "$file" == *.pm ]]; then
            file=$(echo "$file" | sed 's/content\///')
            cd content
            raco pollen render "$file"
            if [[ "$file" == *.poly.* ]]; then
                raco pollen render -t pdf "$file"
            fi
            cd ../
            echo "Rendered $file using raco pollen"
        fi

        # If the change is in a .tldr file
        if [[ "$file" == *.tldr ]]; then
            filename="$file"
            dirname="$(dirname "$file")"
            
            # Export light SVG
            pnpm tldraw export "$filename" --transparent --output "$dirname/light.svg"
            
            # Export dark SVG
            pnpm tldraw export "$filename" --transparent --output "$dirname/dark.svg" --dark
            
            # Export light PNG
            pnpm tldraw export "$filename" --transparent --output "$dirname/light.png" --format png
            
            # Export dark PNG
            pnpm tldraw export "$filename" --transparent --output "$dirname/dark.png" --format png --dark
            
            echo "tldr file rendered"
        fi
    fi
done