#! /usr/bin/env bash

# run this script
# chmod +x copy.sh
# ./copy.sh

static_htdocs="/shared/httpd/static/htdocs/"

static_path="/shared/httpd/static/"

source_path=$(pwd)

# echo $source_path

source_build_path=$source_path"/build/"

echo $source_build_path

cd $static_path

# pwd

rm -rf *

mkdir htdocs

cd htdocs

# pwd

rsync -a "$source_build_path" . || exit 1