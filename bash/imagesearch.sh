#!/usr/bin/env nix-shell
#! nix-shell -p jq -i bash
mkdir -p .jsoncache
shopt -s globstar
for FILE in **/*.jpg **/*.gif **/*.png # **/*.webp
do
    if [[ $FILE == "tags/"* ]]
    then
        echo "Wait, we already made that."
        continue
    fi
    FILENAME=$(basename "$FILE")
    echo "$FILE"
    echo "$FILENAME"
    MD5=$(md5sum "$FILE" | awk '{print $1}')
    URL="https://danbooru.donmai.us/posts?tags=md5%3A$MD5&format=json"
    echo "$URL"
    if [[ ! -f ".jsoncache/$MD5.json" ]]
    then
        echo Cache Miss
        wget -q -r "$URL" -O .jsoncache/"$MD5".json 2>/dev/null
        if [[ ! -f ".jsoncache/$MD5.json" ]]
        then
            echo Nothing to save, saving empty to cache to avoid hitting server.
            echo "[]" > ".jsoncache/$MD5.json"
        fi
    else
        echo Cache Hit
    fi
    CACHE=$(cat .jsoncache/"$MD5".json)
    TAGS=$(echo "$CACHE" | jq -r ".[0].tag_string")
    for TAG in $TAGS
    do
        echo "$TAG"
        mkdir -pv "tags/$TAG"
        rm -fv "$PWD/tags/$TAG/$FILENAME"
        ln -sv "$PWD/$FILE" "$PWD/tags/$TAG/$FILENAME"
    done
done
