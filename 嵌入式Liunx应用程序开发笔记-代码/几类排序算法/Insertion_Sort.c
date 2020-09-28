#include <stdio.h>
void insertion_sort(int arr[], int len){
        int i,j,key;
        for (i=1;i<len;i++){
                key = arr[i];
                // j=i-1;
                // while((j>=0) && (arr[j]>key)) {
                //         arr[j+1] = arr[j];
                //         j--;
                // }
                // arr[j+1] = key;
                for(j=i-1;(j>=0) && (arr[j]>key);j--){
                    arr[j+1] = arr[j];
                }
                arr[j+1] = key;
        }
}
int main()
{
    int arr[] = {22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70};
    // 所有数据的字节数除以一个数据的字节数即为数据的个数
    int len = (int)sizeof(arr) / sizeof(*arr);
    printf("intsizeofarr=%d \n",(int)sizeof(arr));
    printf("sizeof(*arr)=%d \n",sizeof(*arr));
    printf("len=%d \n", len);
    insertion_sort(arr, len);
    int i;
    for (i = 0; i < len; i++)
        printf("%d \n", arr[i]);
    return 0;
}
