/// Format the icon name in camelCase
String formatName(String name) {
  final splitName = name.toLowerCase().split('-').removeLast();

  final formattedNameBuffer = StringBuffer(splitName[0]);
  if (splitName.length == 1) return formattedNameBuffer.toString();
  for (int i = 1; i < splitName.length; i++) {
    final word = splitName[i];
    formattedNameBuffer
        .write(word.replaceFirst(word[0], word[0].toUpperCase()));
  }
  return formattedNameBuffer.toString();
}
