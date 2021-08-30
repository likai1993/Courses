#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -i "http://${ADDR}:${PORT}/non_exist.html""
echo ""
curl -i "http://${ADDR}:${PORT}/non_exist.html"
exit 0
