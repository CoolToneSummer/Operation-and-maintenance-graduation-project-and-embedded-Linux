//#include <stdio.h>
//int main(){
//    int i,j,n;
//    for(i=1;i<=9;i++){
//        // 将下面的for循环注释掉，就输出左下三角形
//        for(n=1; n<=9-i; n++)
//            printf("        ");
//        
//        for(j=1;j<=i;j++)
//            printf("%d*%d=%2d  ",i,j,i*j);
//        
//        printf("\n");
//    }
//    return 0;
//}
//#include <stdio.h>
//int main() {
//    int i,j;
//    for(i=1;i<=9;i++){
//        for(j=1;j<=9;j++){
//            if(j<i)
//                //打印八个空格，去掉空格就是左上三角形 
//                printf("        ");
//            else
//                printf("%d*%d=%2d  ",i,j,i*j);
//        }
//        printf("\n");  
//    }
//    return 0;
//}
#include <stdio.h>
struct stu{
    char *name;  //姓名
    int num;  //学号
    int age;  //年龄
    char group;  //所在小组
    float score;  //成绩
}stus[] = {
    {"Zhou ping", 5, 18, 'C', 145.0},
    {"Zhang ping", 4, 19, 'A', 130.5},
    {"Liu fang", 1, 18, 'A', 148.5},
    {"Cheng ling", 2, 17, 'F', 139.0},
    {"Wang ming", 3, 17, 'B', 144.5}
}, *ps;
int main(){
    //求数组长度
    int len = sizeof(stus) / sizeof(struct stu);
    printf("Name\t\tNum\tAge\tGroup\tScore\t\n");
    for(ps=stus; ps<stus+len; ps++){
        printf("%s\t%d\t%d\t%c\t%.1f\n", ps->name, ps->num, ps->age, ps->group, ps->score);
    }
    return 0;
}
