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

    Widget buildDuotoneIcon(DbDuotoneIconData icon) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(icon, color: color, size: size),
          if (null != icon.secondary) ..._buildSecondaryIcons(icon.secondary!),
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
