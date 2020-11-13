#!/bin/bash
echo "Content-Type: application/json"
echo ""
echo "{\
    \"your_information\":true,\
    \"query_string\":\"$QUERY_STRING\",\
    \"user-agent\":\"$HTTP_USER_AGENT\",\
    \"cookie\":\"$HTTP_COOKIE\",\
    \"referrer\":\"$HTTP_REFERER\",\
    \"remote addr\":\"$REMOTE_ADDR\",\
    \"remote host\":\"$REMOTE_HOST\",\
    \"request method\":\"$REQUEST_METHOD\",\
    \"script name\":\"$SCRIPT_NAME\",\
    \"server name\":\"$SERVER_NAME\",\
    \"server port\":\"$SERVER_PORT\",\
    \"server protocol\":\"$SERVER_PROTOCOL\",\
    \"server software\":\"$SERVER_SOFTWARE\",\
    \"uid\":\"$UID\",\
    \"user\":\"$USER\"\
    }"