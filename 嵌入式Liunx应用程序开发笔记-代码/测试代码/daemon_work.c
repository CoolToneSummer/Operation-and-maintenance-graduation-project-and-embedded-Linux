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
#include <time.h>

int main(int argc, char *argv[])
{
    pid_t retfork;
    int i, fd;
    char *buf = argv[2];

    retfork = fork();
    if (retfork < 0)
    {
        printf("Error fork\n");
        exit(1);
    }
    else if (retfork > 0)
    {
        exit(0);
    }
    setsid();
    chdir("/");
    umask(0);
    for (i = 0; i < getdtablesize(); i++)
        close(i);
    while (1)
    {
        time_t *timep = malloc(sizeof(*timep));
        time(timep);
        char *s = ctime(timep);
        if ((fd = open(argv[1], O_CREAT | O_WRONLY | O_APPEND, 0644)) < 0)
        {
            printf("ERROR: Open log file \n");
            exit(1);
        }
        write(fd, s, strlen(s) + 1);
        write(fd, buf, strlen(buf) + 1);

        close(fd);
        sleep(8);
    }
    exit(0);
}
