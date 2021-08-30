#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl -i "http://${ADDR}:${PORT}/index.html""
echo ""
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
curl  -i "http://${ADDR}:${PORT}/index.html" &
exit 0
