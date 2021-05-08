###  LiveCapture 工程研究记录

- C++知识回顾之__stdcall、__cdcel和__fastcall三者的区别

  - https://www.cnblogs.com/yejianyong/p/7506465.html

  - __stdcall、__cdecl和__fastcall是三种函数调用协议，函数调用协议会影响函数参数的入栈方式、栈内数据的清除方式、编译器函数名的修饰规则等

    ```shell
    调用协议常用场合
    __stdcall：Windows API默认的函数调用协议。
    __cdecl：C/C++默认的函数调用协议。
    __fastcall：适用于对性能要求较高的场合。
    
    栈内数据清除方式
    __stdcall：函数调用结束后由被调用函数清除栈内数据。
    __cdecl：函数调用结束后由函数调用者清除栈内数据。
    __fastcall：函数调用结束后由被调用函数清除栈内数据。
    问题一：不同编译器设定的栈结构不尽相同，跨开发平台时由函数调用者清除栈内数据不可行。
    问题二：某些函数的参数是可变的，如printf函数，这样的函数只能由函数调用者清除栈内数据。
    问题三：由调用者清除栈内数据时，每次调用都包含清除栈内数据的代码，故可执行文件较大
    
    C语言编译器函数名称修饰规则和C++的编译函数名称修饰规则不一样
    问题: C语言和C++语言间如果不进行特殊处理，也无法实现函数的互相调用。
    
    ```

  - DLL编写中extern “C”和__stdcall的作用

    -  https://blog.csdn.net/dongchongyang/article/details/52926310

    - ****dllexport、dllimport、__stdcall的宏定义

      - https://blog.csdn.net/dongchongyang/article/details/52926310 讲的多注意区别

    - https://blog.csdn.net/Windgs_YF/article/details/105164040 代码示范

      ```shell
      extern “C” __declspec(dllexport) bool  __stdcall cswuyg();
      
      ·extern “C”__declspec(dllimport) bool __stdcall cswuyg();
       
      ·#pragma comment(linker, "/export:cswuyg=_cswuyg@0")
      ```

    - 格式;   调用函数的方式 extern "C"  是导出还是导入 _declspec(dllexport)  返回值 调用规则约定 _stdcall 函数声明 func(var args);

    - 纠正说明如何使用 dllexport , dllimport到底要不要使用,它的作用是什么?

      - __declspec(dllimport)与__declspec(dllexport)及__stdcall 作用总结

      - https://blog.csdn.net/qq_21095573/article/details/108974252?utm_medium=distribute.pc_relevant.none-task-blog-baidujs_title-0&spm=1001.2101.3001.4242

        ```
        - 隐式使用dll时，不加__declspec(dllimport)完全可以，使用上没什么区别，只是在生成的二进制代码上稍微有点效率损失
        - 它可以确定函数是否存在于 DLL 中，这使得编译器可以生成跳过间接寻址级别的代码
        - 结论 
        导入全局、静态或者类成员变量需要__declspec(dllimport)
        ```

        结论: `导入全局、静态或者类成员变量需要__declspec(dllimport)`

        ```shell
        #define DllImport __declspec(dllimport)
        
        DllImport int j;
        
        ```

      - 再LINK，一切正常。原来dllimport是为了更好的处理类中的静态成员变量的，如果没有静态成员变量，那么这个__declspec(dllimport)无所谓。

      - https://blog.csdn.net/weixin_33739523/article/details/85589969?utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-18.control&dist_request_id=1331645.22005.16184673496855425&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromMachineLearnPai2~default-18.control  代码实例说明 dllimport的作用

    - __attribute__((packed))详解

      - __attribute__ ((packed)) 的作用就是告诉编译器取消结构在编译过程中的优化对齐,按照实际占用字节数进行对齐，是GCC特有的语法。这个功能是跟操作系统没关系，跟编译器有关，gcc编译器不是紧凑模式的，我在windows下，用vc的编译器也不是紧凑的，用tc的编译器就是紧凑的
      - http://blog.chinaunix.net/uid-25768133-id-3485479.html
      - GNU C的一大特色就是__attribute__机制。__attribute__可以设置函数属性（Function Attribute）、变量属性（Variable Attribute）和类型属性（Type Attribute）
    
    ---
    
    2021年04月19日09:25:23
    
    - 使用 CMake + Git Submodule 方式管理项目三方库,   科学管理
    
      - https://www.mycode.net.cn/language/cpp/2938.html
      - 统一管理三方库, 利用Cmake自动生成Windows和Unix的解决方案
      - 上传三方库文件到 Git 中
      - 使用 CMake + Git Submodule 形式管理
      - 自己的项目需要依赖tinyxml,所以想怎么设计管理这个文件
    
    - 7.11 Git 工具 - 子模块  如何使用子模块的方式来管理第三方库和检出使用库
    
      - https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E5%AD%90%E6%A8%A1%E5%9D%97
    
        ```shell
        $ git submodule add https://github.com/chaconinc/DbConnector
        Cloning into 'DbConnector'...
        remote: Counting objects: 11, done.
        remote: Compressing objects: 100% (10/10), done.
        remote: Total 11 (delta 0), reused 11 (delta 0)
        Unpacking objects: 100% (11/11), done.
        Checking connectivity... done.
        子模块会将子项目放到一个与仓库同名的目录中，本例中是 “DbConnector”。 如果你想要放到其他地方，那么可以在命令结尾添加一个不同的路径。
        
        $ git status
         new file:   .gitmodules    #新的 .gitmodules 文件
        new file:   DbConnector   
        $ git commit -am 'adding crypto library'
        $git push origin master   #推送到服务器
        
        #克隆含有子模块的项目
        $git clone https://github.com/chaconinc/MainProject
        $git submodule init   #目录，不过是空的。 你必须运行两个命令来初始化本地
        $git submodule update
        
        #或者一条组合命令
        $git clone --recurse-submodules https://github.com/chaconinc/MainProject
        $git submodule update --init
        $git submodule update --init --recursive
        ```
    
      - 在包含子模块的项目上工作, 针对子目录,还需要修改更新,团队内部的协作库
    
        - 进入到子目录中运行 git fetch 与 git merge，合并上游分支来更新本地代码。
        - $ git submodule update --remote DbConnector 命令默认会假定你想要更新并检出子模块仓库的 `master` 分支, 其他分支就可以修改gitmodule的文件,或者本地的.git/config文件
    
      - 从项目远端拉取上游更改
    
        - git pull , git status, git submodule update --init --recursive
        - git submodule syn
    
      - 在子模块上工作
    
        - 需求: 你确实想在子模块中编写代码的同时，还想在主项目上编写代码（或者跨子模块工作）
    
        - 确保本地修改的子模块代码,是否正确提交,确保团队成员, 发现依赖的子模块库的更改
    
          ```shell
          git push --recurse-submodules=check #检查本地子目录是否有修改,是否有推送
          git push --recurse-submodules=on-demand # 尝试进入子目录,然后push到远端,失败话退出整个过程
          ```
    
          `git config push.recurseSubmodules on-demand` 让它成为默认行为。
    
      - 子模的块技巧
    
        - 子模块遍历
          有一个 foreach 子模块命令，它能在每一个子模块中运行任意命令。
    
          git submodule foreach 'git stash'
    
    - 使用VSCode和CMake构建跨平台的C/C++开发环境
    
      - https://www.cnblogs.com/iwiniwin/archive/2020/09/21/13705456.html
      - 参考学习这个,讲解比较全
      - 日前在学习制作LearnOpenGL教程的实战项目Breakout游戏时，希望能将这个小游戏开发成跨平台的，支持在多个平台运行。工欲善其事必先利其器，首先需要做的自然是搭建一个舒服的跨平台C/C++开发环境，所以这篇文章主要就是记录环境搭建的整个过程，踩到的一些坑，以及对应的解决办法。
      - 针对于单文件编译运行，需要在代码文件夹下建立子文件夹 .vscode ，并放置三个文件
        - 1：c_cpp_properties.json
        - 2：launch.json
        - 3：tasks.json
      - 针对于工程构建，需要在代码文件夹下建立CMakeLists.txt，并建立子文件夹 *.vscode* ，放置两个文件
        - 1：CMakeLists.txt
        - 2：c_cpp_properties.json
        - 3：launch.json，注意更改15行gdb路径
        - https://www.cnblogs.com/ibilllee/p/12255285.html
    
    - vscode中cmake项目管理和调试 , 这个推荐和我一样的,安装三个插件开发vscode
    
      - 安装C/C++ for Visual Studio Code，CMake Tools，CMake For VisualStudio Code（可选，高亮提示等辅助功能，个人觉得挺好使用)三个插件.
      - vscode 底部状态栏快捷键有对应的设置. 
      - https://www.jianshu.com/p/1f04cfa422a1
      - ![img](https://upload-images.jianshu.io/upload_images/15916253-6009867885ce1047.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)
    
    - cmake-多模块工程的编译
    
      - https://blog.csdn.net/weixin_43708622/article/details/108232942
    
    - https://www.cnblogs.com/pigdragon/p/6548448.html  **Makefile 介绍** C语言编译
    
  - 实操
  
    - git submodule add https://github.com/leethomason/tinyxml2.git  ThirdLib/TinyXML
      - 当前项目添加子模块到本地指定路径下, 本地的路径不能是存在的, add的时候它会自己创建你指定的文件夹目录
      - https://www.cnblogs.com/sunsky303/p/14236202.html
      - 成功add后,本地就会有git仓库上面拉取的最新的额tinyxml文件代码
    - git submodule add https://git.ffmpeg.org/ffmpeg.git ThirdLib/FFmpeg
      - 由于ffmpeg项目太大,操作比较耗时,根据对比源工程,发现原工程是精简版本的头文件和库,没有源码
      - 所以想办法,看怎么设计合适.  
        - 考虑到要解决多平台多芯片架构上面的部署, 还是需要源码cmake编译构建才行, 原来的第一种的.h文件和so,dll库只针对特定系统.     源码
        - 想到可以根据编译说明, 提前在机器里面安装对应的ffmpeg,然后利用cmake去查找ffmpeg的库和头文件,进行项目编译. find_package, add_targe_link().  环境安装
        - 再用docker制作生成环境,直接运行我们的软件,      容器技术, 环境安装
        - sudo apt install ffmpeg 
  
  - 问题:
  
    - C ++项目中ffmpeg的CMake配置(CMake configuration for ffmpeg in C++ project)
  
      - https://www.it1352.com/2000781.html
  
    - makefile, mk文件就是告诉编译如何去编译,解析规则,生成对应的库和文件. 主要是c语言程序
  
    - 工程构建,枚举源文件和头文件的方法, 
  
      ```shell
      # 最低CMake版本要求
      cmake_minimum_required(VERSION 3.10.0)
      
      # 项目名称
      project(cmake-test)
      
      # 设置C/C++标准
      set(CMAKE_C_STANDARD 11)
      set(CMAKE_CXX_STANDARD 17)
      set(CMAKE_CXX_STANDARD_REQUIRED ON)
      
      # 头文件路径
      include_directories("Inc")
      
      # 枚举头文件
      file(GLOB_RECURSE INCLUDES "Inc/*.h" "Inc/*.hpp")
      
      # 枚举源文件
      aux_source_directory("Src" SOURCES)
      
      # 输出路径
      set(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
      
      # 生成可执行的文件
      add_executable(${PROJECT_NAME} ${SOURCES} ${INCLUDES})
      ```
  
    - # 枚举头文件
      file(GLOB_RECURSE INCLUDES "Inc/\*.h" "Inc/\*.hpp")
  
      # 枚举源文件
      aux_source_directory("Src" SOURCES)
      
    - cmake 遍历目录获取所有文件名
  
      - https://www.jianshu.com/p/42cdaa07316b
      - file(GLOB USER_LIBS_PATH ./src/*.cpp)
  
  - VS构建多模块的CMAKE项目+引入外部DLL
  
    - https://www.freesion.com/article/11021399752/
    - 写得可以,有参考, 文件拷贝那一块
    
  - CMake之建立多模块工程
  
    - https://blog.csdn.net/webzhuce/article/details/115413320
  
- set -x介绍
  用于脚本调试，在liunx脚本中可用set -x就可有详细的日志输出.免的老是要echo了

- set -e介绍 若指令传回值不等于0，则立即退出shell。　-e帮助你检查错误。如果你忘记检查（执行语句的结果），bash会帮你执行。不幸的是，你将无法检查$?，因为如果执行的语句不是返回0，bash将无法执行到检查的代码

---

- 在Linux系统中，Resouce limit指在一个进程的执行过程中，它所能得到的资源的限制，比如进程的core file的最大值，虚拟内存的最大值等。

  Resouce limit的大小可以直接影响进程的执行状况。其有两个最重要的概念：soft limit 和 hard limit。

  struct rlimit {
  rlim_t rlim_cur;
  rlim_t rlim_max;
  };
  soft limit是指内核所能支持的资源上限

- 阿里云视频 视频点播说明

  -  https://help.aliyun.com/document_detail/99380.html?utm_content=g_1000230851&spm=5176.20966629.toubu.3.f2991ddcpxxvD1#h2-url-9

  - GOP值表示关键帧的间隔(即两个关键帧之间的帧数)，也就是两个IDR帧之间的距离，一个帧组的最大帧数。一般而言，每一秒视频至少需要使用 1 个关键帧。增加关键帧个数可改善视频质量，但会同时增加带宽和网络负载。`GOP值（帧数）除以帧率即为时间间隔`，如阿里云视频点播默认的GOP值为250帧，帧率为25fps，则时间间隔为10秒。

    GOP值需要控制在合理范围，以平衡视频质量、文件大小（网络带宽）和seek效果（拖动、快进的响应速度）等：

  - 一般GOP长度在250帧以下

  - 关键帧有具体的画面信息，其余的都只是运算出来的，我设的 120 帧间隔。

- 用pthread_create()创建线程后，线程是立即自动运行了吗？
  看了半天也没找到具体的怎么开始一个线程

  - 是 有可能在pthread_create()返回前就已经运行了甚至是运行结束了(参见programming with posix threads)

  - if(pthread_create(&pThread->hHandle, nullptr, procFunc, pThread) < 0)

  - c++ 创建线程用CreateThread后，线程直接就开始执行了吗？还是还要再给它一个命令才能执行？

  - 0：表示创建后立即激活。

    ```shell
    //CreateThread函数的参数原型如下
    HANDLE CreateThread(
    　　LPSECURITY_ATTRIBUTES lpThreadAttributes, // SD
    　　SIZE_T dwStackSize, // initial stack size
    　　LPTHREAD_START_ROUTINE lpStartAddress, // thread function
    　　LPVOID lpParameter, // thread argument
    　　DWORD dwCreationFlags, // creation option //这里指明建立后的线程是挂起还是直接运行
    　　LPDWORD lpThreadId // thread identifier
    　　);
    //dwCreationFlags 有几个先项
    （1）CREATE_SUSPENDED(0x00000004)：创建一个挂起的线程，这时候你需要调用resumethread()函数来手段将其释放，才能执行线程
    （2）0：表示创建后立即激活。 这时候创建的线程会马上进入到任务等待队列，等待执行。
    ```

- H264 Profile对比分析

  - https://blog.csdn.net/matrix_laboratory/article/details/72764621

  - Baseline
    支持I/P 帧，只支持无交错(Progressive)和CAVLC 
    一般用于低阶或需要额外容错的应用，比如视频通话、手机视频等；　　

    Main
    支持I/P/B 帧，无交错（Progressive）和交错（Interlaced），CAVLC 和CABAC 
    用于主流消费类电子产品规格如低解码（相对而言）的mp4、便携的视频播放器、PSP和Ipod等；　　

    High
    在Main的基础上增加了8x8 内部预测、自定义量化、无损视频编码和更多的YUV 格式（如4：4：4） 
    用于广播及视频碟片存储（蓝光影片），高清电视的应用。

  - 简单理解就是H264有多个版本，版本越高编码效率和压缩率就越高，对应的版本是Profile。 
    从低到高分别为：Baseline、Main、High 

---

- 2021年04月25日

  - Cmakelists 加入ffmpeg库

  - https://blog.csdn.net/ooyyee/article/details/106364570

  - ffmpeg作为当前工程项目的3rd动态库形式引入到当前的工程项目, 利用 include_directory, LINK_DIRECTORY, add_library, set_target_properties, **target_link_libraries**, 将本地的库链入到可执行程序中.

  - Linux下cmake编译流程实践--初学篇

    - https://blog.csdn.net/qq_15390133/article/details/106457036

    - 基本步骤, 自己项目目录中,先建立一个build目录

    - ```
      cd build 
      cmake ..
      make
      ```

    - https://blog.csdn.net/weixin_43297891/article/details/115180405

  - gitignore忽略子目录下所有某后缀的文件

    - gitignore需要忽略子目录中，拥有某后缀的文件。用**代表所有子目录
      例如，我要忽略以iml结尾的文件，可以如下所示

    - ```undefined
      **/*.iml
      ```

- 【FFmpeg】解决警告warning: xxx is deprecated [-Wdeprecated-declarations]的方法

  - https://blog.csdn.net/u010168781/article/details/105163945/
  -  set(CMAKE_CXX_FLAGS "-Wno-error=deprecated-declarations -Wno-deprecated-declarations ")
  - 根据信息提示，这些接口已经过时，在编写程序时推荐使用。查看FFmpeg源码，对不推荐使用的接口、变量、类等都被宏attribute_deprecated标记，
  - FFmpeg新旧接口对照使用一览
    - ffmpeg新老接口记录 https://www.jianshu.com/p/81d395580fa9
    - ffmpeg源码包里面有个apichangs文档，里面有各种接口改变的记录，
    - 如果你发现接口不能用了，可以去搜索那个文档，
    - 可以找到对应的新接口，然后到新接口对应的头文件中找到说明文字
    - ffmpeg新接口之体验
      - https://blog.csdn.net/fengliang191/article/details/106892567/

- 常见gcc编译警告整理以及解决方法 - 全

  - -Werror
    　　将所有的警告当成错误处理。此选项谨慎建议加上。有的开源库警告很多（大名鼎鼎的ffmpeg也有很多警告呢），一一改掉耗时耗人力，必要性也不大。最后，公司代码加入了一个开源库，里面有很多代码警告，可能领导又安排我来fix了

  - ### **-Wfatal-errors**

    　　遇到第一个错误就停止，减少查找错误时间。建议加上。很多人遇到错误，没有意识到从第一个开始排查。不管是编译错误，还是程序运行出错，从最开始的错误查起，是个好的做法。

  - -Wall开启“所有”的警告。强烈建议加上，并推荐该选项成为共识。

  - ### **-Wextra**

    　　除-Wall外其它的警告。建议加上。

- # CMake 入门学习2 使用VSCode cmake插件

- https://blog.csdn.net/xundh/article/details/108994730

  - ### 在命令面板输入 `Cmake:Quick Start`

  - 在命令面板选择`CMake: Select Variant`

  - 在命令面板选择`CMake: configure`

  - 在命令面板选择`CMake: build`

  - 在命令面板选择CMake: Debug

  - 程序会停在断点处，按F5继续执行程序。

    更多文档参考：
    https://github.com/microsoft/vscode-cmake-tools/blob/develop/docs/README.md

  - 在vscode中使用cmake插件，按ctrl+s键时，总是会自动configure，好多时候并不想要这样。取消ctrl+s时自动configure的方法：打开settings，在搜索框中输入cmake on save，取消勾选"Cmake: Configure On Edit"下面的复选框"Automatically configure CMake project directories when cmake.sourceDirectory or CMakeLists.txt content are saved."即可。

- CMAKE支持c99的两种方式
  一种是比较常见的全局设置

  set(CMAKE_C_FLAGS "-std=c99")
  另外一种是针对某个target设置，这样不同的target之间可以不受影响

  add_executable(BiquadFilter biquad_filter.c)
  set_property(TARGET BiquadFilter PROPERTY C_STANDARD 99)

  [CMake教程]（三）CMake 配置指定C++11编译的标准

  https://blog.csdn.net/long123444/article/details/109547392

- **变量的列表可以查看cmake模块文件，或者使用命令 cmake –help-module FindBZip2** 。

  - https://blog.csdn.net/bingqingsuimeng/article/details/79670244

  - find_package()的查找*.cmake的顺序：

  - *不管使用哪一种模式，只要找到`*.cmake`，`*.cmake`里面都会定义下面这些变量：

    ```shell
    <NAME>_FOUND<NAME>_INCLUDE_DIRS or
    <NAME>_INCLUDES<NAME>_LIBRARIES or 
    <NAME>_LIBRARIES or 
    <NAME>_LIBS<NAME>_DEFINITIONS
    ```

  - 使用外部库的方式：
      为了能支持各种常见的库和包，CMake自带了很多模块。可以通过命令 cmake --help-module-list 得到你的CMake支持的模块的列表，或者直接查看模块路径。

    ```
     cmake --help-module FindOpenGL
      cmake --help-module--list   #列出当前通过cmake find_package能够找到的包
      
    ```

  - cmake】——find_path/find_library用法例子

    - https://blog.csdn.net/u011622208/article/details/109176551

      ```
      #在HINTS后的路径中找NvInfer.h, PATH_SUFFIXES：在每个搜索路径的子目录下搜索
      find_path(TENSORRT_INCLUDE_DIR NvInfer.h
      HINTS ${TENSORRT_ROOT} ${CUDA_TOOLKIT_ROOT_DIR}
      PATH_SUFFIXES include)
      
      find_library(TENSORRT_INFER libnvinfer.so
      HINTS ${TENSORRT_ROOT} ${CUDA_TOOLKIT_ROOT_DIR}
      PATH_SUFFIXES lib lib64 lib/x64)
      
      find_library(TENSORRT_INFER_PLUGIN libnvinfer_plugin.so
      HINTS ${TENSORRT_ROOT} ${CUDA_TOOLKIT_ROOT_DIR}
      PATH_SUFFIXES lib lib64 lib/x64)
      
      ```

    - 原文链接：https://blog.csdn.net/u011622208/article/details/109176551

    - CMakeList 中 find_library 用法

      - https://blog.csdn.net/comedate/article/details/109684446
      - find_library(GPUJPEG_LIBRARY NAMES gpujpeg
                     HINTS ${CMAKE_CURRENT_LIST_DIR}/lib/Release)

  - FFMpeg系列二:Android集成ffmpeg cmake编译

    - https://www.jianshu.com/p/06f283893b7c

  - include_directories 头文件搜索路径添加

  - link_directories   共享库文件搜索路径添加

  - TARGET_LINK_LIBRARY 区别  目标程序或者库的依赖添加

    - https://blog.csdn.net/webzhuce/article/details/115413320

  - link_libraries 在Cmake中会添加全部指定依赖, 不管后面程序和库是指定依赖哪些, 都会添加依赖进去, 所以建议优先使用target_link_libraries();

  - 查看GitHub仓库大小的几种方法  阅读数：562次 2019-09-23

  - github上readme.md的文件基本写法

    - https://www.wj0511.com/site/detail.html?id=235

  - 是CMAKE的新手，对与target_link_libraries相关的PUBLIC，PRIVATE和INTERFACE关键字有点混淆。文档提到它们可以用于在一个命令中同时指定链接依赖关系和链接接口。
    链接依赖关系和链接界面是什么意思？

    `如果您正在创建一个共享库，并且您的源cpp文件#include另一个库的标题(例如，说QtNetwork)，但是您的头文件不包括QtNetwork头，则QtNetwork是一个PRIVATE依赖项。`
    如果您的源文件和头文件包含另一个库的头文件，那么它是一个PUBLIC依赖项。

    如果您的头文件而不是您的源文件包含另一个库的标头，那么__它是__一个INTERFACE依赖关系。

    PUBLIC和INTERFACE依赖关系的其他构建属性被传播到消费库。

- 从cmake构建中删除特定文件

  - http://www.voidcn.com/article/p-yzhkwvgn-bsy.html

  - https://www.it1352.com/516424.html

  - You can use the list function to manipulate the list, for example:

    ```
    list(REMOVE_ITEM <list> <value> [<value> ...])
    ```

    In your case, maybe something like this will work:

    ```shell
    list(REMOVE_ITEM lib_srcs "IlmImf/b44ExpLogTable.cpp")
    ```

  - REMOVE_ITEM 是操作函数
  
    - https://cloud.tencent.com/developer/ask/121477
  
    - 使用的列表`set()`：
  
      - `set(MyList "a" "b" "c")`
      - `set(MyList ${MyList} "d")`
  
      或者更好地与`list()`：
  
      - `list(APPEND MyList "a" "b" "c")`
      - `list(APPEND MyList "d")`
  
    - linux中make install指定安装目录
  
      - https://blog.csdn.net/weixin_42732867/article/details/104789431
  
      - 修改configure文件中prefix的值：
  
        用vi/vim打开configure文件，然后找到prefix值，修改未prefix=你的安装目录，然后保存退出，再执行./configure & make & sudo make install就可以，不过该方法比较麻烦，会容易改动到configure文件的其他的参数，不建议使用。
  
      2.执行configure文件时指定安装目录：
  
      ./configure --prefix=/home/user/zws/build
       3.在make install指定DESTDIR参数：
  
      ./configure
      make 
      make install DESTDIR= /home/user/zws/build
  
- 如何测试CMake是否使用find_library找到一个库

  - http://www.voidcn.com/article/p-mphpqira-buy.html

  - ```shell
    find_library(LUA_LIB lua)
    if(NOT LUA_LIB)
      message(FATAL_ERROR "lua library not found")
    endif()
    ```

  - 

---

2021年04月27日15:22:40

- 发现编译当前的LiveCapture项目在生成RTSPServer库的时候,由于采用的live555的开源库的版本不一致,导致编译的通不过,有些文件缺失了,需要去解决版本兼容的问题.
- 最新的版本是这个 http://www.live555.com/liveMedia/public/      live555 2021.05.03
- 和外包提供的代码的版本兼容的一个库在这个地方
- http://code1.okbase.net/codefile/RTSPServerSupportingHTTPStreaming.hh_201211122964_142.htm
- http://download.videolan.org/pub/contrib/live555/   live555 历史版本下载
- 指定搜索对应的版本
- 利用google搜索, 找到最佳的搜索结果

---

2021年05月07日17:12:18

- 编译新下载的live_2012V库, 提示报错信息liveMedia/include/Locale.hh:47:10: fatal error: xlocale.h: No such file or directory”

  - 解决方法, 需要修改编译选项. http://www.manongjc.com/article/57827.html

  - 在live库的os配置模板中, config.linux-64bit里面 添加-DXLOCALE_NOT_USED

  - 可以参考 简易Makefile编写流程_20160917 https://blog.csdn.net/u012125696/article/details/52562932  

    - **4、指定编译选项；**    |---如 -Wall -DBSD=1 -DLOCALE_NOT_USED

  - 可以编译到下一步,然后报错

    ```shell
    RTSPClient.cpp: In static member function ‘static Boolean RTSPClient::checkForHeader(const char*, const char*, unsigned int, const char*&)’:
    RTSPClient.cpp:840:28: error: ISO C++ forbids comparison between pointer and integer [-fpermissive]
       if (&line[paramIndex] == '\0') return False; // the header is assumed to be bad if it has no parameters
    ```

  - 直接去掉这个 if (&line[paramIndex] == '\0') 这个取地址的符号, 编译通过.

  - #define BASICUSAGEENVIRONMENT_LIBRARY_VERSION_STRING	"2018.02.18"  它用的是2018.02.18的库代码