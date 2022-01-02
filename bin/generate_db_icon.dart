import 'dart:io';

import 'package:digibear_icons_flutter/src/db_icon_styles.dart';

import 'paths.dart';

List<DbIconStyle> get multicolorIconStyles =>
    DbIconStyle.values.where((iconStyle) => iconStyle.isMulticolor).toList();

String generateDbIconDataSwitchCases() {
  final sb = StringBuffer();

  for (final iconStyle in multicolorIconStyles) {
    final cappedIconStyleName = iconStyle.cappedName;
    final switchCase = '''
      case Db${cappedIconStyleName}IconData:
        return build${cappedIconStyleName}Icon(icon as Db${cappedIconStyleName}IconData);
    ''';
    sb.writeln(switchCase);
  }

  return sb.toString();
}

String generateDbIconBuildMethods() {
  final sb = StringBuffer();

  for (final iconStyle in multicolorIconStyles) {
    final cappedIconStyleName = iconStyle.cappedName;
    final switchCase = '''
    Widget build${cappedIconStyleName}Icon(Db${cappedIconStyleName}IconData icon) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (null != icon.secondary) ..._buildSecondaryIcons(icon.secondary!),
          Icon(icon, color: color, size: size),
        ],
      );
    }
    ''';
    sb.writeln(switchCase);
  }

  return sb.toString();
}

String generateDbIcon() {
  return '''
library digibear_icons_flutter;
import 'package:digibear_icons_flutter/src/db_icon_data.dart';
import 'package:flutter/material.dart';

class DbIcon extends StatelessWidget {
  final DbIconData icon;
  final double? size;
  final Color? color;
  final Color? secondaryColor;

  const DbIcon(
    this.icon, {
    Key? key,
    this.size,
    this.color,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = theme.iconTheme;
    final color = this.color ?? iconTheme.color ?? Colors.black;

    final primaryIcon = Icon(icon, color: color, size: size);
    if (!icon.isMulticolor) return primaryIcon;

    final secondaryColor = this.secondaryColor ?? color.withOpacity(.2);

    List<Icon> _buildSecondaryIcons(List<IconData> icons) {
      final builtIcons = <Icon>[];
      for (final icon in icons) {
        final builtIcon = Icon(icon, color: secondaryColor, size: size);
        builtIcons.add(builtIcon);
      }

      return builtIcons;
    }

    ${generateDbIconBuildMethods()}

    switch (icon.runtimeType) {
      ${generateDbIconDataSwitchCases()}
      default:
        return primaryIcon;
    }
  }
}
''';
}

void main(List<String> arguments) {
  final resultFile = File(dbIconFilePath);
  resultFile.writeAsStringSync(generateDbIcon());
}
