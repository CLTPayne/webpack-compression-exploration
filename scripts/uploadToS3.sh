#!/usr/bin/env bash
#
# Upload all webpack emitted build assets to Amazon S3 buckets
#

# Set error handling
set -eu -o pipefail

# Set build directory
DIRECTORY="./dist"

# Check to see if directory exists and list contents
if [ -d "$DIRECTORY" ]
then 
    echo "Built files found in ./dist folder"
    cd "$DIRECTORY"
    ls
elif [ ! -d "$DIRECTORY" ]
then
    echo "$DIRECTORY folder not found"
    echo "Run the build step to generate static assets"
fi
