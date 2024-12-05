#!/bin/bash

# TODO: this script is garbage, clean it up

# Change to the parent directory of shindig and content
cd "$(dirname "$0")/.." || exit

# Watch for changes in *.rkt, *.p, and *.tldr files in both shindig and content directories
inotifywait -m -e modify,create,delete,moved_from,moved_to -r --format '%e %w%f' shindig content | while read -r event file; do
    if [[ "$file" == content/config.rkt ]]; then
        make pagetree
        echo "Updated pagetree due to change in config.rkt"
    fi
    
    if [[ "$file" == *.rkt || "$file" == *.p || "$file" == *.pm || "$file" == *.tldr ]]; then
        if [[ "$file" == *.rkt || "$file" == shindig/* ]]; then
            find content -name "*.pm" -type f -exec touch {} +
            echo "All *.pm files in content have been 'saved'"
        fi
        
        if [[ "$file" == *.p ]]; then
            raco pollen render "$file"
            echo "Rendered $file using raco pollen"
            find content -name "*.pm" -type f -exec touch {} +
            echo "All *.pm files in content have been 'saved'"
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