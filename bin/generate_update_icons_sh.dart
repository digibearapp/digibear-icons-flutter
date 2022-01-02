import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';

import 'constants.dart';
import 'paths.dart';

String generateJsonUnzips() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final unzip = '''
    unzip -j -o ./digibear-icons.zip "digibear-icons/fonts/$iconStyleName/selection.json" -d .
    mv selection.json digibear-icons-$iconStyleName.json
    ''';
    sb.writeln(unzip);
  }

  return sb.toString();
}

String generateTtfUnzips() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final unzip = '''
    unzip -j -o ./digibear-icons.zip "digibear-icons/fonts/$iconStyleName/fonts/digibear-icons-$iconStyleName.ttf" -d ../lib/fonts
    ''';
    sb.writeln(unzip);
  }

  return sb.toString();
}

String generateIconGeneration() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final isFirst = DbIconStyle.values.first == iconStyle;
    final isLast = DbIconStyle.values.last == iconStyle;
    final iconStyleName = iconStyle.name;
    final iconGen = '''
    dart ./generate_icons.dart ./digibear-icons-$iconStyleName.json ${isFirst.toString()} ${isLast.toString()}
    ''';
    sb.writeln(iconGen);
  }

  return sb.toString();
}

String generateFileRemovals() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final iconGen = '''
    rm ./digibear-icons-$iconStyleName.json
    ''';
    sb.writeln(iconGen);
  }

  return sb.toString();
}

String generateUpdateSh() {
  return '''
#!/bin/bash

${header.replaceAll("//", "#")}

rm ../lib/src/db_icons.dart
set -e

# get json of releases from github api, use -s for silent
echo "Downloading latest digibear icons release zip"
JSON=\$(curl https://api.github.com/repos/digibearapp/digibear-icons/releases/latest)
# Extract from the json the line with the key "browser_download_url"
DOWNLOAD_URL=\$(curl -s https://api.github.com/repos/digibearapp/digibear-icons/releases/latest \\
        | grep browser_download_url \\
        | cut -d '"' -f 4);
# DOWNLOAD_URL=\$(grep "browser_download_url" <<< \$JSON | cut -d '"' -f 4)
# DOWNLOAD_URL=\$(grep "browser_download_url.*zip" <<< \$JSON | cut -d : -f 2,3 | tr -d \\")

echo "-------- DOWNLOAD URL:"
echo "\$DOWNLOAD_URL"
echo "----------------------"

# download using the url from and saving in digibear-icons.zip, use -q for quiet
wget -O digibear-icons.zip \$DOWNLOAD_URL

# unzip the file and get the json in the project dir
echo "Extracting font json files"
${generateJsonUnzips()}

# unzip the file an get the font in the fonts dir
echo "Extracting font ttf files"
${generateTtfUnzips()}

# Start generation
echo "Generation started using digibear.json files"

echo "Generating package digibear_icons.dart file"
${generateIconGeneration()}

dart ./generate_icon_data.dart
dart ./generate_db_icon.dart
dart format $dbIconDataFilePath
dart format $dbIconsFilePath
dart format $dbIconFilePath

echo "All files generated"

echo "Removing temp files"
rm ./digibear-icons.zip
${generateFileRemovals()}
''';
}

void main(List<String> arguments) {
  final resultFile = File(updateIconsShPath);
  resultFile.writeAsStringSync(generateUpdateSh());
}
