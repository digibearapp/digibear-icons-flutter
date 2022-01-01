import 'dart:convert';
import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';

import 'constants.dart';
import 'paths.dart';
import 'utils.dart';

String generateDbIconDoc(String fullName, DbIconStyle iconStyle) {
  final nameWithoutStyleArray = fullName.split('-');
  nameWithoutStyleArray.removeLast();
  final nameWithoutStyle = nameWithoutStyleArray.join('-');
  final iconStyleName = iconStyle.name;
  return '''
    /// [$fullName](https://raw.githubusercontent.com/digibearapp/digibear-icons/main/icons/$iconStyleName/$nameWithoutStyle.svg)''';
}

String generateIconDataInstanceFromIconStyleAndCode(
  DbIconStyle iconStyle,
  String code,
) {
  final iconStyleCappedName = iconStyle.cappedName;
  return '''
  Db${iconStyleCappedName}IconData($code)
  ''';
}

String generateDbIconDefinition(
  String iconName,
  DbIconStyle iconStyle,
  List<String> codes,
) {
  final iconStyleCappedName = iconStyle.cappedName;
  final firstCode = codes[0];
  final restCodes = codes.skip(1);
  final secondaryCodes = restCodes.map(
    (code) => generateIconDataInstanceFromIconStyleAndCode(iconStyle, code),
  );
  final secondary = iconStyle.isMulticolor && restCodes.isNotEmpty
      ? '''
  , secondary: [${secondaryCodes.join(",")}],
  '''
      : '';

  return '''
  static const $iconName$iconStyleCappedName = Db${iconStyleCappedName}IconData($firstCode$secondary);
  ''';
}

String generateDbIcon(
  String fullName,
  String iconName,
  DbIconStyle iconStyle,
  List<String> codes,
) {
  final doc = generateDbIconDoc(fullName, iconStyle);
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
      : [convertCodeToHex(icon['properties']['code'] as int)];
}

String generateDbIconsForStyle(dynamic icons, DbIconStyle iconStyle) {
  final sb = StringBuffer();

  for (int i = 0; i < (icons.length as int); i++) {
    final icon = icons[i];
    final fullName = icon['properties']['name'] as String;
    final iconName = formatName(fullName);
    final codes = extractCodesFromIcon(icon);

    final dbIcon = generateDbIcon(fullName, iconName, iconStyle, codes);
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

import 'package:digibear_icons_flutter/src/db_icon_data.dart';

abstract class DigibearIcons {
  ${generateDbIconsForStyles(icons)}
}
''';
}

void main(List<String> arguments) {
  final jsonFile = File(arguments.first);
  assert(!jsonFile.existsSync());
  final icons = json.decode(jsonFile.readAsStringSync())['icons'];
  final readStyle = (icons[0]['properties']['name'] as String).split('-').last;
  final iconStyle =
      DbIconStyle.values.where((iconStyle) => iconStyle.name == readStyle);
  if (iconStyle.isEmpty) {
    throw MissingStyleError(
      'Style missing/not matching: got $readStyle but available styles are the following: ${DbIconStyle.values.map((iconStyle) => iconStyle.name)}, you probably have to add the missing style to the ',
    );
  }

  final resultFile = File(dbIconsFilePath);
  resultFile.writeAsStringSync(generateDbIcons(icons));
}

class MissingStyleError extends Error {
  String msg;
  MissingStyleError(this.msg);

  @override
  String toString() => msg;
}
