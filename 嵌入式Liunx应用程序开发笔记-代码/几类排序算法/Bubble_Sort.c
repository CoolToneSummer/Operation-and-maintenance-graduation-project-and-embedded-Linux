/*
冒泡排序
 
比较相邻的元素。如果第一个比第二个大，就交换他们两个。

对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对。这步做完后，最后的元素会是最大的数。

针对所有的元素重复以上的步骤，除了最后一个。

持续每次对越来越少的元素重复上面的步骤，直到没有任何一对数字需要比较。
*/
#include <stdio.h>
void bubble_sort(int arr[], int len)
{
        int i, j, temp;
        for (i = 0; i < len - 1; i++)
                for (j = 0; j < len - 1 - i; j++)
                        if (arr[j] > arr[j + 1])
                        {
                                temp = arr[j];
                                arr[j] = arr[j + 1];
                                arr[j + 1] = temp;
                        }
}

void bubble_sort_t(int arr[], int len)
{
        int i, j, temp, isSorted;
        for (i = 0; i < len - 1; i++)
        {
                isSorted = 1; //假设剩下的元素已经排序好了
                for (j = 0; j < len - 1 - i; j++)
                {

                        if (arr[j] > arr[j + 1])
                        {
                                temp = arr[j];
                                arr[j] = arr[j + 1];
                                arr[j + 1] = temp;
                                isSorted = 0; //一旦需要交换数组元素，就说明剩下的元素没有排序好
                        }
                        if (!isSorted)
                                break;
                }
        }
}
int main()
{
        int arr[] = {22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70};
        int len = (int)sizeof(arr) / sizeof(*arr);
        bubble_sort_t(arr, len);
        int i;
        for (i = 0; i < len; i++)
                printf("%d ", arr[i]);
        return 0;
}
