#! /bin/bash

path=$1
prepath=/gcp/
# check path is empty
echo "$path"
if [ -z "$path" ]; then
        echo "path is empty"
        exit 1
fi

# check if path exists
for i in $path; do
        echo "$i"
        if [ ! -d "$PWD$prepath$i" ]; then
                echo "$PWD$prepath$i not exists"
                exit 1
        fi
done

