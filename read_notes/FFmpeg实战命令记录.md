### FFmpeg实战命令记录

---

> 最相关参考: https://jpetazzo.github.io/2020/06/27/streaming-part-4-linux/
>
> https://blog.csdn.net/chengyq116/article/details/86751110



#### 1. Ubuntu 系统下操作

- 指令查看设备 ffmpeg -devices 
  
  - 没有看到列出设备详情,只看到了支持的协议,和支持的格式库
  
- ls /dev/video* 查看当前所有视频设备文件 

- ls /dev/audio* 查看当前系统中的所有音频设备

- dmesg | tail 插拔相机的话,查看内核最新消息输出
  
  - dmesg -wh
  
- usb设备主要是通过UVC driver驱动来识别加载设备的
  
  - lsusb 查看usb挂载设备
  
- 相机视频播放测试
  - 安装ffmpeg , sudo apt install ffmpeg
  - ffmpeg -f video4linux2 -r 30 -s 640x480 -i /dev/video0 output_video.avi 按ctrl+C终止录制
  
- 视频设备清单
  
  - 需要安装工具包,包含这个程序 v4l2-ctl , 可以安装v4l-utils or v4l2-utils 
  
    ```shell
    sudo apt-get install v4l2loopback-utils # 我18.04找到这个安装
    ```
  
    执行 v4l2-ctl --list-devices
  
    结果:
  
    ```shell
    (py27) lijuan@Legion-Y:~$ v4l2-ctl --list-devices
    SPCA2688 AV Camera: SPCA2688 AV (usb-0000:00:14.0-2):
    	/dev/video2
    	/dev/video3
    
    Integrated Camera: Integrated C (usb-0000:00:14.0-6):
    	/dev/video0
    	/dev/video1
    ```
  
  - cheese -d /dev/video*
  
  - guvcview  gui 工具直接调整查看
  
    - 坑爹的guvcview, 后台日志增长,cpu使用率很高,需要优化 https://blog.csdn.net/qq_21293755/article/details/54908528
  
  - ffplay /dev/video0 播放视频,还可以设置播放选项
  
- 视频格式等详细输出

  - 综合使用v4l2-ctl 输出frame_rate,formats信息,使用ffplay输出编码格式
  - ffplay -list_formats all /dev/video0, 看看format_code定义
  
- 设备硬件接口

  - USB 3 offers much faster speeds. It starts at 5000 Mb/s, so 10x faster than USB 2
  - USB2 共享当前带宽,USB接口一般带宽为480MB/S.

- 用户操作命令

  - fuser -auv /dev/video9 查看哪些进程在使用这个文件
  - ffplay http://192.168.1.123:8080/video -vf setpts=0
  - ffmpeg -i http://192.168.1.123:8080/video -pix_fmt yuv420p -f v4l2 /dev/video9

- 音频操作命令

  - arecord -l
    aplay -l
  - Test audio playback with ffplay -f alsa hw:9,1, or use it as an input source in ffmpeg with -f alsa -i hw:9,1
  - 

#### 2. Windows 系统下操作

- ffmpeg -list_devices true -f dshow -i dummy   查看音视频采集设备
- ffmpeg -list_options true -f dshow -i video="USB 2861 Device"  根据设备名称,查看这个设备的具体信息参数.采集设备支持的分辨率、帧率和像素格式等属性
- fmpeg -f dshow -i video="USB 2861 Device" -f dshow -i audio="线路 (3- USB Audio Device)" -vcodec libx264 -acodec aac -strict -2 mycamera.mkv
  - 上面的命令行用video=指定视频设备，用audio=指定音频设备，后面的参数是定义编码器的格式和属性，输出为一个名为mycamera.mkv的文件。 按“Q”键则中止命令
  - 命令行加上“-s 720x576”，则FFmpeg就会以720x576的分辨率进行采集，如果不设置，则以默认的分辨率输出。
- AVCapture 采集程序的使用 
  - 能从视频采集设备（摄像头，采集卡）获取图像，支持图像预览；还可以采集麦克风音频；支持对视频和音频编码，支持录制成文件。这是一个MFC开发的窗口程序，界面比较简洁





#### 3. 程序编码设计与实现

- windows下FFmpeg的采集,编解码,显示
- 设计: 该采集程序实现了枚举采集设备，采集控制、显示图像、视频/音频编码和录制的功能，其中输入（Input）、输出（Output）和显示（Paint）这三个模块分别用一个单独的类进行封装：CAVInputStream，CAVOutputStream，CImagePainter。CAVInputStream负责从采集设备获取数据，提供接口获取采集设备的属性，以及提供回调函数把数据传给上层。CAVOutputStream负责对采集的视频和音频流进行编码、封装，保存成一个文件。而CImagePainter则用来显示图像，使用了GDI绘图，把图像显示到主界面的窗口。
- [FFmpeg] 如何通过实时摄像头帧图片生成 rtmp 直播流?
  - https://www.v2ex.com/amp/t/436280/2
  - 因为硬件驱动的原因
  - 系统中一个 usb camera, 同一时刻, 只能有一个加载进程来读取实时帧图像
  - 如果如客户自己实验通过的:
    - 用 `FFmpeg -f dshow -i video="... -f mpegts -f flv "rtmp://20878....` 形式
    - 从硬件直接拿视频并实时编译为 flv 编码的 rtmp 直播流
    - 那么, 原先软件将无法获得合法的帧图像进行业务分析
  - 这里有设计实现, 其实都是读取rtsp流,然后视频图像处理,再转换推流成rtmp数据到服务器
    - https://blog.csdn.net/Alvin_zy/article/details/103343918
    - 



#### 4. 音视频学习知识

- 从代码可以看出，与YUV420P三个分量分开存储不同，RGB24格式的每个像素的三个分量是连续存储的。一帧宽高分别为w、h的RGB24图像一共占用w*h**3 Byte的存储空间。RGB24格式规定首先存储第一个像素的R、G、B，然后存储第二个像素的R、G、B…以此类推。类似于YUV420P的存储方式称为Planar方式，而类似于RGB24的存储方式称为Packed方
- 