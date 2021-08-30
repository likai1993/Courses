#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -X PUT --header "Content-Type: application/json" --data '{"course": "CSE775", "year": Spring 2019}' "http://${ADDR}:${PORT}""
echo ""
curl -X PUT --header "Content-Type: application/json" --data '{"course": "CSE775", "year": Spring 2019}' "http://${ADDR}:${PORT}" -i
exit 0
