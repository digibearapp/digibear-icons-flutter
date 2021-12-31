mydir="$(dirname "$BASH_SOURCE")"
search='width="24" height="24" '
replace=''

for folder in $mydir/*/
do
    folder=${folder%*/}
    mkdir $folder/clean
    for file in $folder/*.svg
    do
        echo $file
        filename=$(basename "$file")
        filename="${filename%.*}-$(basename "$folder")"
        sed -i '' -e "s/<g .*>/<g>/" "$file"
        sed -i '' "s/$search/$replace/" "$file"
        sed -i '' -e '/<defs>/,/<\/defs>/d' "$file"
        picosvg "$file"  >> "$folder/clean/$filename.svg";
    done
done
exit 0;

# sed -i '' -e '/fill/,/<\/defs>/d' "arrowFatLineDownLeft.svg"
# picosvg "arrowFatLineDownLeft.svg"  >> "clean/arrowFatLineDownLeft.svg";

