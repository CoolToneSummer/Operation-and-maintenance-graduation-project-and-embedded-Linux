/* copy_file.c */
/* 将file1 文件的末尾10250 字符，复制到file2 */

#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>

#define	BUFFER_SIZE		  1024		  //每次读写缓存区大小
#define SRC_FILE_NAME 	"copy"	  //待复制文件名 
#define DEST_FILE_NAME	"copy_end"	  //目标文件名
#define COPY_SIZE			  10250		  //需复制内容的字符数

int main()
{
	int fd_src_file, fd_dest_file;    //文件描述符
	unsigned char buff[BUFFER_SIZE];  //读写缓冲区
	int real_read_len;    //实际读长度 -----读函数的返回值
	//每次读写的时候文件都是从文件指针向后移动

	//只读方式打开待复制文件
	fd_src_file = open(SRC_FILE_NAME, O_RDONLY);

	//只写方式打开目标文件，如不存在则创建，并设置权限644
	//注意：考察复制后的目标文件权限
	fd_dest_file = open(DEST_FILE_NAME, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);

	//open 错误判断
	if (fd_src_file < 0 || fd_dest_file < 0)
	{
		printf("Open file error\n");
		exit(1);
	}

	//输出文件描述符
	printf("FD of src file is %d \n",fd_src_file );	
	printf("FD of des file is %d \n",fd_dest_file );	
	
//*----------------
	//待复制文件读写指针定位到文件末尾的前向位置，注意符号为负
	lseek(fd_src_file, -COPY_SIZE, SEEK_END);

	//读待复制文件，每次读 BUFFER_SIZE 字节
	while ((real_read_len = read(fd_src_file, buff, BUFFER_SIZE)) > 0)
	{
		write(fd_dest_file, buff, real_read_len);
	}

	//关闭文件描述符
	close(fd_dest_file);
	close(fd_src_file);

	return 0;
}


//----------------*/	
/*--------------------------------------------	
  //以下代码，实现从文件头部开始复制10250字符
  //注意：COPY_SIZE是常量，不是变量
	int count = COPY_SIZE;   //复制未完成的标志

	//待复制文件读写指针定位到文件头部，偏移量为 0
	lseek(fd_src_file, 0, SEEK_SET);		

	//读待复制文件，每次读BUFFER_SIZE 字节
	while ((real_read_len = read(fd_src_file, buff, BUFFER_SIZE)) > 0)
	{		
		//复制未完成部分计数
		count = count - real_read_len;    
		if(count >= 0)     //判断复制未完成标志
		  write(fd_dest_file, buff, real_read_len);
		else    //最后一次的读缓冲区，内容可能多于实际应写入内容
		  {
		    //仅写入最后一次读操作的未复制部分字节
		    real_read_len = count + BUFFER_SIZE;  
		    write(fd_dest_file, buff, real_read_len);         
		  }
	}
  //关闭文件描述符
  close(fd_dest_file);
  close(fd_src_file);
 
  return 0;
}

//继续思考：
//如果待复制文件内容少于源文件内容，代码是否需要改动？
//如果实现待复制文件内容的整体复制？

--------------------------------------------*/
