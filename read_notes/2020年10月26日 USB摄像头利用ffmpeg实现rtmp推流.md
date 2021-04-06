### 2020年10月26日 USB摄像头利用ffmpeg实现rtmp推流

> 相关文档: FFmpeg实战命令记录
>
> @date
>
> @author xiaolaige

#### 1. 网上实现方法记录

- 第一种,命令方式
  - windows dshow利用ffmpeg实现rtmp推流  https://www.jianshu.com/p/c141fc7881e7,  安装ffmpeg和ffplay,完成视频文件以及USB设备的实时推流.
- 音视频系列6：ffmpeg多线程拉流   https://blog.csdn.net/hanghang_/category_9796697.html, 涉及ROS+FFmpeg+SLAM+拉流技术的实现,有参考代码,有提供学习的资料网址.
- 命令的方式实现: Linux下用 FFMPEG 采集 usb摄像头视频 和 摄像头内置麦克风音频 到RTMP服务
  - ffmpeg -f video4linux2 -qscale 10 -r 12 -s 640x480 -i `/dev/video0` -f alsa -i hw:1 -ab 16 -ar 22050 -ac 1 -f mp3 -f flv rtmp://127.0.0.1/rtmpsvr/rtmp1
  - linux FFMPEG 摄像头采集数据推流
  - ./ffmpeg -f video4linux2 -s  640x480 -i /dev/video0  -f flv rtmp://127.0.0.1:1935/live/live
  - https://www.cnblogs.com/enumx/p/12346711.html
  - https://www.scivision.dev/youtube-live-ffmpeg-livestream/
-  【RTMP推流】利用FFMPEG进行USB摄像头数据采集硬件编码后进行 RTMP推流
  - https://blog.csdn.net/yy197696/article/details/105750486
  - 1.RMTP推流服务器建立
    2.S5P6818平台硬件编码
    3.FFMPEG USB摄像头数据采集 https://blog.csdn.net/yy197696/article/details/105749299  代码有注释,看得懂.
  - mjpeg-streamer  应该是一个web服务器,可以访问到mjpeg格式的图片数据流.
- `Windows下,`如何用FFmpeg API采集摄像头视频和麦克风音频，并实现录制文件的功能
  - https://blog.csdn.net/zhoubotong2012/article/details/79338093
  - 内部调用的dshow来采集,编解码格式.
  - zhoubotong2012 网上比较全面的代码和清晰的讲解. 工程写得比其他人全,音频和视频采集,同步问题的解决了.
  - FFmpeg采集摄像头图像并推流（RTSP/RTMP）---开发总结 也是他写得
  - https://blog.csdn.net/zhoubotong2012/article/details/102774983
  - 基于前面博文的例子稍微修改就可以做出`一个采集+编码+推流的软件`
- FFmpeg——视频解码——转YUV并输出——av_image函数介绍
  - https://blog.csdn.net/weixin_42881084/article/details/82427759
  - 参考 资料,将清楚了YUV图像写代码的时候的处理
    https://blog.csdn.net/liaozc/article/details/6110474 
    这里介绍了普遍的data和linesize的关系，RGB中只占第一行，ＹＵＶ则占三行，长度比约为2:1:1，约的是padding size 
    https://blog.csdn.net/mydear_11000/article/details/50404084 
    这里介绍了YUV420，422，444格式的区别，对于写代码需要知道的是： 
    YUV420P 中UV通道为width/2, height/2 
    YUV422P中UV通道为width/2, height 
    YUV444P中UV通道为width, height 
    https://blog.csdn.net/lanxiaziyi/article/details/74347911 
    这里介绍了YUVJ和YUV的普遍区别 
- 雷神: 音视频数据处理入门：RGB、YUV像素数据处理 2016
  - https://blog.csdn.net/leixiaohua1020/article/details/50534150
  - 就看这里就可以了
- 基于SRS+OBS搭建直播系统
- Ffmpeg 获取USB Camera 视频流  https://www.cnblogs.com/wanggang123/p/8299397.html
- FFMPEG音视频同步-音视频实时采集并编码推流-优化版本
  - https://blog.csdn.net/quange_style/article/details/90213392
  - 这里有全过程USB摄像头采集,视频编码,音频编码,推流以及拉流的讲解.

#### 2. 实际操作记录

- ubuntu下搭建FFmpeg开发环境 https://blog.csdn.net/u011598479/article/details/90814641
- Qt5使用FFmpeg开发库  https://blog.csdn.net/weixin_40637594/article/details/85209848 库和头文件的引用
  - https://www.jianshu.com/p/5c159d3721d4  Linux 下Qt+ffmpeg开发环境配置
- treaming tech talks and training / Using Linux 外国人写的教程,也全v4l2-utils gucview obs
- https://jpetazzo.github.io/2020/06/27/streaming-part-4-linux/



参考:

- 网络摄像头Rtsp直播方案（一）
  -  https://blog.csdn.net/weixin_36983723/article/details/85070064
  - 前段时间写完了RTMP的直播方案，因为是基于librtmp的库来实现的，所以比较简单。之后花了一个月吧，参照海思的rtsp推流框架，慢慢的写了一个基于RealTek为底层的网络摄像头Rtsp直播功能的demo。这个不带任何库，纯C写的推流功能，学到了蛮多东西的，都写下来以后忘了还能回来看看，同时也希望给刚刚起步做rtsp直播的小伙伴一点参考。
    一时间也不知道从什么地方讲起，我还是顺着我的代码一步一步讲吧。首先要确定一个事情就是，在网络摄像头RTSP直播的方案中，摄像头是作为服务器端的，连接摄像头请求码流数据的都是客户端。
- 2、RTSP协议的实现,分了客户端和服务端
  - https://blog.csdn.net/huabiaochen/article/details/104528045
  - 

#### 3. 官方文档与手册

- FFmpeg https://www.ffmpeg.org/doxygen/trunk/index.html

- 雷神  `网上多次提到过这位,` 参考他对音视频FFmpeg的讲解和实战学习
  
  - https://blog.csdn.net/leixiaohua1020
  
- DoubleLi  各种技术研究
  - https://www.cnblogs.com/lidabo/category/542245.html
  - boost,c++,cmake, 音视频开发,还在更新中,自从2011年开始
  - https://www.cnblogs.com/lidabo/
  
- fengbingchun 各种技术研究 c++算法老兵 13年码龄
  - https://me.csdn.net/fengbingchun
  - 还比较适用
  
- 音视频系列4：新手如何入门ffmpeg（以FLV解码H.264为例）
  - https://blog.csdn.net/Hanghang_/article/details/104914498
  - 有讲了如何学习ffmpeg的技术,应用,开发
  - 学习开发路线图,
    - 上手直接跑demo,雷神雷霄骅博客：https://blog.csdn.net/leixiaohua1020
    - ffmpeg库的Tutorial,https://github.com/leandromoreira/ffmpeg-libav-tutorial#learn-ffmpeg-libav-the-hard-way
    - 专业知识的学习,这里推荐看维基百科，或者是一些专业书籍,H.264、yuv、rgb有什么区别；pts，dts又是什
    - 看ffmpeg的源码 个源码在你ffmpeg源码目录下的fftools里面
    - 查找API文档,https://www.ffmpeg.org/doxygen/trunk/index.html
    - 源码修改查看, ffmpeg目录下的fftool/文件夹，会看到有很多.c文件，我们优先看ffmpeg.c文
  
- `大指导` 从开发小白到音视频专家 七牛云客户端团队技术负责人
  - https://blog.csdn.net/dev_csdn/article/details/78738806
  - 本文整理自卢俊的演讲，目标读者是对音视频开发感兴趣但是又不知道如何下手的初学者们，
  
- 英语写得博客,讲解了很多知识记录 Video capture from USB camera - ffmpeg
  -  https://blog.csdn.net/chengyq116/article/details/86751110
  - `我跟着学这个测试命令`
  - 对比,国外的讲解教程, https://jpetazzo.github.io/2020/06/27/streaming-part-4-linux/
  - 直接上手
  
- 网络摄像头RTSP视频流WEB端实时播放实现方案
  
  - https://blog.csdn.net/shixin_0125/article/details/109096340
  
- 一分钟之内搭建自己的直播服务器？

  - github 地址：https://github.com/superconvert/smart_rtmpd
  - 这款软件就非常好用，解压既运行，支持跨平台，无任何依赖，性能和 SRS 相比不分上下。支持级联和 url rewrite 以及 CDN 分发
  - 190583317 QQ群
  - csdn 博客 https://blog.csdn.net/freeabc/article/details/102880984

- 知乎的建议:

  作者：Fenngton
  链接：https://www.zhihu.com/question/403656817/answer/1410157355
  来源：知乎
  著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

  如果想要自己学习，网上可以找很多资料进行学习，类似CSDN、知乎、掘进、简书都有很多大牛的博客可以学习。只不过要确定自己的方向，同时保证足够的兴趣和精力。选择好方向后，就可以抓住一个突破口，逐步学习，深入细节慢慢拓展学习面。

  - 比如如果对音视频传输感兴趣，就可以学习各种传输协议、各种信令的控制、数据传输安全等。
  - 如果对编解码感兴趣，视频可以学习H264、H265、VP8， AV1等，音频可以学习PCM、G72x、ilbc等
  - 如果对特效感兴趣，可以学习图形学的知识，从各种转码、美颜、滤镜、模糊处理、锐化处理等方向入手；
  - 如果对服务端感兴趣，可以学习搭建媒体服务器入手、包括音视频数据转发、信令数据处理、拉流、推流协议的处理等。
  - 如果对各种音视频格式感兴趣、可以学习音视频数据格式封装、包括MP4、MVK、FLV、TS、RMVB、MP3、ogg等。当然可以深入学习一些开源库，包括FFMPEG、WebRTC、x264、live555等。同时可以直接阅读各种spec文档、和RFC文档，这个过程就会枯燥和乏味了，但是一旦认真读通几篇，对整体理解会有很大帮助的。
  - 题主有提到流媒体开发，可以从`采集端--》服务端--》客户端这个流程上学习，包括音视频数据如何采集、如何编解码、如何封装和封包、如何传输、服务端如何处理和控制、`客户端如何拉流等入手，找到一个突破点，然后慢慢积累，逐步展开。
  - 任何一个步骤都需要足够时间学习和积累，保持专注就好。音视频流媒体主要还是大厂在招人，要求也比较高，所以更加需要每一个入坑者把自己的基础夯实了。保持足够的兴趣、保持耐心，跟着大佬们学习就好。
  - 可以关注一下音视频领域中的几个大神：雷神(雷霄骅)、鱼哥(何俊林)、超哥（李超）、Jhuster（卢俊）等，跟着大神脚步一起学习，体会其中乐趣。
  
- 球3561248084的博客
  直播系统开发、短视频开发经验分享，直播行业资讯

- https://blog.csdn.net/q3557873521

- 会飞的鱼的博客,10年码龄的文字, qt开发系列, 源码研究
  
  -   https://flywm.blog.csdn.net/