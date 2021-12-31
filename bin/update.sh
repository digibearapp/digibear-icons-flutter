#!/bin/bash

#

set -e

# get json of releases from github api, use -s for silent
echo "Downloading latest digibear icons release zip"
JSON=$(curl https://api.github.com/repos/digibearapp/digibear-icons/releases/latest)
# Extract from the json the line with the key "browser_download_url"
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/digibearapp/digibear-icons/releases/latest \
    | grep browser_download_url \
| cut -d '"' -f 4);
# DOWNLOAD_URL=$(grep "browser_download_url" <<< $JSON | cut -d '"' -f 4)
# DOWNLOAD_URL=$(grep "browser_download_url.*zip" <<< $JSON | cut -d : -f 2,3 | tr -d \")

# getting version
VERSION=$(echo $JSON | grep "tag_name" | cut -d : -f 2,3 | tr -d \",v)

echo "-------- DOWNLOAD URL:"
echo "$DOWNLOAD_URL"
echo "----------------------"

# download using the url from and saving in digibear-icons.zip, use -q for quiet
wget -O digibear-icons.zip $DOWNLOAD_URL

# unzip the file and get the json in the project dir
echo "Extracting font json files"
unzip -j -o ./digibear-icons.zip "digibear-icons/line/selection.json" -d .
mv selection.json digibear-icons-line.json
unzip -j -o ./digibear-icons.zip "digibear-icons/fill/selection.json" -d .
mv selection.json digibear-icons-fill.json
unzip -j -o ./digibear-icons.zip "digibear-icons/duotone/selection.json" -d .
mv selection.json digibear-icons-duotone.json

# unzip the file an get the font in the fonts dir
echo "Extracting font ttf files"
unzip -j -o ./digibear-icons.zip "digibear-icons/line/fonts/digibear-icons-line.ttf" -d ../lib/fonts
unzip -j -o ./digibear-icons.zip "digibear-icons/fill/fonts/digibear-icons-fill.ttf" -d ../lib/fonts
unzip -j -o ./digibear-icons.zip "digibear-icons/duotone/fonts/digibear-icons-duotone.ttf" -d ../lib/fonts

# Start generation
echo "Generation started using digibear.json files"

echo "Generating package digibear_icons.dart files"
dart ./generate_icons.dart ./digibear-icons-line.json
dart ./generate_icons.dart ./digibear-icons-fill.json
dart ./generate_icons.dart ./digibear-icons-duotone.json

dart ./generate_icon_data.dart
dart format ../lib/src/digibear_icon_data.dart
dart format ../lib/src/digibear_icons.dart

echo "All files generated"

# update package version
# sed -i ".bak" "2s/.*/version: $VERSION # auto generated version/" pubspec.yaml

echo "Removing temp files"
rm ./digibear-icons.zip ./digibear-icons-line.json ./digibear-icons-fill.json ./digibear-icons-duotone.json