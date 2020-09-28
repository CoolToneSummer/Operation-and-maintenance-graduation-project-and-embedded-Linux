#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>
#include <errno.h>
#include <semaphore.h>
#include <sys/ipc.h>
#define MYFIFO "myfifo"
#define BUFFER_SIZE 3 //
#define UNIT_SIZE 5
#define RUN_TIME 20
#define DELAY_TIME_LEVELS 5.0 //任务间最大时间间隔
void *producer(void *arg);
void *customer(void *arg);
int fd;
time_t end_time;
sem_t mutex, full, avail;
int mutex_now, avail_now, full_now;
/* 生产者线程函数 */
void *producer(void *arg)
{
    int real_write; //写长度
    int delay_time = 0;
    while (time(NULL) < end_time)
    {
        //注意 （/2.0），意为生产时间间隔是消费的一半
        //0-1之间的值
        delay_time = (int)(rand() * DELAY_TIME_LEVELS / (RAND_MAX) / 2.0) + 1;
        printf("\nProducer: delay = %d\n", delay_time); //生产者延时
        sleep(delay_time);
        /*
            mutex 生产者和消费者之间的互斥初始值为1
            avail 有界缓存区的空单元数初始值为N
            full 有界缓冲区的已用单元数初始值为0
        */
        sem_wait(&avail); //有效 P操作-1 阻塞型
        sem_wait(&mutex); //互斥量
        sem_getvalue(&mutex, &mutex_now); //获取当前信号量的值
        sem_getvalue(&avail, &avail_now);
        sem_getvalue(&full, &full_now);
        printf("Producer: mutex:%d, avail:%d, full:%d\n",mutex_now,avail_now,full_now);
        if ((real_write = write(fd, "hello", UNIT_SIZE)) == -1)
        {
            if (errno == EAGAIN)
                printf("The FIFO has not been read yet.Please try later\n");
            else
                printf("Write error\n");
        }
        else
        {
            printf("Write %d to the FIFO\n", real_write);
        } 
        sem_post(&full); //V操作+1
        sem_post(&mutex);
    }
    pthread_exit(NULL);
}
/* 消费者线程函数 */
void *customer(void *arg)
{
    unsigned char read_buffer[UNIT_SIZE];
    int real_read; //读长度
    int delay_time; //延迟时间
    while (time(NULL) < end_time)
    {
        delay_time = (int)(rand() * DELAY_TIME_LEVELS / (RAND_MAX)) + 1;
        printf("\nCustomer: delay = %d\n", delay_time);
        sleep(delay_time);
        sem_wait(&full);
        sem_wait(&mutex);
        sem_getvalue(&mutex, &mutex_now);
        sem_getvalue(&avail, &avail_now);
        sem_getvalue(&full, &full_now);
        printf("Customer: mutex:%d, avail:%d, full:%d\n", mutex_now, avail_now, full_now);
        //对一段连续的空间初始化read_buffer 初始化的存储空间 0 初始化的内容 UNIT_SIZE 空间长度
        memset(read_buffer, 0, UNIT_SIZE);
        //读取管道的读文件描述符fd内容 放入read_buffer中 读最大存储空间UNIT_SIZE >0 读到了
        if ((real_read = read(fd, read_buffer, UNIT_SIZE)) == -1) 
        {
            if (errno == EAGAIN)
                printf("No data yet\n");
            else
                printf("Read error\n");
        }
        else
            printf("Read %s from FIFO\n", read_buffer);
        sem_post(&avail);
        sem_post(&mutex);
    }
    pthread_exit(NULL);
}
int main()
{
    pthread_t thrd_prd_id, thrd_cst_id; //线程标识符
    int ret;
    srand(time(NULL));
    end_time = time(NULL) + RUN_TIME;
    if ((mkfifo(MYFIFO, 0660 | O_CREAT | O_EXCL) < 0) && (errno != EEXIST)) //小于0 存在性判断
    {
        printf("Cannot create fifo\n");
        return errno;
    }
    fd = open(MYFIFO, O_RDWR); //读写阻塞形
    if (fd == -1)
    {
        printf("Open fifo error\n");
        return fd;
    }
    ret = sem_init(&mutex, 0, 1); //创建信号量 0 线程私有信号量 1信号量初始值为1
    ret += sem_init(&avail, 0, BUFFER_SIZE);
    ret += sem_init(&full, 0, 0);
    if (ret != 0)
    {
        printf("Any semaphore initialization failed\n");
        return ret;
    }
    //创建线程&thrd_prd_id线程标识符 NULL 线程函数 线程函数参数
    ret = pthread_create(&thrd_prd_id, NULL, producer, NULL);
    if (ret != 0)
    {
        printf("Create producer thread error\n");
        return ret;
    }
    ret = pthread_create(&thrd_cst_id, NULL, customer, NULL);
    if (ret != 0)
    {
        printf("Create customer thread error\n");
        return ret;
    }
    //对线程挂起/阻塞
    pthread_join(thrd_prd_id, NULL);
    pthread_join(thrd_cst_id, NULL);
    close(fd);
    unlink(MYFIFO); //删除管道文件
    return 0;
}