import 'dart:io';

import 'package:digibear_icons_flutter/digibear_icons_flutter.dart';

import 'paths.dart';

// switch (icon.runtimeType) {
//       case DbDuotoneIconData:
//         return buildDuotoneIcon(primaryIcon, icon as DbDuotoneIconData);
//       default:
//         return primaryIcon;
//     }

String generateDbIconDataSwitchCases() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final cappedIconStyleName = iconStyle.cappedName;
    final switchCase = '''
      case Db${cappedIconStyleName}IconData:
        return build${cappedIconStyleName}Icon(icon as Db${cappedIconStyleName}IconData);
    ''';
    sb.writeln(switchCase);
  }

  return sb.toString();
}

// Widget buildDuotoneIcon(DbDuotoneIconData icon) {
//       return Stack(
//         alignment: AlignmentDirectional.center,
//         children: [
//           Icon(icon, color: color, size: size),
//           if (null != icon.secondary) ..._buildSecondaryIcons(icon.secondary!),
//         ],
//       );
//     }

String generateDbIconBuildMethods() {
  final sb = StringBuffer();

  for (final iconStyle in DbIconStyle.values) {
    final cappedIconStyleName = iconStyle.cappedName;
    final switchCase = '''
    Widget build${cappedIconStyleName}Icon(Db${cappedIconStyleName}IconData icon) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(icon, color: color, size: size),
          if (null != icon.secondary) ..._buildSecondaryIcons(icon.secondary!),
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
import 'package:digibear_icons_flutter/digibear_icons_flutter.dart';
import 'package:flutter/material.dart';

class DbIcon extends StatelessWidget {
  final IconData icon;
  final DbIconStyle iconStyle;
  final double? size;
  final Color? color;
  final Color? secondaryColor;

  const DbIcon(
    this.icon, {
    Key? key,
    this.iconStyle = DbIconStyle.line,
    this.size,
    this.color,
    this.secondaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = theme.iconTheme;
    final color = this.color ?? iconTheme.color ?? Colors.black;

    if (!iconStyle.isMulticolor) return Icon(icon, color: color, size: size);

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

/// Digibear Icons generator
void main(List<String> arguments) {
  final resultFile = File(dbIconFilePath);
  resultFile.writeAsStringSync(generateDbIcon());
}
