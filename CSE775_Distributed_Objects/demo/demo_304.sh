#!/bin/bash
ADDR='128.230.215.190'
PORT='8080'

#Get 200 
echo "curl --header "If-Modified-Since: Mon Apr  10 12:21:43 2020" -i "http://${ADDR}:${PORT}/index.html""
echo ""
curl --header "If-Modified-Since: Mon Apr  10 12:21:43 2020" -i "http://${ADDR}:${PORT}/index.html"


#Get 304
echo ""
echo ""
echo ""
echo ""
echo ""
echo "curl --header "If-Modified-Since: Mon Apr  10 12:21:43 2018" -i "http://${ADDR}:${PORT}/index.html""
echo ""
curl --header "If-Modified-Since: Mon Apr  10 12:21:43 2018" -i "http://${ADDR}:${PORT}/index.html"
