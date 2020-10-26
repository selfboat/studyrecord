###  基于QT的mqtt协议开源项目的研究

> @author 小来哥
>
> @date  2020年10月21日

#### 1.  pro 文件

- QT += network,  需要引入网络库, 然后判断是否支持双工通信websockets, 导入 QT += websockets

- 不同平台字符编码设置处理

  ```
  DEFINES += QT_NO_CAST_TO_ASCII QT_NO_CAST_FROM_ASCII
  ```

  宏定义, 禁止编码自动转换,[禁用一切来自双引号字符串字面量传入QString（有2种解决方法）](https://www.cnblogs.com/findumars/p/6297765.html)

  ```
  QT默认的编码（unicode）是不能显示中文的，可能由于windows的默认编码的问题，windows默认使用（GBK/GB2312/GB18030），所以需要来更改QT程序的编码来解决中文显示的问题。系统直接自动将char *的参数转换成为系统默认的编码，然后返回一个QString。
  ```

  这里有官方的文档补充说明 https://www.cnblogs.com/crazy-machine/articles/5894856.html

  意思:禁止代码中直接使用const char*的c风格的字符串常量, 必须使用qt里面的函数进行转换.

  现象:

  https://blog.csdn.net/iteye_6429/article/details/82105113

  不然将会编译时直接报错，比如

  ```
  QString val("dbzhang800");
  val = "dbzhang801";
  ```

- header/sources 头文件整体包含

  使用include(\*\*/\*\*/**.pri), $$Header, $$Source

  ```c++
  include(qmqtt.pri)
  
  HEADERS += $$PUBLIC_HEADERS $$PRIVATE_HEADERS
  ```

  在pri文件里面,根据是否支持websockets模块,来导入对应的header,sources,分开编译mqtt库

#### 2. qmqtt_client.h分析

- 首先选择从直接使用的客户端类开始分析,定义常用的MQTT协议版本信息,连接枚举返回信息, 前置使用类型说明,

  - class Q_MQTT_EXPORT Client : public QObject 继承核心类

  - 元对象属性声明 [Meta-Object System](metaobjects.html).

    ```c++
    Q_PROPERTY(quint16 _port READ port WRITE setPort)
    Q_PROPERTY(QHostAddress _host READ host WRITE setHost)
    ```

    就是内部定义的get和set函数,利用发射方式可以得到这个类的信息.

    根据定义的成员属性,可以看出mqtt_client具有哪些功能: 心跳检测,自动重连,状态保存

  - 属性的设置函数全部定义为槽函数,就可以异步调用

    public slots:
        void setHost(const QHostAddress& host);
        void setHostName(const QString& hostName);

    子类可以实现的槽函数: protected slots:

    void onNetworkConnect(), void onNetworkReceived(),void onTimerPingReq(); 

  - signals信号定义连接操作

    - subscribe, publish, connect,disconnect, error
  
- 核心的数据结构定义

  - 私有成员,禁止拷贝构造,返回内部私有结构成员, 

  - 一个大的的核心私有内成员
  
    ```c++
    protected:
        QScopedPointer<ClientPrivate> d_ptr;
    private:
        Q_DISABLE_COPY(Client)
      Q_DECLARE_PRIVATE(Client)
    ```

    看来,只能new创建对象. 这连个宏也是经常使用的,宏模板生成部分常出现的代码.

    **因为拷贝构造和赋值操作私有的，所以不能用作容器的元素。**

  - QScopedPointer, QPointer, QSharedPointer, 智能指针的相关概念和使用特点区别.
  
    - Qt智能指针--QPointer     https://blog.csdn.net/luoyayun361/article/details/90199081
      - QPointer属于Qt对象模型的特性，本质是一个模板类，它为QObje提供了`guarded pointer`。当其指向的对象(必须是QObject及其派生类)被销毁时，它会被自动置NULL，原理是其对象析构时会执行QObject的析构函数，进而执行`QObjectPrivate::clearGuards(this);`，这也是基于其指向对象都继承自QObject的原因。
      - QPointer对元基类QMetaObject进行了简单封装,放入哈希表进行管理,
      - 特点: 指向的对象如果被销毁, 所有指向这个对象的相关QPointer指针自动会赋值为null. myPointer.isNull().  避免编码的时候产生野指针.
    - Qt智能指针--QScopedPointer
      - https://blog.csdn.net/luoyayun361/article/details/90228638
      - 特点: 它有更严格的所有权，并且不能转让，一旦获取了对象的管理权，你就无法再从它那里取回来。也就是说，`只要出了作用域，指针就会被自动删除`
      - T *QScopedPointer::take()和reset(*other)可以转移对象指针所有权
      - QScopedArrayPointer 指针数组
    - Qt智能指针--QSharedPointer
    - https://luoyayun361.blog.csdn.net/article/details/90255944?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-4.add_param_isCf&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-4.add_param_isCf#QSharedPointer_4
      - 特点 与 C++中的std::shared_ptr其作用是一样的,QSharedPointer可以被自由地拷贝和赋值，在任意的地方共享它，所以QSharedPointer也可以用作容器元素。
  
    - Qt内存管理(三) Qt的智能指针
    - https://blog.csdn.net/yao5hed/article/details/81092152?utm_medium=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param&depth_1-utm_source=distribute.pc_relevant_t0.none-task-blog-BlogCommendFromMachineLearnPai2-1.channel_param
    - QSharedPointer和QWeakPointer都是线程安全的，可以原子地操作指针，不同线程可以获取这两种指针指向的对象而不必加锁。

  - 可重入（reentrant）函数, 它们都是可重入的类. 解释:https://blog.csdn.net/u012033124/article/details/72715319　　　
  
  - reentrant函数或者类,多线程访问时候
    
- 可重入函数可以在任意时刻被中断，稍后再继续运行，不会丢失数据。可重入函数要么使用本地变量，要么在使用全局变量时保护自己的数据。
    
  - 延伸: **函数的可重入性与线程安全之间的关系**
  
    - 可重入的函数不一定是线程安全的；
  - 可重入的函数在多个线程中并发使用时是线程安全的，但不同的可重入函数（共享全局变量及静态变量）在多个线程中并发使用时会有线程安全问题（可能是线程安全的也可能不是线程安全的）；
  
  - 不可重入的函数一定不是线程安全的；
  
  - QClientPriate的设计与实现

    - 根据QT的代码设计标准和数据结构封装规则
  
    - 为复杂的类,再封装一个内部私有类,用于数据管理,方法接口管理. 方便模块重用,修改.
  
      ```
      QHostAddress QMQTT::Client::host() const
      {
          Q_D(const Client);
          return d->host();
      }
    #define Q_D(Class) Class##Private * const d = d_func()
      ```
  
  - 其他实现类的封装设计
  
    - NetworkInterface : public QObject
      
      - 网络协议接口设计类, 定义很多纯虚函数,虚函数是槽函数,
      
    - class Network : public NetworkInterface
      
      - 网络接口实现类
      
    - SocketInterface 底层基于QTcpSocket的 socket通信接口的定义类
    
    - Socket类, 基于QTcpSocket,实现SocketInterface定义的功能接口实现类.
    
      - 可以是普通tcpsocket通信,可以是ssl_socket通信方式实现,可以使websocket的通信实现方式.
    
    - websockets 支持,需要手动安装库
    
      - apt-get install sudo apt-get install libqt5websockets5-dev 
    
    - SslSocket类,基于QTcpSocket, 实现SocketInterface接口的功能.
    
    - 形如:  底层套接字通信接口->Qt封装的QTcpSocket通信->SocketInterface接口实现, 进行分功能实现这个网络层通信定义
    
    - Network可以选择不同的socket来进行不同协议之间的通信方式的实现.
    
    - 新代码表达方式注意:
    
      ```
      QObject::connect( _autoReconnectTimer, &TimerInterface::timeout,
              this, static_cast<void (Network::*)()>(&Network::connectToHost));    
          QObject::connect(_socket,  static_cast<void (SocketInterface::*)(QAbstractSocket::SocketError)>(&SocketInterface::error),    this, &Network::onSocketError);
      ```
    
      强制转换为对应的函数指针类型



#### 3. MQTT协议的理解介绍

- MQTT协议是应用层协议，需要借助TCP/IP协议进行传输，类似HTTP协议。MQTT协议也有自己的格式，如下表

- [ Fixed Header | Variable Header | Payload]       固定头|可变头|消息体

- https://blog.csdn.net/weixin_34166847/article/details/91449485

- 主要是固定头这里是统一的,是必须的.

  - 固定头 Fixed Header为4个字节大小.其中第一个字节最重要, 包含高4bit位:说明消息的类型;低4bit位,说明某个消息的控制内容.
  - 后面是紧跟1-4个字节的消息长度说明,根据字节的最高位为0还是为1,累计计算. 最大消息长度:128^4=256Mb

-  MQTT讲解   https://blog.csdn.net/weixin_34166847/article/details/91449485

- QOS 解释和计算讲解 https://blog.csdn.net/qq997758497/article/details/90574564

  - 【MQTT学习】Lesson7.实践 QoS2 和 QoS 

    - https://blog.csdn.net/qq997758497/article/details/90611424
    - 这个系列讲解了MQTT的协议,客户端,服务端搭建,通信实践的知识.

  - 特别说明:  `QoS 是 Sender 和 Receiver 之间达成的协议，不是 Publisher 和 Subscriber 之间达成的协议。`也就是说 Publisher 发布一条 QoS1 的消息，只能保证 Broker 能至少收到一次这个消息；至于对应的 Subscriber 能否至少收到一次这个消息，还要取决于 Subscriber 在 Subscribe 的时候和 Broker 协商的 QoS 等级。

  - 和我以前在LIsServer项目中,以及PA05的NetManager项目中实现的同步异步通信机制是一样的道理.

  - 消息服务降级原因:  **MQTT 协议中，从 Broker 到 Subscriber 这段消息传递的实际 QoS 等于：Publisher 发布消息时指定的 QoS 等级和 Subscriber 在订阅时与 Broker 协商的 QoS 等级，这两个 QoS 等级中的最小那一个。**

    ```
    Actual Subscribe QoS = MIN(Publish QoS, Subscribe QoS)
    ```

    这也就解释了“publish qos=0, subscribe qos=1”的情况下 Subscriber 的实际 QoS 为 0，以及“publish qos=1, subscribe qos=0”时出现 QoS 降级的原因。

  - 注意使用MQTT的问题坑:

    - qos=1或者2时候,消息如果处理不及时,造成消息存储在本地内存,消息堆积,内存增长或者挂掉.

    - Publish消息,控制报文字段的解释, retain, 重新获得,一般设置为false, 

      ```c++
       /**
               * Retained为true时MQ会保留最后一条发送的数据，当断开再次订阅即会接收到这最后一次的数据
               */
              message.setRetained(false);
      ```

    - cleanSession 清理回话
      MQTT客户端向服务器发起CONNECT请求时，可以通过’Clean Session’标志设置会话。
      ‘Clean Session’设置为0，表示创建一个持久会话，在客户端断开连接时，会话仍然保持并保存离线消息，直到会话超时注销。
      ‘Clean Session’设置为1，表示创建一个新的临时会话，在客户端断开时，会话自动销毁。

  - 

