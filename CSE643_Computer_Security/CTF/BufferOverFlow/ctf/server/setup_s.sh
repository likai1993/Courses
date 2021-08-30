!#/bin/bash
gcc -D BUF_SIZE=500 ctf_server.c -o ctf_server -z execstack -fno-stack-protector
./ctf_server 9090 3 5000 0.5 300 0.5
