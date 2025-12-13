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


if [[ "" == "$DB_USER" ]]
then
    echo "You must provide a DB_USER env."
    exit 2
fi

if [[ "" == "$DB_API_KEY" ]]
then
    echo "You must provide a DB_API_KEY env."
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

echo "Checking Danbooru login..."

curl -u "$DB_USER:$DB_API_KEY" -X GET "https://danbooru.donmai.us/profile.json"

LIMIT=100
OFFSET=0

tag_next_batch() {
    echo "Getting with limit $LIMIT and offset $OFFSET"
    RESP=$(curl -s -X GET -H "Authorization: Token $ENCTOKEN" -H "Accept: application/json" "$SZURU_HOST/api/tags/?limit=$LIMIT&offset=$OFFSET&fields=names" )
    echo $RESP
    TOTAL=$(echo $RESP | jq -r ".total")
    echo "The total was $TOTAL"

    if [[ $TOTAL -eq 0 ]]
    then
         return
    fi

    echo  $RESP | jq -r ".results[]|[.names[0]] | @tsv" |
        while IFS=$'\t' read -r tag; do
            echo "Tag $tag"
            echo "Checking Danbooru..."
            CACHE_KEY=$(echo "$tag" | base64)
            CACHE_FILE=".jsoncache/$CACHE_KEY.json"
            if [[ ! -f $CACHE_FILE ]]
            then
                echo "debug: Danbooru Cache Miss"
                echo "Hitting Danbooru..."
                curl --get -u "$DB_USER:$DB_API_KEY" --data-urlencode "search[name_or_alias_matches]=$tag" -s "https://danbooru.donmai.us/tags.json"> $CACHE_FILE 2>/dev/null
                echo "Here it is"
                cat $CACHE_FILE
                echo "Cached"
                if [[ ! -f ".jsoncache/$CACHE_KEY.json" ]]
                then
                    echo "Nothing to save, saving empty to cache to avoid hitting server."
                    echo "[]" > $CACHE_FILE
                    echo "Nothing from DB"
                fi
            else
                echo "debug: Danbooru Cache Hit"
            fi
            CACHE=$(cat $CACHE_FILE)
            echo "Cache was $CACHE"
            if [[ "" == "$CACHE" ]]
            then
                rm $CACHE_FILE
            fi

            TAG_ID=$(echo "$CACHE" | jq -r ".[0].id")
            echo "Tag ID was $TAG_ID"
        done
        if [[ $OFFSET -lt $TOTAL ]]
        then
            ((OFFSET += $LIMIT))
            # tag_next_batch
        fi
}

tag_next_batch