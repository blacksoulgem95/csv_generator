#!/usr/bin/env bash

if ! command -v jq &> /dev/null
then
    echo "jq could not be found - please install it (eg. apt install jq )"
    exit 1
fi

sudo curl -sL https://raw.githubusercontent.com/blacksoulgem95/csv_generator/main/logo.txt | echo

TAG=$(curl -sL https://api.github.com/repos/blacksoulgem95/csv_generator/releases/latest |  jq -r ".tag_name")

wget "https://github.com/blacksoulgem95/csv_generator/releases/download/$TAG/CSVGenerator-$TAG-linux.zip" -O "csvgen.zip"

sudo rm -rf /opt/csvgenerator || true
sudo mkdir /opt/csvgenerator

sudo unzip csvgen.zip -d /opt/csvgenerator

sudo cat <<EOT >> /opt/csvgenerator/icon.desktop
[Desktop Entry]
Version=$TAG
Type=Application
Name=CSV Generator
Comment=QA Tool to generate test CSVs
Exec=/opt/csvgenerator/lib/csv_generator
Icon=/opt/csvgenerator/csv_generator.png
Terminal=false
EOT

find /opt/csvgenerator -type d -exec sudo chmod 755 {} \;
find /opt/csvgenerator -type f -exec sudo chmod 644 {} \;
sudo chmod a+x /opt/csvgenerator/lib/csv_generator

rm ./csvgen.zip

ln -s /opt/csvgenerator/icon.desktop "./CSV Generator.desktop"
ln -s /opt/csvgenerator/icon.desktop "/usr/share/applications/CSV Generator.desktop"

chmod a+rwx "./CSV Generator.desktop"
chmod a+rwx "/usr/share/applications/CSV Generator.desktop"

echo "CSV Generator installed under /opt/csvgenerator - and in this directory has been created a .desktop file to link the application"