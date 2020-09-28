#include <stdio.h> 

void main()

{

void print(void);//调用print方法。

}

void print(void)

{

int a[8][8];//定义一个数组，用来存放乘法运算的结果。

int i,j,t,x,y,m;

for (i=0;i<=8;i++)//双重for语句，给数组赋值。

{

t=i+1;//此处主要是为了使程序的时间复杂度更低， 二维数组实现C语言打印乘法口诀源代码_文档下载https://doc.xuehai.net/bfdb7d7a3ee88f30eada5ae9a.html 减少了一些重复的运算，但是对于这种小的运算量，程序运行速度差别并不明显。这里只是一个小小的思路提示吧，呵呵。 for (j=0;j<=8;j++)

{

a[i][j]=t*(j+1);

}

}

for (x=0;x<=8;x++)//以数组的列为标准打印出所有的元素。

{



for (m=0;m<x+1;m++)
{

printf("%d*%d=%d\t",m+1,x+1,a[m][x]);

}

printf("\n");//换行符。

}

}
