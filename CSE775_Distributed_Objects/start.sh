#! /bin/bash
IP='128.230.215.190'
BACKEND='128.230.215.187:8080'
PORT='8080'
ROOT=/s3/tinyhttpbucket

if [[ $1 -eq 1 ]]
then
	sudo ./tinyhttpserver  -a $IP -r $BACKEND -p $PORT -w $ROOT 2>&1 	
else
	sudo ./tinyhttpserver  -a $IP -p $PORT -vv -w $ROOT 2>&1
fi
exit 0
