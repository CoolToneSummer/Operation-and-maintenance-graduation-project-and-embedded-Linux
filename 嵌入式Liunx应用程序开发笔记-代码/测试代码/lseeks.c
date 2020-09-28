/***  lseeks.c  ***/
/**** lseek 读写指针定位测试 ***/

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <error.h>

int main()
{
    int fd;       //文件描述符
    char buf[10]; //读写缓冲区

    //O_CREAT ，如无此文件，创建一个
    //O_TRUNC ，打开文件后清空内容
    //O_APPEND ，文件末尾，以添加方式打开
    if ((fd = open("hello.txt", O_CREAT | O_TRUNC | O_APPEND | O_RDWR, 0644)) == -1)
    //  if ((fd = open("hello.txt",O_CREAT|O_TRUNC|O_RDWR,0644)) == -1)
    {
      //标准错误处理函数
      perror("Error: open hello.txt \n");
      return 0;
    }

    //第一步，写入aaa
    if (write(fd, "aaa", 3) != 3)
      perror("Error: write aaa ");
    printf("1. write aaa ok \n");
    printf("cat: \n");

    //调用系统命令 cat ，查看文件内容
    system("cat hello.txt");
    getchar(); //暂停，观察结果

    //第二步，继续写入bbb
    if (write(fd, "bbb", 3) != 3)
      perror("Error: write bbb \n");
    printf("2. write bbb ok \n");
    printf("cat: \n");

    //调用系统命令 cat ，查看文件内容
    system("cat hello.txt");
    getchar(); //暂停，观察结果

    //第三步，写入ccc，覆盖第二步的bbb
    //lseek，定位至文件起始位置，SEEK_SET，文件头
    //偏移量为3 ，意为覆盖上一步的bbb
    //注意验证此步的实际写入位置
    lseek(fd, 3, SEEK_SET);
    if (write(fd, "ccc", 3) != 3)
      perror("Error: write ccc \n");
    printf("3. write ccc from SEEK_SET+3 ok \n");
    printf("cat: \n");

    //调用系统命令 cat ，查看文件内容
    system("cat hello.txt");
    getchar(); //暂停，观察结果

    //第四步，从起始位置读3个字节，并输出读取的内容
    //lseek，定位至文件起始位置，SEEK_SET，文件头，偏移量为0
    lseek(fd, 0, SEEK_SET);
    if (read(fd, buf, 3) != 3)
      perror("Error: read");
    buf[3] = '\0'; //补充字符串结束符，%s
    printf("4. read from SEEK_SET to buf ok \n");
    printf("buf: %s", buf);
    getchar(); //暂停，观察结果

    //第五步，从起始位置偏移3个字节，读3个字节，并输出读取的内容
    //lseek，定位至起始位置偏移3 个字节，SEEK_SET，文件头，偏移量为3
    lseek(fd, 3, SEEK_SET);
    if (read(fd, buf, 3) != 3)
      perror("read");
    buf[3] = '\0'; //补充字符串结束符，%s
    printf("5. read from SEEK_SET+3 to buf ok \n");
    printf("buf: %s", buf);
    getchar(); //暂停，观察结果

    //第六步，将第五步读取的内容写入文件
    //lseek 不移动，即定位于当前位置，SEEK_SET，文件头，偏移量为3
    if (3 != write(fd, buf, 3))
      perror("Error: write from buf \n");
    printf("6. write from buf ok \n");
    printf("cat: \n");

    //调用系统命令 cat ，查看文件内容
    system("cat hello.txt");
    getchar(); //暂停，观察结果

    close(fd);
    return 0;
}