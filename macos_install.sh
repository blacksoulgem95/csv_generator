#!/usr/bin/env bash

TAG=$(curl -sL https://api.github.com/repos/blacksoulgem95/csv_generator/releases/latest |  jq -r ".tag_name")

wget "https://github.com/blacksoulgem95/csv_generator/releases/download/$TAG/CSVGenerator-$TAG-macos.zip" -O "csvgen.zip"

unzip csvgen.zip -d ./csvgen
mv "./csvgen/CSV Generator.app" "/Applications/CSV Generator.app"

rm -rf ./csvgen || true

echo "CSV Generator installed into /Applications/CSV Generator.app"