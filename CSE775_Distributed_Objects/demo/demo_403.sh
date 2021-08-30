#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Illegal methods
echo "curl -X \"FORBIDDEN\" "http://${ADDR}:${PORT}/forbidden.html""
echo ""
curl -X FORBIDDEN http://${ADDR}:${PORT}/forbidden.html -i
exit 0
