library digibear_icons_flutter;

// Code generated by Téodor Todorov (Creator of Digibear).
// DO NOT EDIT.
// Copyright 2021 Digibear.
// All rights reserved.

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

/// Extension of the [IconData] class for a [DbIcon] with the line style
class DbLineIconData extends DbIconData {
  const DbLineIconData(int codePoint)
      : super(
          codePoint,
          isMulticolor: false,
          fontFamily: 'DigibearIconLine',
        );
}

/// Extension of the [IconData] class for a [DbIcon] with the fill style
class DbFillIconData extends DbIconData {
  const DbFillIconData(int codePoint)
      : super(
          codePoint,
          isMulticolor: false,
          fontFamily: 'DigibearIconFill',
        );
}

/// Extension of the [IconData] class for a [DbIcon] with the duotone style
class DbDuotoneIconData extends DbIconData {
  final List<IconData>? secondary;

  const DbDuotoneIconData(int codePoint, {this.secondary})
      : super(
          codePoint,
          isMulticolor: true,
          fontFamily: 'DigibearIconDuotone',
        );
}
