#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -X DELETE "http://${ADDR}:${PORT}/delete.html""
echo ""
curl -X DELETE http://${ADDR}:${PORT}/delete.html -i
exit 0
