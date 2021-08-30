/* Buffer Overflow CTF Server Program */

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <signal.h>
#include <unistd.h>

#define CLIENT_MSG_SIZE 8192

int level, addr_range, dist_range;
float addr_range_pos, dist_range_pos;
int addr_low, addr_high, dist_low, dist_high;

//function has buffer-overflow vulnerability
void bof(char *str); 

//Initialize the TCP socket
int initTCPServer(int port);

//Handle individual TCP session 
int open_session(int client_sock);

//server listens to TCP connection
int run_server(int socket_desc, int port);

int main(int argc , char *argv[]) {

	int socket_desc ;
	int port=0;

	if(argc!=0){
		port = atoi(argv[1]);
		level = atoi(argv[2]);
			
		addr_range = atoi(argv[3]);
		addr_range_pos = atof(argv[4]);
		dist_range = atoi(argv[5]);
		dist_range_pos = atof(argv[6]);

		addr_low = addr_range_pos * addr_range;
        	addr_high = addr_range - addr_low ;
		dist_low = dist_range_pos * dist_range;
        	dist_high = dist_range - dist_low;

		/*printf("Arguments: port=%d, level=%d, dist=%d, addr_range=%d, addr_range_pos=%f, dist_range=%d, dist_range_pos=%f \n\n", port, level, BUF_SIZE, addr_range, addr_range_pos, dist_range, dist_range_pos);*/
	}
	else 
		return 1;

	socket_desc = initTCPServer(port);
	run_server(socket_desc,port);
	return 0;
}


//Initialize the TCP socket
int initTCPServer(int port){
	int socket_desc;
	struct sockaddr_in server;
	//Create socket
	socket_desc = socket(AF_INET , SOCK_STREAM , 0);
	if (socket_desc == -1) {
		printf("Could not create socket");
	}

	//Prepare the sockaddr_in structure
	server.sin_family = AF_INET;
	server.sin_addr.s_addr = INADDR_ANY;
	server.sin_port = htons(port);
        int tr=1;
	if (setsockopt(socket_desc,SOL_SOCKET,SO_REUSEADDR,&tr,sizeof(int)) == -1) {
    		perror("setsockopt");
    		exit(1);
	}

	//Bind socket to address
	if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
	{
		perror("bind failed. Error");
		return 1; 
	}
	return socket_desc;
}


//Handle individual TCP session 
int open_session(int client_sock){

	char client_message[CLIENT_MSG_SIZE];
	int read_size;
	//Receive a message from client
	while( (read_size = recv(client_sock , client_message , CLIENT_MSG_SIZE , 0)) > 0){
	
		printf("\nMessage received: \%s \n", client_message);
		fflush(stdout);
		
		//vulnerable function 
		bof(client_message);
 
		//Send the message back to client
		write(client_sock , client_message , strlen(client_message));
	}
	if(read_size == -1) {
		perror("recv failed");	
		exit(1);
	}
	return 1;
}

//server listens to TCP connection
int run_server(int socket_desc, int port ){

	int client_sock , c , read_size;
	struct sockaddr_in  client;
	int pid;
	int attempts = 0;

	// handle signal from child processes
	signal(SIGCHLD, SIG_IGN);

	//Listen to connection
	listen(socket_desc , 100);
	fflush(stdout);
	while (1) {
		if(attempts > 0) printf("\n\nNumber of attempts: %d\n",attempts); 
		printf("\n\nWaiting for incoming connection on port %d\n",port);
		puts("======================================================");
		fflush(stdout);
		c = sizeof(struct sockaddr_in);

		//accept connection from an incoming client
		client_sock = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c); 
		if (client_sock < 0) {
			perror("accept failed");
			return 1;
		}
		puts("Connection accepted\n\n");

		if((pid = fork()) < 0){
			perror("fork");	
			exit(1);
		}else if (pid == 0){ //child process handle TCP session
			close(socket_desc);
			open_session(client_sock);
			close(client_sock);
			kill(getpid(), SIGKILL);
		}else{ 
			//parent process continue listen to the connection  
			sleep(0.2);
		}
		attempts++;
		close(client_sock);	
	}
}

//function has buffer-overflow vulnerability
void bof(char *str) {

	char buffer[BUF_SIZE];
	
	if(level == 1) {
                printf("\nBuffer Address: 0x%8X\n", (unsigned int)buffer);
                uintptr_t framep;
                asm("movl %%ebp, %0" : "=r" (framep));
                printf("EBP: 0x%8X\n", framep);
        }
	else if (level == 2) {
		printf("\nBuffer Address: 0x%8X\n", (unsigned int)buffer);
		printf("\nDistance Range: %d to %d\n", BUF_SIZE-dist_low, BUF_SIZE+dist_high);
	}
	else if (level == 3) {
		printf("\nBuffer Address Range: 0x%8X to 0x%8X\n", (unsigned int)buffer-addr_low, (unsigned int)buffer+addr_high);
		printf("\nDistance Range: %d to %d\n", BUF_SIZE-dist_low, BUF_SIZE+dist_high);
	}

	strcpy(buffer, str); 
}
