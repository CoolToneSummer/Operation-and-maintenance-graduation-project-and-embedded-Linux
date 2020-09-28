/*write.c*/
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#define MAXSIZE

int main(void)
{
    int i, fd, size, len;
    char *buf = "Hello! I'm writing to this file!";
    char buf_r[10];
    len = strlen(buf);
    /*首先调用 open 函数，并指定相应的权限*/
    if ((fd = open("./testfd/hello.c", O_CREAT | O_TRUNC | O_RDWR, 0666)) < 0)
    {
        perror("open:");
        exit(1);
    }
    else
        printf("open file:hello.c %d\n", fd);
    /*调用 write 函数，将 buf 中的内容写入到打开的文件中*/
    if ((size = write(fd, buf, len)) < 0)
    {
        perror("write:");
        exit(1);
    }
    else
        printf("Write:%s\n", buf);
    /*调用 lsseek 函数将文件指针移到文件起始，并读出文件中的 10 个字节*/
    lseek(fd, 0, SEEK_SET);
    if ((size = read(fd, buf_r, 10)) < 0)   
    {
        perror("read:");
        exit(1);
    }
    else
        printf("read form file:%s\n", buf_r);
    if (close(fd) < 0)
    {
        perror("close:");
        exit(1);
    }
    else
        printf("Close hello.c\n");
    exit(0);
}