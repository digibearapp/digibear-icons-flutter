import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';

import 'constants.dart';
import 'paths.dart';

String generateDbIconDataProps() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final cappedIconStyleName = iconStyle.cappedName;
    final prop = 'final Db${cappedIconStyleName}IconData $iconStyleName;';
    sb.writeln(prop);
  }

  return sb.toString();
}

String generateDbIconDataConstructorArgs() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final arg = 'required this.$iconStyleName,';
    sb.writeln(arg);
  }

  return sb.toString();
}

String generateDbIconStyleSwitchCases() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconStyleName = iconStyle.name;
    final switchCase = '''
      case DbIconStyle.$iconStyleName:
        return $iconStyleName;''';
    sb.writeln(switchCase);
  }

  return sb.toString();
}

String generateIconDataExtensionForStyle(DbIconStyle iconStyle) {
  final iconStyleName = iconStyle.name;
  final cappedIconStyleName = iconStyle.cappedName;
  final className = 'Db${cappedIconStyleName}IconData';
  final prop = iconStyle.isMulticolor ? 'final List<IconData>? secondary;' : '';
  final arg = iconStyle.isMulticolor ? ', {this.secondary}' : '';
  return '''
    /// Extension of the [IconData] class for a [DbIcon] with the $iconStyleName style
    class $className extends IconData {
      $prop

      const $className(int codePoint$arg)
          : super(
              codePoint,
              fontFamily: 'DigibearIcon$cappedIconStyleName',
              fontPackage: 'digibear_icons_flutter',
            );
    }
    ''';
}

String generateIconDataExtensions() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final iconDataExtension = generateIconDataExtensionForStyle(iconStyle);
    sb.writeln('$iconDataExtension\n');
  }

  return sb.toString();
}

String generateDbIconData() {
  return '''
library digibear_icons_flutter;

$header

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';
import 'package:flutter/widgets.dart';

/// [IconData] class for a [DbIcon]
class DbIconData {
  ${generateDbIconDataProps()}

  const DbIconData({
    ${generateDbIconDataConstructorArgs()}
  });

  IconData fromStyle(DbIconStyle style) {
    switch (style) {
      ${generateDbIconStyleSwitchCases()}
    }
  }
}

${generateIconDataExtensions()}
''';
}

void main(List<String> arguments) {
  final resultFile = File(dbIconDataFilePath);
  resultFile.writeAsStringSync(generateDbIconData());
}
