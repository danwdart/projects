#!/bin/bash
while read into
do
    [ "" == "$into" ] && break
done
echo "200 OK"
echo "Content-Type: text/html"
echo ""
cat public/index.html
