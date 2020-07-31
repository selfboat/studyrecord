### learn sites 记录

> @xiaolaige

#### 1.C++后台知识学习记录

- http://www.linya.pub/ 汇总的知识列表
- https://github.com/linyacool/WebServer
- https://blog.csdn.net/linyacool/article/details/84560901 题主
- 状态 未完成

#### 2. 进程通信

- https://www.cnblogs.com/52php/tag/%E8%BF%9B%E7%A8%8B%E9%80%9A%E4%BF%A1/

- https://www.cnblogs.com/kuliuheng/p/4064505.html

  - 在一个多线程环境下对某个变量进行简单数学运算或者逻辑运算，那么就应该使用原子锁操作。因为，使用临界区、互斥量等线程互斥方式将涉及到很多操作系统调用和函数调用等，效率肯定不如原子操作高.
  - 原子锁方法适用于短时间操作线程的互斥场合，并不能替代所有系统互斥锁调用场合

- 消息队列通信方式为什么在内核和用户空间进行四次的数据拷贝

  - https://blog.csdn.net/qq_34888036/article/details/81049498

  - 消息队列和管道基本上都是4次拷贝，而共享内存（mmap, shmget）只有两次。

    4次：1，由用户空间的buf中将数据拷贝到内核中。2，内核将数据拷贝到内存中。3，内存到内核。4，内核到用户空间的buf.

    2次： 1，用户空间到内存。 2，内存到用户空间。

    消息队列和管道都是内核对象，所执行的操作也都是系统调用，而这些数据最终是要存储在内存中执行的。因此不可避免的要经过4次数据的拷贝。但是共享内存不同，当执行mmap或者shmget时，会在内存中开辟空间，然后再将这块空间映射到用户进程的虚拟地址空间中，即返回值为一个指向一个内存地址的指针。当用户使用这个指针时，例如赋值操作，会引起一个从虚拟地址到物理地址的转化，会将数据直接写入对应的物理内存中，省去了拷贝到内核中的过程。当读取数据时，也是类似的过程，因此总共有两次数据拷贝

- 共享内存比管道和消息队列效率高的原因

  共享内存区是最快的可用IPC形式，一旦这样的内存区映射到共享它的进程的地址空间，这些进程间数据的传递就不再通过执行任何进入内核的系统调用来传递彼此的数据，节省了时间。
      共享内存和消息队列，FIFO，管道传递消息的区别：
      后者，消息队列，FIFO，管道的消息传递方式一般为
      1：服务器得到输入
      2：通过管道，消息队列写入数据，通常需要从进程拷贝到内核。
      3：客户从内核拷贝到进程
      4：然后再从进程中拷贝到输出文件
      上述过程通常要经过4次拷贝，才能完成文件的传递。
      而共享内存只需要
      1:从输入文件到共享内存区
      2:从共享内存区输出到文件
      上述过程不涉及到内核的拷贝，所以花的时间较少。

- 多进程与多线程的优劣 与 共享内存的同步问题

- 信号量是一个特殊的变量，程序对其访问都是`原子操作`，且只允许对它进行等待（即P(信号变量))和发送（即V(信号变量))信息操作



#### 3. linux线程互斥量pthread_mutex_t使用简介

- https://blog.csdn.net/guotianqing/article/details/80559865

- 问题:

  在一个多线程程序中，两个及以上个线程对同一个变量i执行i++操作，结果得到的值并不如顺序执行所预期的那样。这就是线程间不同步的一个例子。可以用程序修改变量值时所经历的三个步骤解释这个现象：

  从内存单元读入寄存器
  在寄存器中对变量操作（加/减1）
  把新值写回到内存单元

- 线程锁

  - 互斥变量使用特定的数据类型：pthread_mutex_t，使用互斥量前要先初始化，使用的函数如下:

    ```
    #include <pthread.h>
    //线程锁
    int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr);
    int pthread_mutex_destroy(pthread_mutex_t *mutex);
    //加锁操作
    int pthread_mutex_lock(pthread_mutex_t *mutex);
    int pthread_mutex_trylock(pthread_mutex_t *mutex);
    int pthread_mutex_unlock(pthreadd_mutex_t *mutex);
    //避免死锁操作
    int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex, const struct timesec *restrict tsptr);
    ```

- 读写锁

  - 读写锁非常适合于对数据结构读的次数远远大于写的情况。

- 条件变量,自旋锁

  - 条件变量与互斥量一直使用时，允许线程以无竞争的方式等待特定的条件发生。条件变量是线程可用的另一种同步机制
  - 自旋锁用在非抢占式内核中时是非常有用的
  - 在用户层，自旋锁并不非常有用。很多互斥量的实现非常高效，甚至与采用自旋锁是同行效率的。