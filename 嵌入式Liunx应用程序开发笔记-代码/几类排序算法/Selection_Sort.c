#include <stdio.h>
//函数需要对变量进行修改时，必须传入指针，然后利用指针间接访问变量，再对变量进行修改
void swap(int *a, int *b) //交換兩個變數
{
    int temp = *a;
    *a = *b;
    *b = temp;
}
void selection_sort(int arr[], int len)
{
    int i, j;

    for (i = 0; i < len - 1; i++)
    {
        int min = i;
        for (j = i + 1; j < len; j++) //走訪未排序的元素
            if (arr[j] < arr[min])    //找到目前最小值
                min = j;              //紀錄最小值
                                      //swap(&arr[min], &arr[i]);     //做交換
        // int *a = &arr[min];
        // int *b = &arr[i];
        // int temp = *a;
        // *a = *b;
        // *b = temp;
        int temp = arr[i];
        arr[i]= arr[min];
        arr[min]=temp;
    }
}
int main()
{
    int arr[] = {22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70};
    int len = (int)sizeof(arr) / sizeof(*arr);
    selection_sort(arr, len);
    int i;
    for (i = 0; i < len; i++)
        printf("%d ", arr[i]);
    return 0;
}
