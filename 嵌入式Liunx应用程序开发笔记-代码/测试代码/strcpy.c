//#include <stdio.h>
// 
//double factorial(unsigned int i)
//{
//   if(i <= 1)
//   {
//      return 1;
//   }
//   return i * factorial(i - 1);
//}
//int  main()
//{
//    int i = 15;
//    printf("%d �Ľ׳�Ϊ %f\n", i, factorial(i));
//    return 0;
//}


#include <stdio.h>
 
int main()
{
    int i;
    unsigned long long factorial = 1;

    for(i=1; i<=3; i++)
        factorial *= i;
    printf("%d! = %llu", i-1, factorial);
    return 0;
}
