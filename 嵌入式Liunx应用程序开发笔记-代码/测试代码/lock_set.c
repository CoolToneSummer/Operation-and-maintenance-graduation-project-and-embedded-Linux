/* lock_set.c */
/* 给特定文件描述符上特定锁 */
/* 完成fcntl函数封装 */

#include <unistd.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>

int lock_set(int fd, int type)
{
	// flock结构体lock 初始化
	struct flock  lock;
	lock.l_whence = SEEK_SET;   //相对位偏移量起始位置，同lseek的whence
	lock.l_start = 0;     //相对位偏移量
	lock.l_len = 0;       //上锁区域长度
	lock.l_type = type;   //锁的类型
	lock.l_pid = -1;      //上锁的进程号pid

	//判断文件是否可以上锁，获取当前读写锁状态
	fcntl(fd, F_GETLK, &lock);
	if (lock.l_type != F_UNLCK)
	{
		//判断不能上锁的原因
		if (lock.l_type == F_RDLCK) 		//已有读锁，输出上锁进程的PID
			printf("Read lock already set by process %d \n", lock.l_pid);//
		else if (lock.l_type == F_WRLCK) 	//已有写锁，输出上锁进程的PID
			printf("Write lock already set by process %d \n", lock.l_pid);
	}

	//重置l_type
	lock.l_type = type;

	//依据不同的type值进行上锁或解锁，阻塞式，F_SETLKW
	//思考：非阻塞式上锁F_SETLK会如何？ 
	if ((fcntl(fd, F_SETLKW, &lock)) < 0)
	{
		printf("Lock failed:type = %d \n", lock.l_type);
		return 1;
	}

	switch(lock.l_type)
	{
		case F_RDLCK: //上读锁，输出上读锁进程的PID（getpid()，返回当前进程PID）
			printf("Read lock set by process %d \n", getpid());
			break;

		case F_WRLCK: //上写锁，输出上写锁进程的PID
			printf("Write lock set by process %d \n", getpid());
			break;

		case F_UNLCK: //释放锁，输出释放锁进程的PID
			printf("Release lock by process %d \n", getpid());			
			break;

		default:
			break;
	}						//结束switch	
	return 0;
}