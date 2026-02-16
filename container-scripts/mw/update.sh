#!/bin/bash

# Default directory if no argument is provided
DEFAULT_DIR="/data/project/wdump/math"

# Use the provided directory or fallback to default
DIR="${1:-$DEFAULT_DIR}"

# Check if the directory exists
if [ ! -d "$DIR" ]; then
    echo "Directory $DIR does not exist."
    exit 1
fi

# Loop through all files in the specified directory
for filepath in "$DIR"/*; do
	[[ -d $filepath ]] && continue
	filename="${filepath##*/}"
	lang="${filename%.xml*}"
	echo "processing wiki $lang.beta.math.wmflabs.org" 
	export HTTP_HOST=$lang.beta.math.wmflabs.org
	/var/www/html/w/./maintenance/update.php --wiki $lang --quick 2>&1 > "$DIR"/updatelog/$filename.log || echo "Error updating $lang"
done
