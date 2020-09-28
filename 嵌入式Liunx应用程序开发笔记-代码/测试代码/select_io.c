/* select_io.c */
/* select 函数实现多路IO复用 */

/* 运行之前，先用命令	“mknode in1 p”，建立管道文件in1 */
/* 再用命令	“mknode in2 p” ，建立管道文件in2 */
/* mknod 命令建立文件节点，p代表文件类型为管道pipe */
/* 运行时，使用三个终端进行测试 */
/* 第一个终端，即进程的运行控制终端，直接在命令行进行输入 */
/* 第二个终端用命令“cat > in1”对管道文件in1 进行输入 */
/* 第三个终端用命令“cat > in2”对管道文件in2 进行输入 */

#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>
#include <poll.h>

#define MAX_BUFFER_SIZE		1024	  //缓冲区大小
#define IN_FILES		3			          //多路复用输入文件数目
#define TIME_DELAY		60			     //超时时间秒数
#define MAX(a, b)		((a > b)?(a):(b))		//求两者中最大值，无数据类型检查

int main(void)
{
	int fds[IN_FILES];   //文件描述符数组
	char buf[MAX_BUFFER_SIZE];
	int i, res, real_read, maxfd;
	struct timeval tv;
	
	//参见select 函数形参说明，即文件描述符集合
	fd_set inset, tmp_inset;	

	//文件描述符0 ，即为标准输入
	fds[0] = 0;	

	//以只读非阻塞方式（O_NONBLOCK)打开pipe 管道文件in1	
	if((fds[1] = open ("in1", O_RDONLY|O_NONBLOCK)) < 0)
	{
		printf("Open in1 error\n");
		return 1;
	}
	printf("FD of in1 fds[1] = %d \n",fds[1]);
	
  //以只读非阻塞方式（O_NONBLOCK)打开pipe 管道文件in2			    
 	if((fds[2] = open ("in2", O_RDONLY|O_NONBLOCK)) < 0)
 	{
 		printf("Open in2 error\n");
		return 1;
	}
	printf("FD of in2 fds[2] = %d \n",fds[2]);

	//取出三个文件描述符中的较大值
	maxfd = MAX(MAX(fds[0],fds[1]),fds[2]);
	printf("MAX FD in set maxfd = %d \n",maxfd);

	//初始化只读集合inset ，并加入三个文件描述符
	//先清空文件描述符集合
	FD_ZERO(&inset);		
  //依次添加文件描述符数组fds[]中的三个文件描述符
  for (i = 0 ; i < IN_FILES; i++)   
    FD_SET(fds[i],&inset);
	
  //循环测试该文件描述符是否准备就绪	
  while(FD_ISSET(fds[0],&inset) || FD_ISSET(fds[1],&inset) || FD_ISSET(fds[2],&inset))
  {
		//备份文件描述符集合，避免多次初始化
		tmp_inset = inset;
		
		tv.tv_sec = TIME_DELAY ;	//设置超时值，秒
	  tv.tv_usec = 0 ;         //微秒

		//调用select 函数，根据返回值对备份文件描述符集合做对应操作
		res = select(maxfd + 1 ,&tmp_inset,NULL,NULL,&tv);
		
		switch(res)   //select 函数返回值判断
		{
			case -1:      //select 函数调用错误
			{
				printf("Select error \n");
				return 1;
			}			
			break;

			case 0:		//Timeout，超时
			{
				printf("Time out \n");
				return 1;
			}			
			break;

			default:    //文件描述符集合循环判断
			{
				for (i = 0; i< IN_FILES; i++)
				{
					b
					//判断对应文件描述符是否位于集合中
					if (FD_ISSET(fds[i],&tmp_inset))    
					{
						//memset函数，将 buf 的MAX_BUFFER_SIZE 长度填充为 0
						memset(buf, 0, MAX_BUFFER_SIZE);
						//读取对应文件描述符 
						real_read = read(fds[i],buf,MAX_BUFFER_SIZE); 

						if (real_read < 0)		//读错误
						{
							if (errno != EAGAIN)
								return 1;
						}
						else if (!real_read)		//读 0 字节
						{
							close(fds[i]);
							//清除对应描述符
							FD_CLR(fds[i],&inset);  
						}
						else			//读成功
						{
							if (i == 0)		//i为文件描述符数组下标，0对应fds[0]的标准输入
							{
								//进程终端退出控制，判断首字符为q 或 Q
								if ((buf[0] == 'q') || (buf[0] == 'Q'))
									return 1;
							}							
							else        //对应fds[1]或fds[2]的in1或in2
							{
								//添加字符串结束符，%s格式输出管道输入字符
								//注意下标的取值为real_read
								buf[real_read] = '\0';  
								printf("%s", buf);
							}
						}			
					}		// end of if
				}			// end of for
			}
			break;
		}		// end of switch
	}			// end of while
	return 0;
}
