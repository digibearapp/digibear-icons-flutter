#!/bin/bash

echo "Generating update shell file"
rm ./update_icons.sh
dart ./generate_update_icons_sh.dart
chmod +x update_icons.sh
./update_icons.sh