library digibear_icons_flutter;

enum DbIconStyle { line, fill, duotone }

extension DbIconStylesX on DbIconStyle {
  String get name => toString().split('.').last;
  String get cappedName => capitalize(name);

  // Maximum of 2 colors with the current implementation
  List<String> get colorNames {
    switch (this) {
      case DbIconStyle.line:
        return ["color"];
      case DbIconStyle.fill:
        return ["color"];
      case DbIconStyle.duotone:
        return ["color", "secondary"];
    }
  }

  bool get isMulticolor => colorNames.length > 1;

  String capitalize(String word) =>
      "${word[0].toUpperCase()}${word.substring(1)}";
}
