/* execve.c */
/* execve 进程替换示例 */
/* v，将所有参数整体构造为指针数组传递(vector) */
/* e，指定的环境变量(enviroment) */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
  //环境变量参数列表，必须以NULL结尾
	char *envp[] = {"PATH=/bin",NULL};

	//命令参数列表，必须以NULL结尾	
	char *arg[] = {"ls","-al",NULL};

	if (execve("/bin/ls", arg, envp) < 0)
    printf("Error: execve\n");

/*********************
  //main函数参数检测示例argc_argv_a
  //命令参数列表，必须以NULL结尾	
  char *arg[] = {"argc_argv_a","123",NULL}; 

	if (execve("/home/mich/test/ch03-c/gcc/argc_argv_a", arg, envp) < 0)
    printf("Error: execve\n"); 
********************/ 

  //进程替换结束    
  printf("Exit: execve\n");
  exit(0);
}
