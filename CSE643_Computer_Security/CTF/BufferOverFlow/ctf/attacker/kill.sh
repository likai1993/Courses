#!/bin/bash
ps -ef |grep "attack.sh" |awk '{print $2}' |xargs kill -9
