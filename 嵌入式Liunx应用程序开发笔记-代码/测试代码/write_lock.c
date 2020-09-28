/* write_lock.c */
/* 上写锁 */

#include <unistd.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

//lock_set 函数头文件
#include "lock_set.h"

int main(void)
{
	int fd;   //文件描述符

	//打开hello 文件，准备上锁
	fd = open("hello",O_RDWR | O_CREAT, 0644);
	if(fd < 0)    //open 错误判断
	{
		printf("Error: Open file \n");
		exit(1);
	}

	//上写锁 
	lock_set(fd, F_WRLCK);
	getchar();    //暂停，观察

	//释放锁
	lock_set(fd, F_UNLCK);
	getchar();    //暂停，观察

	close(fd);	
	exit(0);
}