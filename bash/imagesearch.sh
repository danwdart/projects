#!/usr/bin/env nix-shell
#! nix-shell -p jq -i bash
for FILE in *.png *.jpg *.gif
do
    echo $FILE
    MD5=$(md5sum "$FILE" | awk '{print $1}')
    echo "https://danbooru.donmai.us/posts?tags=md5%3A$MD5&format=json"
    TAGS=$(wget -O- "https://danbooru.donmai.us/posts?tags=md5%3A$MD5&format=json" 2>/dev/null | jq -r ".[0].tag_string")
    for TAG in $TAGS
    do
        echo $TAG
        mkdir -p tags/$TAG
        ln -sv $PWD/$FILE $PWD/tags/$TAG/
    done
done
