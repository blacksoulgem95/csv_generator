#!/usr/bin/env bash

if ! command -v jq &> /dev/null
then
    echo "jq could not be found - please install it ( brew install jq )"
    exit 1
fi

curl -sL https://raw.githubusercontent.com/blacksoulgem95/csv_generator/main/logo.txt | sudo echo

TAG=$(curl -sL https://api.github.com/repos/blacksoulgem95/csv_generator/releases/latest |  jq -r ".tag_name")

wget "https://github.com/blacksoulgem95/csv_generator/releases/download/$TAG/CSVGenerator-$TAG-macos.zip" -O "csvgen.zip"

unzip csvgen.zip -d ./csvgen
mv "./csvgen/CSV Generator.app" "/Applications/CSV Generator.app"

rm -rf ./csvgen || true

echo "CSV Generator installed into /Applications/CSV Generator.app"