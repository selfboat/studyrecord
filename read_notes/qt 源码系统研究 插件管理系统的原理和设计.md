qt 源码系统研究 插件管理系统的原理和设计

- Qt Creator源码分析系列——extensionsystem::PluginManager

  - https://blog.csdn.net/asmartkiller/article/details/104478168
  - https://blog.csdn.net/asmartkiller/category_9634168.html
  - 深入理解QtCreator的插件设计架构
    - https://www.jianshu.com/p/b9e63f8b4db2
  - 【Qt】通过QtCreator源码学习Qt（四）：插件管理PluginManager
    - https://blog.csdn.net/u010168781/article/details/84667127
  - Qt插件热加载-QPluginLoader实现
    - https://www.icode9.com/content-4-184133.html
  - 构建自己的 Qt 插件系统
    - https://waleon.blog.csdn.net/article/details/78475442
    - 一去二三里 博主开始收费, 用这个替代
      - https://blog.csdn.net/qq_33055735/article/details/99654401
  - QtPlugin（C++跨平台插件开发）
    - https://blog.csdn.net/qq_24423085/article/details/90577483

- qt 插件管理系统源码分析记录

  - 主要使用PluginManager来对系统的插件进行管理,包括加载,卸载,生命周期的管理, 拆件状态管理,注册等

  - 利用对象池来实现不同插件之间的扩展类调用

  - class EXTENSIONSYSTEM_EXPORT PluginManager : public QObject

    - 管理类定义了很多静态接口,来设置,获取插件的路径和信息,比如版本,id,配置信息,描述规则信息,启动参数等

    - 大部分接口函数实现的过程中使用了lamda表达式

    - 使用信号,实现状态通知和同步操作

    - 利用Pimp设计方法,隐藏实现细节, 兼容考虑,避免修改的时候重新编译. 

      - PluginManager类的实现文件中可以看出插件管理依赖上述定义的PluginManagerPrivate和PluginManager两个静态指针。

        ```c++
        // 创建一个插件管理器， 每个应用程序只能执行一次
        PluginManager::PluginManager()
        {
            m_instance = this;
            d = new PluginManagerPrivate(this);
        }
        // 获取唯一的插件管理器实例
        PluginManager *PluginManager::instance()
        {
            return m_instance;
        }
        
        ```

    - PluginManager插件管理器不执行任何内存管理-添加的对象必须从池中删除，由人工管理对象内存,通过信号通知,进行对象的添加和删除状态通知.

    - 插件加载的原理和机制: 感觉是采用那种BFS,宽度优先搜索这种层序遍历方式, 从当前的pluginA加载,然后分析它的依赖插件, 加入到依赖队列中,继续从队列分析依赖模块,再加入队列. 直到所有相关的依赖插件模块加载完成.

      ```c++
      QSet<PluginSpec *> PluginManager::pluginsRequiredByPlugin(PluginSpec *spec)
      {
          QSet<PluginSpec *> recursiveDependencies;
          recursiveDependencies.insert(spec);
          std::queue<PluginSpec *> queue;
          queue.push(spec);
          while (!queue.empty()) {
              PluginSpec *checkSpec = queue.front();
              queue.pop();
              const QHash<PluginDependency, PluginSpec *> deps = checkSpec->dependencySpecs();
              for (auto depIt = deps.cbegin(), end = deps.cend(); depIt != end; ++depIt) {
                  if (depIt.key().type != PluginDependency::Required)
                      continue;
                  PluginSpec *depSpec = depIt.value();
                  if (!recursiveDependencies.contains(depSpec)) {
                      recursiveDependencies.insert(depSpec);
                      queue.push(depSpec);
                  }
              }
          }
          recursiveDependencies.remove(spec);
          return recursiveDependencies;
      }
      
      ```

    - 本地和远程插件参数传输,用了socket

    - 循环依赖检测 Circular dependency detected

    - 各个插件的加载, 通过分步骤loadPlugins,加载,初始化,运行状态的监控, 每一个过程的状态判断, 失败就提示退出, Invalid, Read, Resolved,Loaded,Initialized,Running,Stopped,Deleted,

  - ExtensionSystem::IPlugin类

    - 作为所有自定义插件的基类,定义了公共基础接口, 并通过对应的规则描述文件,或者配置文件,确定依赖关系,数据流向,模块的功能,以便插件管理器可以找到插件，解决其依赖关系并加载它。
    - root-to-leaf顺序调用和初始化, BFS
    - 加载原则: 插件可以确保依赖于此插件的所有插件都已完全初始化，并且这些插件希望共享的对象已注册或在全局对象池中可用。如果库加载或插件初始化失败，则依赖于该插件的所有插件也会失败。
    - 非平凡的设置non-trivial setup
    - 解释了这些接口函数的意思,以及调用顺序,调用时机, 关闭退出的流程.
    - initialize,extensionsInitialized,delayedInitialize,aboutToShutdown,remoteCommand,asynchronousShutdownFinished

  - extensionsystem::PluginSpec

    - https://blog.csdn.net/asmartkiller/article/details/104457938
    - 相关类:
      - PluginArgumentDescription
      - PluginDependency
        - PluginDependency类包含插件依赖项的名称和所需的兼容版本号。这将在插件的元数据中反映依赖项对象的数据。名称和版本用于解析依赖关系。搜索具有给定名称和插件{兼容版本<=依赖版本<=插件版本}的插件。
      - ExtensionSystem :: IPlugin
      - QHash提供比QMap更快的查找。 （有关详细信息，请参见算法复杂度。）遍历QMap时，项目始终按键排序。 使用QHash，可以任意订购商品。QMap的键类型必须提供operator <（）。 QHash的键类型必须提供operator ==（）和称为qHash（）的全局哈希函数（请参阅qHash）
      - PluginSpecPrivate

  - QPluginLoader类在运行时加载插件。 QPluginLoader提供对Qt插件的访问。 Qt插件存储在共享库（DLL）中，与使用QLibrary访问的共享库相比，它们具有以下优点：



---

2021年04月14日00:50:36

- 看了,其实qt creator的插件加载机制,最核心的就2个类, PluginManager,PlusinSpec,和它们的具体内部实现类,再加上相关的辅助类,接口类