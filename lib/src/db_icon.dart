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

    Widget buildDuotoneIcon(DbDuotoneIconData icon) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (null != icon.secondary) ..._buildSecondaryIcons(icon.secondary!),
          Icon(icon, color: color, size: size),
        ],
      );
    }

    switch (icon.runtimeType) {
      case DbDuotoneIconData:
        return buildDuotoneIcon(icon as DbDuotoneIconData);

      default:
        return primaryIcon;
    }
  }
}
