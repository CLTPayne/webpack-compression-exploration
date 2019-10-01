#!/usr/bin/env bash
#
# Upload all webpack emitted build assets to Amazon S3 buckets with correct 
# Content-Type key value pair for processing in the browswer post decompression

# Set error handling
set -eu -o pipefail

# Calculate original Content-Type
get_content_type() {
    local file=$1
    local file_extension=${file##*.}
    echo "Current extension of $file => .$file_extension"
    local extension
    if [[ "$file_extension" == "br" || "$file_extension" == "gz" ]]
    then 
        original_filename=${file%.*}
        extension=${original_filename##*.}
        echo -e "\x1b[36mOriginal extension of $file => .$extension\x1b[0m"
    elif [[ ! "$file_extension" == "br" || !"$file_extension" == "gz" ]]
    then 
        extension=$file_extension
        echo -e "\x1b[36mOriginal extension of $file => .$extension\x1b[0m"
    fi
    # TODO: Default Content-Type in S3 - should this be applied?
    # or does that over ride the correct value for source maps etc
    local content_type
    if [[ "$extension" == "html" ]]; then content_type="text/html; charset=utf-8"; fi
    if [[ "$extension" == "css" ]]; then content_type="text/css; charset=utf-8"; fi
    if [[ "$extension" == "js" ]]; then content_type="application/javascript"; fi
    echo -e "\033[31mContent-Type of $file => "$content_type"\x1b[36m"
}

# Set build directory
DIRECTORY="./dist"

# Check to see if directory exists and list contents
if [ -d "$DIRECTORY" ]
then 
    echo "Built files found in ./dist folder"
    cd "$DIRECTORY"
    files=(*)
    echo "${#files[@]} files in the $DIRECTORY to be processed" # will echo number of files in array
    echo -e "Files to be processed are: \033[31m${files[@]}\x1b[36m" # will list all files of the array
    for file in "${files[@]}"; do  
        get_content_type "$file"
        # TODO: Upload to S3 storage bucket with AWS CLI
        # e.g. node_modules/.bin/aws s3 $file --content-type 
    done 
elif [ ! -d "$DIRECTORY" ]
then
    echo "$DIRECTORY folder not found"
    echo "Run the build step to generate static assets"
fi
