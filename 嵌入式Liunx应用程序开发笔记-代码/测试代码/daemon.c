/* daemon.c */
/* 创建守护进程实例 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>       

#define DAEMON_LOG "/home/mich/tmp/daemon.log"

int main()
{
	pid_t retfork;
	int   i, fd;
	char  *buf = "Daemon is OK.\n";	

	retfork = fork(); 
	if (retfork < 0)
	{
		printf("Error fork\n");
		exit(1);
	}
	else if (retfork > 0)   
	{
		//父进程退出，子进程变为孤儿进程			
		//注意：新版Ubuntu 中，孤儿进程可能不由init 进程接管，
		//改由upstart 进程接管
		exit(0); 
	}
	setsid(); 
	chdir("/"); 
	umask(0);
	for(i = 0; i < getdtablesize(); i++) 
		close(i);
  while(1)			
	{
		if ((fd = open(DAEMON_LOG, O_CREAT|O_WRONLY|O_APPEND, 0644)) < 0)
		{			
			printf("ERROR: Open log file \n");
			exit(1);
		}
		write(fd, buf, strlen(buf) + 1);
		close(fd);
		sleep(6);  
	}
	exit(0);
}