#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -X POST -d "course=cse775\&year=spring2019\*" "http://${ADDR}:${PORT}/index.html""
echo ""
curl -X POST -d "course=cse775&semester=spring2019*" http://${ADDR}:${PORT}/index.html -i
exit 0
