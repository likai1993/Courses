#! /bin/bash

ps -ef |grep 'tinyhttpserver' |awk '{print $2}' |xargs sudo kill -9
