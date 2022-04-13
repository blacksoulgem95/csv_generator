#!/usr/bin/env bash

TAG=$(curl -sL https://api.github.com/repos/blacksoulgem95/csv_generator/releases/latest |  jq -r ".tag_name")

wget "https://github.com/blacksoulgem95/csv_generator/releases/download/$TAG/CSVGenerator-$TAG-linux.zip" -O "csvgen.zip"

rm -rf /opt/csvgenerator || true
mkdir /opt/csvgenerator

unzip csvgen.zip -d /opt/csvgenerator

cat <<EOT >> /opt/csvgenerator/icon.desktop
[Desktop Entry]
Version=$TAG
Type=Application
Name=CSV Generator
Comment=QA Tool to generate test CSVs
Exec=~/opt/csvgenerator/lib/csv_generator
Icon=/opt/csvgenerator/csv_generator.png
Terminal=false
EOT

ln -s /opt/csvgenerator/icon.desktop "./CSV Generator.desktop"

echo "CSV Generator installed under /opt/csvgenerator - and in this directory has been created a .desktop file to link the application"