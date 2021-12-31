import 'dart:convert';
import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'paths.dart';
import 'utils.dart';

String generateDbIconDoc(String iconName, DbIconStyle iconStyle) {
  final iconStyleName = iconStyle.name;
  return '''
    /// [$iconName-$iconStyleName](https://raw.githubusercontent.com/digibearapp/digibear-icons/master/assets/$iconStyleName/$iconName-$iconStyleName.svg)
  ''';
}

//  static const dayRainDuotone = DigibearDuotoneIconData(
//     0xef73,
//     secondary: [DigibearDuotoneIconData(0xef72)],
//   );

String generateIconDataInstanceFromIconStyleAndCode(
    DbIconStyle iconStyle, String code) {
  final iconStyleCappedName = iconStyle.name;
  return '''
  Db${iconStyleCappedName}IconData($code)
  ''';
}

String generateDbIconDefinition(
  String iconName,
  DbIconStyle iconStyle,
  List<String> codes,
) {
  final iconStyleCappedName = iconStyle.name;
  final firstCode = codes[0];
  final restCodes = codes.skip(1);
  final secondaryCodes = restCodes.map(
      (code) => generateIconDataInstanceFromIconStyleAndCode(iconStyle, code));
  final secondary = iconStyle.isMulticolor
      ? '''
  , secondary: [${secondaryCodes.join(",")}],
  '''
      : '';

  return '''
  static const $iconName$iconStyleCappedName = Db${iconStyleCappedName}IconData($firstCode)$secondary;
  ''';
}

String generateDbIcon(
  String iconName,
  DbIconStyle iconStyle,
  List<String> codes,
) {
  final doc = generateDbIconDoc(iconName, iconStyle);
  final definition = generateDbIconDefinition(iconName, iconStyle, codes);

  return '''
    $doc
    $definition
  ''';
}

String convertCodeToHex(dynamic code) {
  final codeInt = int.parse(code.toString());
  return '0x${codeInt.toRadixString(16)}';
}

List<String> extractCodesFromIcon(dynamic icon) {
  final maybeMultiCodes = icon['properties']['codes'] as List<dynamic>?;

  return null != maybeMultiCodes
      ? maybeMultiCodes.map(convertCodeToHex).toList()
      : [convertCodeToHex(icon.properties['code'] as int)];
}

String generateDbIconsForStyle(dynamic icons, DbIconStyle iconStyle) {
  final sb = StringBuffer();

  for (int i = 0; i < (icons.length as int); i++) {
    final icon = icons[i];
    final fullName = icon['properties']['name'] as String;
    final iconName = formatName(fullName);
    final codes = extractCodesFromIcon(icon);

    final dbIcon = generateDbIcon(iconName, iconStyle, codes);
    sb.writeln(dbIcon);
  }
  return sb.toString();
}

String generateDbIconsForStyles(dynamic icons) {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final dbIconsForStyle = generateDbIconsForStyle(icons, iconStyle);
    sb.writeln(dbIconsForStyle);
  }

  return sb.toString();
}

String generateDbIcons(dynamic icons) {
  return '''
library digibear_icons_flutter;

$header

import 'package:digibear_icons_flutter/src/digibear_icon_data.dart';

abstract class DigibearIcons {
  ${generateDbIconsForStyles(icons)}
}
''';
}

/// Digibear Icons generator
void main(List<String> arguments) {
  final jsonFile = File(arguments.first);
  assert(!jsonFile.existsSync());
  final icons = json.decode(jsonFile.readAsStringSync())['icons'];
  final readStyle = (icons[0]['properties']['name'] as String).split('-').last;
  final iconStyle =
      DbIconStyle.values.where((iconStyle) => iconStyle.name == readStyle);
  if (iconStyle.isEmpty) {
    throw ErrorDescription(
        'Style missing/not matching: got $readStyle but available styles are the following: ${DbIconStyle.values.map((iconStyle) => iconStyle.name)}, you probably have to add the missing style to the ');
  }

  final resultFile = File(digibearIconsFilePath);
  resultFile.writeAsStringSync(generateDbIcons(icons));
}
