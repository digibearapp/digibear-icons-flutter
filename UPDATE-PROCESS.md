# Update process

- Bump version number in package.json and in `pubspec.yaml`
- Update all dependencies to latest version
- Run `flutter pub get` in the command line
- Run `cd bin` in the command line
- Run `./update.sh` in the command line
- Run `cd ..` in the command line
- Test the example `hit run on example/lib/main.dart`
- Publish to pub.dev
- Run `git add .`
- Run `git commit -m "v1.0.0"`
- Run `git push`

# Note

> If needed change the file permissions of the shell script with
> `chmod +x update.sh`

# Adding a new Style ?

1. Add the new style to package:digibear_icons_flutter/src/digibear_icon_styles
2. Run the update process above
