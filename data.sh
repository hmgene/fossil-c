#!/bin/bash

src="bigdata"
dst="data"
maxsize=$((30 * 1024 * 1024))  # 30 MB in bytes

# find all files under bigdata
find "${src%/}/" -type f | while read -r f; do
    # get file size
    size=$(stat -c%s "$f")
    
    if (( size < maxsize )); then
        # get relative path
        rel=${f#$src/}
        # create destination directory
        #mkdir -p "$dst/$(dirname "$rel")"
        # copy file
        #cp "$f" "$dst/$rel"
        echo "Copied $f -> $dst/$rel ($size bytes)" > /dev/null
        
    else
        echo "ln -s $f $dst/$rel"
    fi
done
