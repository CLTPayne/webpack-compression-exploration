#!/usr/bin/env bash
#
# Upload all webpack emitted build assets to Amazon S3 buckets with correct 
# Content-Type key value pair for processing in the browswer post decompression

# Set error handling
set -eu -o pipefail


# Set build directory
DIRECTORY=$1

# Calculate original Content-Type
get_content_type() {
    local FILE=$1
    local FILE_EXTENSION=${FILE##*.}
    echo "Current extension of $FILE => .$FILE_EXTENSION"
    local EXTENSION
    if [[ "$FILE_EXTENSION" == "br" || "$FILE_EXTENSION" == "gz" ]]
    then 
        ORIGINAL_FILENAME=${FILE%.*}
        EXTENSION=${ORIGINAL_FILENAME##*.}
        echo -e "\x1b[36mOriginal extension of $FILE => .$EXTENSION\x1b[0m"
    elif [[ ! "$FILE_EXTENSION" == "br" || !"$FILE_EXTENSION" == "gz" ]]
    then 
        EXTENSION=$FILE_EXTENSION
        echo -e "\x1b[36mOriginal extension of $FILE => .$EXTENSION\x1b[0m"
    fi
    # TODO: Default Content-Type in S3 - should this be applied?
    # or does that over ride the correct value for source maps etc
    local CONTENT_TYPE
    if [[ "$EXTENSION" == "html" ]]; then CONTENT_TYPE="text/html; charset=utf-8"; fi
    if [[ "$EXTENSION" == "css" ]]; then CONTENT_TYPE="text/css; charset=utf-8"; fi
    if [[ "$EXTENSION" == "js" ]]; then CONTENT_TYPE="application/javascript"; fi
    echo -e "\033[31mContent-Type of $FILE => "$CONTENT_TYPE"\x1b[36m"
}

# Check to see if directory exists and list contents
if [ -d "$DIRECTORY" ]
then 
    echo "Built files found in ./dist folder"
    cd "$DIRECTORY"
    FILES=(*)
    echo "${#FILES[@]} files in the $DIRECTORY to be processed" # will echo number of files in array
    echo -e "Files to be processed are: \033[31m${FILES[@]}\x1b[36m" # will list all files of the array
    for FILE in "${FILES[@]}"; do  
        get_content_type "$FILE"
        # TODO: Upload to S3 storage bucket with AWS CLI
        # e.g. node_modules/.bin/aws s3 $file --content-type 
    done 
elif [ ! -d "$DIRECTORY" ]
then
    echo "$DIRECTORY folder not found"
    echo "Run the build step to generate static assets"
fi
