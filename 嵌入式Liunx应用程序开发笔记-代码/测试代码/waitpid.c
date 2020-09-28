/* waitpid.c */
/* 父进程收集子进程退出信息 */

#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main() 
{
	pid_t retfork;	  
	pid_t retwait;	  

	retfork = fork();
	if (retfork < 0)  
	{
		printf("Error: fork \n");
		exit(1);
	}

  if (retfork == 0)    
	{ 
		sleep(5);
		exit(0);
	}
	else    
	{		
		do
		{
			retwait = waitpid(retfork, NULL, WNOHANG);
  		if (retwait == 0)
			{
				printf("The child process has not exited \n");  
				sleep(1);
			}
		} while (retwait == 0);		
		if (retwait == retfork)
		{
			printf("Get child exit code: %d \n",retwait);
		}
		else
		{
			printf("Error: retwait != retfork \n");
			exit(1);
		}
	}
	return 0;
}
