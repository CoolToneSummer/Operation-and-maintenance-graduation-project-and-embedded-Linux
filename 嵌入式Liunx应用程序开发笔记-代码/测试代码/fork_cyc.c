/* fork_cyc.c */
/* fork 函数父子进程循环测试 */

#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
	int i;
	pid_t ret;  //fork 函数返回值
	
	//i 指循环层次
  //son/pa 指当前进程的子/父进程标志
  //ppid 指当前进程的父进程pid
  //pid 指当前进程的pid
  //retf 指fork函数返回给当前进程的值
  printf("i son/pa ppid pid retf \n");
  
  for(i = 1; i <= 2; i++)		//两次循环
	{
		ret = fork();		//调用fork
		
		if(ret == -1)   //fork调用出错
		{
			printf("ERROR: fork \n");
			return 1;
		}
	  
		if(ret == 0)	    //子进程
			printf("%d child  %4d %4d %4d \n",i,getppid(),getpid(),ret);
		else			        //父进程
			printf("%d parent %4d %4d %4d \n",i,getppid(),getpid(),ret);
	}
	return 0;
}