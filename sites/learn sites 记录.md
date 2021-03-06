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



#### 4. 同步与异步,阻塞和非阻塞 Reactor和Proactor的IO操作设计模式

- 高性能的IO设计, 或者叫事件处理模式设计
  - 同步 
  - 异步
  - 阻塞
  - 非阻塞
  - https://www.cnblogs.com/xujanus/archive/2014/08/27/3940013.html
  - https://blog.csdn.net/a857351839/article/details/101564723 增加actor模式, Actor模型被称为高并发事务的终极解决方案，
  - 代表网络库 mudoo,libevent, libev, libasio.
- Reactor 也叫应答器模式,反应器模式 
  - 用于同步IO, IO读取和写入的操作需要自己实现,注册是读取和写入事件,监听
  - 等待IO事件读写完成
  - 这个模式更像一个侍卫，一直在等待你的召唤，或者叫召唤兽。
  - 并发系统常使用reactor模式，代替常用的多线程的处理方式，节省系统的资源，提高系统的吞吐量。
  - Reactor模型实例：libevent，Redis、ACE
-  Proactor
  - 用于异步IO, IO读取和写入完成事件的注册和处理, 不需要自己去实现读取和写入操作,由操作系统内核完成数据的读写.自己操作内存缓冲区
  - 直接返回读写的结果状态
- https://blog.csdn.net/ZYZMZM_/article/details/98049471
- 主要区别 主动和被动, 事件处理器处理内容,读取和写入操作的完成对象不同
- 优缺点
  - reactor被动事件分离和分发,适合耗时短的任务,事件串行化
  - 而Unix/Linux系统对纯异步的支持有限，应用事件驱动的主流还是通过select/epoll来实现；
  - 适用场景
    Reactor：同时接收多个服务请求，并且依次同步的处理它们的事件驱动程序；
    Proactor：异步接收和同时处理多个服务请求的事件驱动程序；
- 举例子, 餐厅服务员的案例, 一对一,一对二,
  - 多线程并行方案>>线程池方案>>单个线程代替多线程的任务,划分为主线程,工作线程.,+ 事件分发机制
  - 主线程不同模式负责的任务不一样,reactor模式,主线程只负责事件的监听和分发.其他工作线程处理读写数据,接受新的连接,以及处理客户请求



#### 5. Linux 等待进程结束 wait() 和 waitpid()

- 若子进程先于父进程结束时，父进程调用wait()函数和不调用wait()函数会产生两种不同的结果：

  --> 如果父进程没有调用wait()和waitpid()函数，子进程就会进入僵死状态。

  --> 如果父进程调用了wait()和waitpid()函数，就不会使子进程变为僵尸进程

  wait(int* status) 阻塞调用的父进程,直到任一子进程终止,或者无运行的子进程

  waitpid(pid_t pidv,*,...)有对应的选项控制



#### 6. 系统调用和函数调用

- 系统调用主要包括这些:
  - Task	Commands
    进程控制	fork(); exit(); wait();
    进程通信	pipe(); shmget(); mmap();
    文件操作	open(); read(); write();
    设备操作	ioctl(); read(); write();
    信息维护	getpid(); alarm(); sleep();
    安全	chmod(); umask(); chown();

#### 7.  同步与互斥

- 什么是同步,什么是互斥
- 信号量机制下的生产者-消费者问题的实现,线程间的同步和互斥
- 存在两个定义的PV操作或者叫up and down操作. 定义两个信号量, empty 为空缓冲队列的数量,full为满缓冲队列的数量, 使用mutex来实现互斥访问操作, 避免永远等待的死锁
- 角色实现 producer 和 consumer. 



#### 8. 经典的同步问题

- 生产者消费者问题

- 哲学家进餐问题, 

  - 为了防止死锁的发生，可以设置两个条件：

    必须同时拿起左右两根筷子；
    只有在两个邻居都没有进餐的情况下才允许进餐。

  - state[i], check[i], take_two(i),put_two(i), mutex, philosopher(i)

- 读者和写者的问题

  - 允许多个进程同时对数据进行读操作，但是不允许读和写以及写和写操作同时发生。
  - 

#### 9. pipe和FIFO的使用

- 匿名管道与命名管道的区别
  匿名管道由 pipe 函数创建并打开。
  命名管道由 mkfifo 函数创建，打开用 open
- FIFO（命名管道）与pipe（匿名管道）之间唯一的区别在它们创建与打开的方式不同，一但这些工作完成之后，它们具有相同的语义。
  命名管道的打开规则
  如果当前打开操作是为读而打开FIFO时
  O_NONBLOCK disable：阻塞直到有相应进程为写而打开该FIFO
  O_NONBLOCK enable：立刻返回成功
  如果当前打开操作是为写而打开FIFO时
  O_NONBLOCK disable：阻塞直到有相应进程为读而打开该FIFO
  O_NONBLOCK enable：立刻返回失败，错误码为ENXIO.
- 总结: 默认已阻塞的方式open, 而客户端和服务端进程,通过mkfifo()访问创建同一路径的命名管道文件,
  - 读和写操作互相阻塞,等待对方的打开操作成功,然后完成双方进程的通信.
  - https://blog.csdn.net/lvxin15353715790/article/details/89920111   实现client/server的FIFO通信例子
  - read, write



#### 10. 进程通信 消息队列

- https://www.zhihu.com/question/54152397?sort=created  知乎高票答案, 将消息队列写得很详细,使用原因,工程分析
- 库里面的或者操作系统的消息队列都是简单的内存型队列, 对于我们的大型并发低延时系统来说,尚不能满足要求.
  - 如果是单机应用,那么可以使用系统自带的或者手动写的.
  - 如果是分布式应用, 并发量高的,需要考虑多机应用, 需要使用分布式/集群的消息队列部署,避免单台挂掉了 ,导致系统无法正常运转.
  - 数据丢失的问题.  学过Redis的都知道，Redis可以将数据持久化磁盘上，万一Redis挂了，还能从磁盘从将数据恢复过来。同样地，消息队列中的数据也需要存在别的地方，这样才尽可能减少数据的丢失。
  - redis数据持久化,避免宕机数据丢失, 快照或者追加方式. rdb, aof
  - pull 和 push ,消费者获取队列的消息



#### 11. Redis持久化--Redis宕机或者出现意外删库导致数据丢失--解决方案

- https://www.cnblogs.com/xlecho/p/11834011.html



#### 12. 吊打面试官系列-java-敖丙  

- https://github.com/AobingJava/JavaFamily 
- 搜索Ctrl + F
- 