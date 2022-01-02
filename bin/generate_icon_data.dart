import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';

import 'constants.dart';
import 'paths.dart';

String generateIconDataExtensionForStyle(DbIconStyle iconStyle) {
  final iconStyleName = iconStyle.name;
  final cappedIconStyleName = iconStyle.cappedName;
  final className = 'Db${cappedIconStyleName}IconData';
  final prop = iconStyle.isMulticolor ? 'final List<IconData>? secondary;' : '';
  final arg = iconStyle.isMulticolor ? ', {this.secondary}' : '';
  return '''
    /// Extension of the [IconData] class for a [DbIcon] with the $iconStyleName style
    class $className extends DbIconData {
      $prop

      const $className(int codePoint$arg)
          : super(
              codePoint,
              isMulticolor: ${iconStyle.isMulticolor},
              fontFamily: 'DigibearIcon$cappedIconStyleName',
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

import 'package:flutter/widgets.dart';

/// [IconData] class for a [DbIcon]
abstract class DbIconData extends IconData {
  final bool isMulticolor;

  const DbIconData(
    int codePoint, {
    required this.isMulticolor,
    required String fontFamily,
  }) : super(
          codePoint,
          fontFamily: fontFamily,
          fontPackage: 'digibear_icons_flutter',
      );
}

${generateIconDataExtensions()}
''';
}

void main(List<String> arguments) {
  final resultFile = File(dbIconDataFilePath);
  resultFile.writeAsStringSync(generateDbIconData());
}
