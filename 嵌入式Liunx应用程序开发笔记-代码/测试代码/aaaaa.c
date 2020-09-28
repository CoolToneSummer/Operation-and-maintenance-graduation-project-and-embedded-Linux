#include <stdio.h>
int main(void)
{
    int i, j, z;
    z = 1;
    i = 1;
    printf("请输入一个数字：");
    scanf("%d", &z);
    //printf("%d", z);
    while (i <= z)
    {
        j = 1;
        while (j <= i)
        {
            printf("%ld*%ld=%2d\t", j, i, i * j);
            j++;
        }
        printf("\n");
        i++;
    }
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char* argv[])
{
    int i, j;
    char *p = argv[1];
    i = 1;
    while (i <= strlen(p))
    {
        j = 1;
        while (j <= i)
        {
            printf("%ld*%ld=%2d\t", j, i, i * j);
            j++;
        }
        printf("\n");
        i++;
    }
    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char* argv[])
{
    int i, j;
    char *p = argv[1];
    i = 1;
    while (i <= atoi(p))
    {
        j = 1;
        while (j <= i)
        {
            printf("%ld*%ld=%2d\t", j, i, i * j);
            j++;
        }
        printf("\n");
        i++;
    }
    return 0;
}