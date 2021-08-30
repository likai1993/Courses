#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -I "http://${ADDR}:${PORT}/index.html""
echo ""
curl  -I "http://${ADDR}:${PORT}/index.html"
exit 0
