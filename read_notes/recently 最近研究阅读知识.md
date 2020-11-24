### recently: 最近研究阅读知识

> 2020年07月24日

#### 1. 进程通信

- #include <stddef.h>
  #include <sys/shm.h>

- [https://www.cnblogs.com/52php/tag/%E8%BF%9B%E7%A8%8B%E9%80%9A%E4%BF%A1/](https://www.cnblogs.com/52php/tag/进程通信/)
  - 消息队列通信 https://www.cnblogs.com/52php/p/5862114.html
  - 共享内存通信 https://www.cnblogs.com/52php/p/5861372.html
- 

#### 2. 内存泄露

- C++程序在Windows平台上各种定位内存泄漏的方法
  - https://blog.csdn.net/weixin_30437337/article/details/97345683?utm_medium=distribute.pc_relevant.none-task-blog-title-5&spm=1001.2101.3001.4242
  - https://blog.csdn.net/u011553313/article/details/109255781
  - 大对象的引用计数统计分析
  - 初级leakDialog, 中级WinDB, 高级底层内存分析,增长,hookapi,hook 监控分配和回收点.new/delete
  - VLD（Visual Leak Detector），这是一个免费的、开源的、强大的内存泄露检测系统，可以安装当作VS的一个插件。
  - 其他提及到,leakDialog, LDGraph,WinDB