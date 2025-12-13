#!/usr/bin/env nix-shell
#! nix-shell -p jq xmlstarlet -i bash
set -euo pipefail
shopt -s globstar
mkdir -p .jsoncache
trap pwd ERR

if [[ "" == "$SZURU_HOST" ]]
then
    echo "You must provide SZURU_HOST env."
    exit 2
fi

if [[ "" == "$SZURU_USER" ]]
then
    echo "You must provide SZURU_USER env."
    exit 2
fi

if [[ "" == "$SZURU_PASS" ]]
then
    echo "You must provide SZURU_PASS env."
    exit 2
fi

if [[ "" == "$TAG_TAGME" ]]
then
    echo "You must provide a TAG_TAGME env."
    exit 2
fi

if [[ "" == "$TAG_ERROR" ]]
then
    echo "You must provide a TAG_ERROR env."
    exit 2
fi

if [[ "" == "$TAG_TAGGED" ]]
then
    echo "You must provide a TAG_TAGGED env."
    exit 2
fi

echo "Checking szuru login..."

BASIC_AUTH=$(echo -n "$SZURU_USER:$SZURU_PASS" | base64)
TOKEN_URI="$SZURU_HOST/api/user-token/$SZURU_USER"

echo "About to hit $TOKEN_URI to login."

RESP=$(curl -s -X POST -u "$SZURU_USER:$SZURU_PASS" -H "Accept: application/json" -H "Content-Type: application/json" "$TOKEN_URI" 2>/dev/null)
TOKEN=$(echo $RESP | jq -r ".token")
echo "Token is $TOKEN."

ENCTOKEN=$(echo -n "$SZURU_USER:$TOKEN" | base64)

echo "Encoded token is $ENCTOKEN."

LIMIT=100
OFFSET=0

tag_next_batch() {
    echo "Getting with limit $LIMIT and offset $OFFSET"
    RESP=$(curl -s -X GET -H "Authorization: Token $ENCTOKEN" -H "Accept: application/json" "$SZURU_HOST/api/posts/?query=$TAG_TAGME&limit=$LIMIT&offset=$OFFSET&fields=id%2CcontentUrl%2Ctags%2CchecksumMD5%2Cversion" )
    echo $RESP
    TOTAL=$(echo $RESP | jq -r ".total")
    echo "The total was $TOTAL"

    if [[ $TOTAL -eq 0 ]]
    then
        return
    fi

    echo $RESP | jq -r ".results[]|[.id, .checksumMD5, .contentUrl, .version] | @tsv" |
        while IFS=$'\t' read -r id MD5 contentURL version; do
            # echo "Post ID $id"
            echo "Checking IQDB..."
            URL="https://iqdb.org/"
            
            # URL="https://danbooru.donmai.us/posts?tags=md5%3A$MD5&format=json"
            echo "Hitting $URL with QS url=$contentURL..."
            CACHE_FILE=".jsoncache/iqdb-$id.html"
            if [[ ! -f $CACHE_FILE ]]
            then
                echo "debug: IQDB Cache Miss"
                curl -s "$URL" --get --data-urlencode "url=$contentURL" > $CACHE_FILE
                sleep 10 # don't smash them once you've hit them
                if [[ ! -f $CACHE_FILE || ! -s $CACHE_FILE ]]
                then
                    echo "Nothing to save, saving empty to cache to avoid hitting server."
                    echo "<html></html>" > $CACHE_FILE
                    echo "Nothing from IQDB"
                fi
            else
                echo "debug: IQDB Cache Hit"
            fi
            CACHE=$(cat $CACHE_FILE)
            # 
            echo $CACHE_FILE
            echo "It'll be this"
            echo $CACHE | xmlstarlet fo -o -R -H -D /dev/stdin 2>&1 | xmlstarlet sel -T -t -v '//th[text()="Best match"]/../..//td[@class="image"]/a/img/@alt' || echo ""
            echo "that's it"
            FULL_TAGS=$(echo $CACHE | xmlstarlet fo -o -R -H -D /dev/stdin 2>&1 | xmlstarlet sel -T -t -v '//th[text()="Best match"]/../..//td[@class="image"]/a/img/@alt' || echo "")
            echo "Tags: $FULL_TAGS"
            TAGS=$(echo $FULL_TAGS | sed 's/.*Rating: .*Tags: \(.*\)/\1/')
            echo "Tags: $TAGS"
        

            # Only work on confident matches

            # TAGS_GENERAL=$(echo "$CACHE" | jq -r ".[0].tag_string_general")
            # TAGS_CHARACTER=$(echo "$CACHE" | jq -r ".[0].tag_string_character")
            # TAGS_COPYRIGHT=$(echo "$CACHE" | jq -r ".[0].tag_string_copyright")
            # TAGS_ARTIST=$(echo "$CACHE" | jq -r ".[0].tag_string_artist")
            # TAGS_META=$(echo "$CACHE" | jq -r ".[0].tag_string_meta")
            # TAGS=$(echo "$CACHE" | jq -r ".[0].tag_string")
            # DB_SOURCE=$(echo "$CACHE" | jq -r ".[0].source")
            # 
            if [[ "null" == "$TAGS" || "" == "$TAGS" ]]
            then
                BODY=$(echo -n "{\"version\":$version,\"tags\":$(echo -n "$TAG_ERROR" | jq -sRc 'split(" ")'),\"source\":\"\"}")
            else
                echo "Tagging with tags $TAGS"
                BODY=$(echo -n "{\"version\":$version,\"tags\":$(echo -n "$TAGS $TAG_TAGGED" | jq -sRc 'split(" ")'),\"source\":\"\"}")
            fi
# 
            echo "Going to hit "$SZURU_HOST/api/post/$id" with this: "
# 
            RESP=$(curl -X PUT \
                -H "Accept: application/json" \
                -H "Content-Type: application/json" \
                -H "Authorization: Token $ENCTOKEN" \
                -d "$BODY" \
                "$SZURU_HOST/api/post/$id")
            
            echo "Response was this:"
            echo $RESP
# 
            # # Update general tags
            # echo "Updating general tags: $TAGS_GENERAL"
            # for GENERAL in $TAGS_GENERAL
            # do
            #     TAG_DATA_RAW=$(curl -X GET \
            #         -H "Accept: application/json" \
            #         -H "Authorization: Token $ENCTOKEN" \
            #         "$SZURU_HOST/api/tag/$GENERAL")
            #     
            #     TAG_VERSION=$(echo -n $TAG_DATA_RAW | jq -r '.version')
            #     TAG_CATEGORY=$(echo -n $TAG_DATA_RAW | jq -r '.category')
# 
            #     if [[ "$TAG_CATEGORY" == "general" ]]
            #     then
            #         echo "Tag $GENERAL is already a type of general"
            #     else
    # # 
            #         echo "Tag $GENERAL has version $TAG_VERSION; updating it to be a type of general"
    # # 
            #         BODY="{\"category\":\"general\",\"description\":\"\",\"version\":$TAG_VERSION}"
    # # 
            #         curl -X PUT \
            #             -H "Accept: application/json" \
            #             -H "Content-Type: application/json" \
            #             -H "Authorization: Token $ENCTOKEN" \
            #             -d "$BODY" \
            #             "$SZURU_HOST/api/tag/$GENERAL"
            #     fi
# # 
            # done
# 
            # # Update character tags
            # echo "Updating character tags: $TAGS_CHARACTER"
            # for TAG_CHARACTER in $TAGS_CHARACTER
            # do
            #     TAG_DATA_RAW=$(curl -X GET \
            #         -H "Accept: application/json" \
            #         -H "Authorization: Token $ENCTOKEN" \
            #         "$SZURU_HOST/api/tag/$TAG_CHARACTER")
            #     
            #     TAG_VERSION=$(echo -n $TAG_DATA_RAW | jq -r '.version')
            #     TAG_CATEGORY=$(echo -n $TAG_DATA_RAW | jq -r '.category')
# 
            #     if [[ "$TAG_CATEGORY" == "character" ]]
            #     then
            #         echo "Tag $TAG_CHARACTER is already a type of character"
            #     else
    # # 
            #         echo "Tag $TAG_CHARACTER has version $TAG_VERSION; updating it to be a type of character"
    # # 
            #         BODY="{\"category\":\"character\",\"description\":\"\",\"version\":$TAG_VERSION}"
    # # 
            #         curl -X PUT \
            #             -H "Accept: application/json" \
            #             -H "Content-Type: application/json" \
            #             -H "Authorization: Token $ENCTOKEN" \
            #             -d "$BODY" \
            #             "$SZURU_HOST/api/tag/$TAG_CHARACTER"
            #     fi
# # 
            # done
            #     # Artist
            # # Update artist tags
            # echo "Updating artist tags: $TAGS_ARTIST"
            # for TAG_ARTIST in $TAGS_ARTIST
            # do
            #     TAG_DATA_RAW=$(curl -X GET \
            #         -H "Accept: application/json" \
            #         -H "Authorization: Token $ENCTOKEN" \
            #         "$SZURU_HOST/api/tag/$TAG_ARTIST")
            #     
            #     TAG_VERSION=$(echo -n $TAG_DATA_RAW | jq -r '.version')
            #     TAG_CATEGORY=$(echo -n $TAG_DATA_RAW | jq -r '.category')
# 
            #     if [[ "$TAG_CATEGORY" == "artist" ]]
            #     then
            #         echo "Tag $TAG_ARTIST is already a type of artist"
            #     else
# # 
            #         echo "Tag $TAG_ARTIST has version $TAG_VERSION; updating it to be a type of artist"
    # # 
            #         BODY="{\"category\":\"artist\",\"description\":\"\",\"version\":$TAG_VERSION}"
    # # 
            #         curl -X PUT \
            #             -H "Accept: application/json" \
            #             -H "Content-Type: application/json" \
            #             -H "Authorization: Token $ENCTOKEN" \
            #             -d "$BODY" \
            #             "$SZURU_HOST/api/tag/$TAG_ARTIST"
            #     fi
# # 
            # done
# 
            #     # Meta
            # # Update meta tags
            # echo "Updating meta tags: $TAGS_META"
            # for TAG_META in $TAGS_META
            # do
            #     TAG_DATA_RAW=$(curl -X GET \
            #         -H "Accept: application/json" \
            #         -H "Authorization: Token $ENCTOKEN" \
            #         "$SZURU_HOST/api/tag/$TAG_META")
            #     
            #     TAG_VERSION=$(echo -n $TAG_DATA_RAW | jq -r '.version')
            #     TAG_CATEGORY=$(echo -n $TAG_DATA_RAW | jq -r '.category')
# 
            #     if [[ "$TAG_CATEGORY" == "meta" ]]
            #     then
            #         echo "Tag $TAG_META is already a type of meta"
            #     else
# # 
            #         echo "Tag $TAG_META has version $TAG_VERSION; updating it to be a type of meta"
    # # 
            #         BODY="{\"category\":\"meta\",\"description\":\"\",\"version\":$TAG_VERSION}"
    # # 
            #         curl -X PUT \
            #             -H "Accept: application/json" \
            #             -H "Content-Type: application/json" \
            #             -H "Authorization: Token $ENCTOKEN" \
            #             -d "$BODY" \
            #             "$SZURU_HOST/api/tag/$TAG_META"
            #     fi
    # 
            # done
# 
            # echo "Updating copyright tags: $TAGS_COPYRIGHT"
            # # Update copyright tags
            # for TAG_COPYRIGHT in $TAGS_COPYRIGHT
            # do
            #     TAG_DATA_RAW=$(curl -X GET \
            #         -H "Accept: application/json" \
            #         -H "Authorization: Token $ENCTOKEN" \
            #         "$SZURU_HOST/api/tag/$TAG_COPYRIGHT")
            #     
            #     TAG_VERSION=$(echo -n $TAG_DATA_RAW | jq -r '.version')
            #     TAG_CATEGORY=$(echo -n $TAG_DATA_RAW | jq -r '.category')
# 
            #     if [[ "$TAG_CATEGORY" == "copyright" ]]
            #     then
            #         echo "Tag $TAG_COPYRIGHT is already a type of copyright"
            #     else
# # 
            #         echo "Tag $TAG_COPYRIGHT has version $TAG_VERSION; updating it to be a type of copyright"
    # # 
            #         BODY="{\"category\":\"copyright\",\"description\":\"\",\"version\":$TAG_VERSION}"
    # # 
            #         curl -X PUT \
            #             -H "Accept: application/json" \
            #             -H "Content-Type: application/json" \
            #             -H "Authorization: Token $ENCTOKEN" \
            #             -d "$BODY" \
            #             "$SZURU_HOST/api/tag/$TAG_COPYRIGHT"
            #     fi
# # 
            # done

            # echo "Tagged with $TAGS"

            # echo "ID is $id - CS is $checksum - CU is $contentURL"
        done
    # if [[ $OFFSET -lt $TOTAL ]]
    # then
    #     ((OFFSET += $LIMIT))
         tag_next_batch
    # fi
}

tag_next_batch