#include <stdio.h>
void shell_sort(int arr[], int len) {
        int gap, i, j;
        int temp;
        for (gap = len >> 1; gap > 0; gap >>= 1)
                for (i = gap; i < len; i++) {
                        temp = arr[i];
                        for (j = i - gap; j >= 0 && arr[j] > temp; j -= gap)
                                arr[j + gap] = arr[j];
                        arr[j + gap] = temp;
                }
}

void shell_sort_t(int arr[], int len){
	int i;
	int j;
	int k;
	int gap;	//gap是分组的步长
	int temp;	//希尔排序是在直接插入排序的基础上实现的,所以仍然需要哨兵
	for(gap=len/2; gap>0; gap=gap/2){
		for(i=0; i<gap; i++){
			for(j=i+gap; j<len; j=j+gap){	//单独一次的插入排序
				if(arr[j] < arr[j - gap]){
					temp = arr[j];	//哨兵
					k = j - gap;
					while(k>=0 && arr[k]>temp){
						arr[k + gap] = arr[k];
						k = k - gap;
					}
					arr[k + gap] = temp;
				}
			}
		}
	}
}
int main()
{
    int arr[] = {22, 34, 3, 32, 82, 55, 89, 50, 37, 5, 64, 35, 9, 70};
    // 所有数据的字节数除以一个数据的字节数即为数据的个数
    int len = (int)sizeof(arr) / sizeof(*arr);
    // printf("intsizeofarr=%d \n",(int)sizeof(arr));
    // printf("sizeof(*arr)=%d \n",sizeof(*arr));
    // printf("len=%d \n", len);
    shell_sort_t(arr, len);
    //shell_sort(arr, len);
    int i;
    for (i = 0; i < len; i++)
        printf("%d  ", arr[i]);
    return 0;
}
