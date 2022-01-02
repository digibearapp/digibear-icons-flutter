// ignore_for_file: avoid_positional_boolean_parameters

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
  final firstCode = codes.removeLast();
  final restCodes = codes;
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

String generateDbIcons(
  dynamic icons,
  DbIconStyle iconStyle,
  bool isFirst,
  bool isLast,
) {
  final dbIconsForStyle = generateDbIconsForStyle(icons, iconStyle);

  if (isFirst) {
    return '''
    library digibear_icons_flutter;

    $header

    import 'package:digibear_icons_flutter/src/db_icon_data.dart';

    abstract class DbIcons {
      $dbIconsForStyle
  ''';
  } else {
    if (isLast) {
      return '''
      $dbIconsForStyle
      }
      ''';
    } else {
      return dbIconsForStyle;
    }
  }
}

void main(List<String> arguments) {
  final jsonFile = File(arguments.first);
  assert(!jsonFile.existsSync());
  final isFirst = arguments[1] == "true";
  final isLast = arguments[2] == "true";
  final icons = json.decode(jsonFile.readAsStringSync())['icons'];
  final readStyle = (icons[0]['properties']['name'] as String).split('-').last;
  final iconStyle =
      DbIconStyle.values.where((iconStyle) => iconStyle.name == readStyle);
  if (iconStyle.isEmpty || iconStyle.length > 1) {
    throw MissingStyleError(
      'Style missing/not matching: got $readStyle but available styles are the following: ${DbIconStyle.values.map((iconStyle) => iconStyle.name)}, you probably have to add the missing style to the ',
    );
  }

  final resultFile = File(dbIconsFilePath);
  resultFile.writeAsStringSync(
    generateDbIcons(icons, iconStyle.single, isFirst, isLast),
    mode: FileMode.append,
  );
}

class MissingStyleError extends Error {
  String msg;
  MissingStyleError(this.msg);

  @override
  String toString() => msg;
}
