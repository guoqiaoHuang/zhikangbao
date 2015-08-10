//
//  RealPlayViewController.m
//  IVMSDemo
//
//  Created by songqi on 15-4-8.
//  Copyright (c) 2015年 songqi. All rights reserved.
//

#import "RealPlayViewController.h"
#import "VideoPlaySDK.h"
#import "VideoPlayInfo.h"
#import "VMSNetSDK.h"
#import "MCRSDK.h"
#import "RtspClientSDK.h"
#import "VideoPlayUtility.h"
#import "CaptureInfo.h"
#import "RecordInfo.h"
static void *_vpHandle = NULL;
extern bool GenerateLiveUrl(PLiveInfo liveInfo, char* buf);
//// 数据回调函数
//void DataCallBack(STREAM_DATA_TYPE dataType, unsigned char *pBuffer, unsigned int nBufSize);
//void DataCallBack(STREAM_DATA_TYPE dataType, unsigned char *pBuffer, unsigned int nBufSize)
//{
//    NSLog(@"dataType is %d", dataType);
//    NSLog(@"nBufSize is %d", nBufSize);
//}

// 状态回调函数
void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl);
void StatusCallBack(PLAY_STATE playState, VP_HANDLE hLogin, void *pHandl)
{
    NSLog(@"playState is %d", playState);
}

@interface RealPlayViewController ()
{
    CGFloat _startSec;//记录从当天第几秒开始回放
    UIToolbar *toolbar;
}
@property(nonatomic,retain)CRealPlayURL *realplayURL;//预览的地址
@property(nonatomic,assign)IBOutlet UISlider *playbackSlider;
@property(nonatomic,retain)NSTimer *playBackTimer;
@property(nonatomic,retain)RecordInfo *recordInfo;
@property(nonatomic,assign)IBOutlet UIImageView *captureImageView;
@property(nonatomic,assign)IBOutlet UILabel *dayStartLable;
@property(nonatomic,assign)IBOutlet UILabel *dayEndLable;
@property(nonatomic,assign)IBOutlet UISegmentedControl *steamTypeSegmentCtrl;
@end

@implementation RealPlayViewController
@synthesize backTouchBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServerInfo:(CMSPInfo *)serverInfo withCameraInfo:(CCameraInfo *)cameraInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        if(serverInfo)
        {
            self.serverInfo = serverInfo;
        }
        else
        {
            self.serverInfo = [[CMSPInfo alloc] init];
        }
        
        if(cameraInfo)
        {
            self.cameraInfo = cameraInfo;
        }
        else
        {
            self.cameraInfo = [[CCameraInfo alloc] init];
        }
        
        self.realplayURL = [[CRealPlayURL alloc] init];
        
        
        BOOL ret = InitLib();
        if(!ret)
        {
            NSLog(@"init MCRSDK fail");
        }
        ret = RtspClientInitLib();
        if(!ret)
        {
            NSLog(@"init Rtsp fail");
        }
    }
    
    return self;
}

/**
 *  建立回放定时器，用于根据回放时间不停调整滑块的位置
 */
-(void)createPlayBackTimer
{
    if(self.playBackTimer)
    {
        if([self.playBackTimer isValid])
        {
            [self.playBackTimer invalidate];
        }
        
        self.playBackTimer = nil;
    }
    
    self.playBackTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(changeSlider) userInfo:nil repeats:YES];
//    [self.playBackTimer fire];
}

- (void)dealloc
{
    //释放RTsp库（6.x平台）
    RtspClientFiniLib();
    //释放MCRSDK库（6.x平台）
    FiniLib();
    self.realplayURL = nil;
    self.cameraInfo = nil;
    self.serverInfo = nil;
    if(self.playBackTimer)
    {
        if([self.playBackTimer isValid])
        {
            [self.playBackTimer invalidate];
        }
        self.playBackTimer = nil;
    }
    self.recordInfo = nil;
//    [super dealloc];
}

/**
 *  根据回放的时间调整滑条
 */
- (void)changeSlider
{
     NSUInteger playedTime = VP_GetFilePlayedTime(_vpHandle);
    [self.playbackSlider setValue:_startSec + playedTime];
    NSLog(@"slider value = %f",self.playbackSlider.value);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopBtnClick:nil];
    self.navigationController.navigationBar.hidden=NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self realplayBtnClick:nil];
    
    [self addNavBack];
    
    //设置应用程序的状态栏到指定的方向
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    
    //view旋转
    [self.view setTransform:CGAffineTransformMakeRotation(M_PI/2)];

    CGRect rect = CGRectMake(- 20,20 ,self.view.bounds.size.height + 20,self.view.bounds.size.width - 100);
    self.backTouchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backTouchBtn.frame = rect;
    backTouchBtn.backgroundColor = [UIColor clearColor];
    [backTouchBtn addTarget:self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backTouchBtn];

    
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(- 20, 0, self.view.bounds.size.height + 20 ,64)];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back_circle.png"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 13.5, 50, 37);
    [btn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [items addObject:spacer1 ];

    
    [toolbar setItems:items animated:YES];

//    [self.view addSubview:toolbar];
    toolbar.hidden = YES;
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    [self.view insertSubview:self.playbackSlider aboveSubview:backTouchBtn];
    [self.playbackSlider setHidden:YES];
    [self.dayStartLable setHidden:YES];
    [self.dayEndLable setHidden:YES];
}

- (void)touchView {
    if (toolbar.hidden == YES) {
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.hidden = NO;
        
        self.navigationController.navigationBarHidden=NO;

    }else {
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.hidden = YES;
        self.navigationController.navigationBarHidden=YES;
    }
    
//    [self.playbackSlider setHidden:!self.playbackSlider.hidden];
 //   [self.dayStartLable setHidden:!self.dayStartLable.hidden];
  //  [self.dayEndLable setHidden:self.dayEndLable.hidden];
    
    //    NSLog(@"111");
}

- (void)backBtnClick{
    //状态栏旋转
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
    
    if(self.playBackTimer && [self.playBackTimer isValid])
    {
        [self.playBackTimer invalidate];
        self.playBackTimer = nil;
    }
//    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    //设置应用程序的状态栏到指定的方向
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //     [self  popPromptViewWithMsg:@"抱歉！视频无法播放，请检查网络，如有疑问请咨询相关客服。" AndFrame:CGRectMake(0, 80, self.view.bounds.size.width, 30)];
}

- (void)viewDidDisappear:(BOOL)animated{
       [super viewDidDisappear:animated];
    //显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

//林明智加
- (void)addNavBack {
    //定制返回按钮
    {
        UIImage* image= [UIImage imageNamed:@"NavBack.png"];
        CGRect frame_1= CGRectMake(0, 0, image.size.width, image.size.height);
        UIButton* backButton= [[UIButton alloc] initWithFrame:frame_1];
        [backButton setBackgroundImage:image forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(homeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:backButton];
//        [self.navigationItem setLeftBarButtonItem:someBarButtonItem];
//        [someBarButtonItem release];
//        [backButton release];
    }
}

- (void)homeButtonPressed{
    [self.navigationController popViewControllerAnimated:NO];
}


/**
 *  进行实时预览
 *
 *  @param sender
 */
-(IBAction)realplayBtnClick:(id)sender
{
    // Do any additional setup after loading the view from its nib.
    VMSNetSDK *vmsNetSDK = [VMSNetSDK shareInstance];
    
    NSString *serverAddr = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_ADDRESS];
    
    NSInteger serverVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:SERVER_VERSION] integerValue];
    
    VideoPlayInfo *videoInfo = [[VideoPlayInfo alloc] init];
    
    VP_STREAM_TYPE streamType = (VP_STREAM_TYPE)self.steamTypeSegmentCtrl.selectedSegmentIndex;
    // 此为设备的用户名和密码, 需要调用VMSNetSDK中的接口 getDeviceInfo 获得的CDeviceInfo中属性：userName和password获取。
    videoInfo.strID =  self.cameraInfo.cameraID;
    videoInfo.strUser   = @"admin";
    videoInfo.strPsw    = @"12345";
    videoInfo.protocalType  = PROTOCAL_UDP;
    videoInfo.playType      = REAL_PLAY;
    videoInfo.streamMethod  = STREAM_METHOD_VTDU;
    videoInfo.streamType    = streamType;//STREAM_SUB;
    videoInfo.pPlayHandle   = (id)self.playView;
    videoInfo.bSystransform = NO;
    
    BOOL bRet;
    if(serverVersion == 0)//如果是3.0SDK
    {
        bRet = [vmsNetSDK getRealPlayURL: serverAddr
                         toSessionID: self.serverInfo.sessionID
                          toCameraID:self.cameraInfo.cameraID
                       toRealPlayURL: self.realplayURL
                        toStreamType: streamType/*STREAM_SUB*/];
        
        if(!bRet)
        {
            NSLog(@"get Realplay URL error");
            return;
        }
        
        videoInfo.strPlayUrl    = self.realplayURL.url1;// @"rtsp://172.10.38.8:554/vag://172.10.38.8:7302:14121604001310019678:0:SUB:UDP";
    }
    else//如果是4.0SDK
    {
        bRet = [vmsNetSDK getPlayToken];
        if(!bRet)
        {
            NSLog(@"get play Token fail");
        }
        char buf[1024] = { 0 };
        LiveInfo liveInfo = { 0 };
        liveInfo.magIp           = (char *)[self.serverInfo.magStreamServer.servAddr UTF8String];
        liveInfo.magPort         = self.serverInfo.magStreamServer.port;
        liveInfo.cameraIndexCode = (char *)[self.cameraInfo.cameraID UTF8String];
        liveInfo.streamType      = streamType;
        liveInfo.cascadeFlag     = self.cameraInfo.cascadeFlag;
        liveInfo.mcuNetID        = self.serverInfo.appNetID;
        liveInfo.deviceNetID     = self.cameraInfo.deviceNetID;
        liveInfo.iPriority       = 100;//[NetUser shareInstance].userAuthority;
        liveInfo.isInternet      = self.serverInfo.isInternet;
        liveInfo.token           = (char *)[vmsNetSDK.strPlayToken UTF8String];
        liveInfo.bTranscode      = 0;

         bRet = GenerateLiveUrl(&liveInfo, buf);
        
        NSString *playUrl = [NSString stringWithFormat:@"%s", buf];
        NSLog(@"%@",playUrl);
        
        videoInfo.strPlayUrl = playUrl;
        videoInfo.protocalType  = PROTOCAL_TCP;

    }
    



    
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
    if(self.playBackTimer && [self.playBackTimer isValid])
    {
        [self.playBackTimer invalidate];
        self.playBackTimer = nil;
    }
    
    // 获取VideoPlaySDK 播放句柄
    if (_vpHandle == NULL)
    {
        _vpHandle = VP_Login(videoInfo);
    }
    
    // 设置状态回调
    if (_vpHandle != NULL)
    {
        VP_SetStatusCallBack(_vpHandle, StatusCallBack, (__bridge void *)self);
    }

    // 开始实时预览
    if (_vpHandle != NULL)
    {
        if (!VP_RealPlay(_vpHandle))
        {
            NSLog(@"start VP_RealPlay failed");
        }
    }
    
    [self.playbackSlider setHidden:YES];
    [self.dayStartLable setHidden:YES];
    [self.dayEndLable setHidden:YES];
}

/**
 *  停止预览或回放
 *
 */
- (IBAction)stopBtnClick:(id)sender
{
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
    
    if(self.playBackTimer && [self.playBackTimer isValid])
    {
        [self.playBackTimer invalidate];
        self.playBackTimer = nil;
    }
}
/**
 *  点击切换主子码流
 *
 *  @param sender
 */
- (IBAction)streamTypeChanged:(id)sender {
    
    if(NULL == _vpHandle)
    {
        return;
    }
    
    [self realplayBtnClick:nil];
}

- (IBAction)playBackBtnClick:(id)sender
{
    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    NSString *strDate = [formatter stringFromDate:date];
    
    [self startPlayBack:date.timeIntervalSince1970 - 5*60];//播放当前时间前5分钟
}

/**
 *  进行回放
 *
 *  @param startPlayTime 开始回放的时间
 *
 *  @return YES 回放成功
 */
- (BOOL)startPlayBack:(NSTimeInterval)startPlayTime//(NSString *)startPlayTime
{
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
    if(self.playBackTimer && [self.playBackTimer isValid])
    {
        [self.playBackTimer invalidate];
        self.playBackTimer = nil;
    }
    
    VMSNetSDK *vmsNetSDK = [VMSNetSDK shareInstance];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:startPlayTime];
    NSString *startPlayTimeStr = [formatter stringFromDate:date];
    ABSTIME stratTime;// ={2015,4,9,0,0,0};
    ABSTIME endTime;// ={2015,4,9,23,59,59};
    
    NSRange range;
    range.length = 4;
    range.location = 0;
    stratTime.year = endTime.year = [[startPlayTimeStr substringWithRange:range] integerValue];
    
    range.location = 5;
    range.length = 2;
    stratTime.month = endTime.month = [[startPlayTimeStr substringWithRange:range] integerValue];
    
    range.location = 8;
    stratTime.day = endTime.day = [[startPlayTimeStr substringWithRange:range] integerValue];
    
    stratTime.hour = 0;
    stratTime.minute = 0;
    stratTime.second = 0;
    
    endTime.hour = 23;
    endTime.minute = 59;
    endTime.second = 59;
    
    CRecordInfo *recordInfo = [[CRecordInfo alloc] init];
    NSString *serverAddr = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_ADDRESS];
    BOOL bRet = [vmsNetSDK queryCameraRecord:serverAddr toSessionID:self.serverInfo.sessionID toCameraID:self.cameraInfo.cameraID toRecordType:@"1" toRecordPos:@"1" toStartTime:&stratTime toEndTime:&endTime toRecordInfo:recordInfo];
    if(!bRet)
    {
        NSLog(@"get playback URL error");
        return NO;
    }
    // 设置播放信息
    VideoPlayInfo *videoInfo = [[VideoPlayInfo alloc] init];
    
    // 此为设备的用户名和密码, 需要调用VMSNetSDK中的接口 getDeviceInfo 获得的CDeviceInfo中属性：userName和password获取。
    videoInfo.strUser   = @"admin";
    videoInfo.strPsw    = @"12345";
    videoInfo.strPlayUrl    = recordInfo.segmentListPlayUrl;
    videoInfo.protocalType  = PROTOCAL_TCP;
    videoInfo.playType      = PLAY_BACK;
    videoInfo.streamMethod  = STREAM_METHOD_VTDU;
    videoInfo.streamType    = STREAM_SUB;
    videoInfo.pPlayHandle   = (id)self.playView;

    NSString *tmpEndDateStr = [NSString stringWithFormat:@"%4d-%02d-%02d 23:59:59",stratTime.year,stratTime.month,stratTime.day];
    videoInfo.fStartTime    = startPlayTime; //开始回放时间
    videoInfo.fStopTime     = [[formatter dateFromString:tmpEndDateStr] timeIntervalSince1970];//结束回放时间
    
    // 获取VideoPlaySDK 播放句柄
    if (_vpHandle == NULL)
    {
        _vpHandle = VP_Login(videoInfo);
    }
    
    // 设置状态回调
    if (_vpHandle != NULL)
    {
        VP_SetStatusCallBack(_vpHandle, StatusCallBack, (__bridge void *)self);
    }
    
    // 开始回放
    if (_vpHandle != NULL)
    {
        if (!VP_PlayBack(_vpHandle, videoInfo.fStartTime, videoInfo.fStopTime))
        {
            NSLog(@"start VP_PlayBack failed");
            return NO;
        }
    }

    [self.playbackSlider setHidden:NO];
    [self.dayStartLable setHidden:NO];
    [self.dayEndLable setHidden:NO];
    
    NSString *subStartTime = [startPlayTimeStr substringToIndex:10];
    subStartTime = [subStartTime stringByAppendingString:@" 00:00:00"];
    CGFloat offsetSec = videoInfo.fStartTime - [[formatter dateFromString:subStartTime] timeIntervalSince1970];
    
    _startSec = offsetSec;
    [self.playbackSlider setValue:offsetSec];
    
    [self createPlayBackTimer];
    return YES;

}

/**
 *  调整回放时间
 *
 */
- (IBAction)sliderControlClick:(id)sender {
    
    int offsetSecond = self.playbackSlider.value;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";// HH:mm:ss";
    NSString *strDate = [formatter stringFromDate:date];
    
    date = [formatter dateFromString:strDate];
    [self startPlayBack:date.timeIntervalSince1970+offsetSecond];
    
}


// 开启声音
- (IBAction)onClickOpenSound:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 开启声音
    if (!VP_AudioCtrl(_vpHandle, true))
    {
        NSLog(@"VP_AudioCtrl failed");
    }
}

// 关闭声音
- (IBAction)onClickCloseSound:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 关闭声音
    if (!VP_AudioCtrl(_vpHandle, false))
    {
        NSLog(@"VP_AudioCtrl failed");
    }
}

// 抓图
- (IBAction)onClickCapture:(id)sender
{
    // 获取抓图信息
    CaptureInfo *captureInfo = [[CaptureInfo alloc] init];
    if (![VideoPlayUtility getCaptureInfo:self.cameraInfo.cameraID toCaptureInfo:captureInfo])
    {
        NSLog(@"getCaptureInfo failed");
    }
    
    // 设置抓图质量 1-100 越高质量越高
    captureInfo.nPicQuality = 80;
    
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 抓图
    if (!VP_Capture(_vpHandle, captureInfo))
    {
        NSLog(@"VP_Capture failed");
    }
    
    [self.captureImageView setImage:[UIImage imageWithContentsOfFile:captureInfo.strCapturePath]];
}

// 开始录像
- (IBAction)onClickStartRecord:(id)sender
{
    // 获取录像信息
    RecordInfo *recordInfo = [[RecordInfo alloc] init];
    if (![VideoPlayUtility getRecordInfo:self.cameraInfo.cameraID toRecordInfo:recordInfo])
    {
        NSLog(@"getCaptureInfo failed");
    }
    
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 开始录像
    if (!VP_StartRecord(_vpHandle, recordInfo, false))
    {
        NSLog(@"VP_StartRecord failed, error code is %ld", VP_GetLastError(_vpHandle));
    }
    
    self.recordInfo = recordInfo;
}

// 停止录像
- (IBAction)onClickStopRecord:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 结束录像
    if (!VP_StopRecord(_vpHandle))
    {
        NSLog(@"VP_StopRecord failed");
    }
}

// 暂停远程回放
- (IBAction)onClickPause:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 暂停远程回放
    if (!VP_PausePlayBack(_vpHandle))
    {
        NSLog(@"VP_PausePlayBack failed error code is %ld", VP_GetLastError(_vpHandle));
    }
}

// 恢复远程回放
- (IBAction)onClickResume:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    // 重新开始远程回放
    if (!VP_ResumePlayBack(_vpHandle))
    {
        NSLog(@"VP_ResumePlayBack failed");
    }
}

// 获取osd时间
- (IBAction)onClickGetOsd:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    NSLog(@"Osd time is %@, time is %ld", [NSDate dateWithTimeIntervalSince1970:VP_GetOsdTime(_vpHandle)], VP_GetOsdTime(_vpHandle));
}

// 获取一共的流数据大小
- (IBAction)onClickGetDataSize:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    NSLog(@"Data size is %ld", VP_GetDataSize(_vpHandle));
}

// 获取视频大小
- (IBAction)onClickVideoSize:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    unsigned int nWidth     = 0;
    unsigned int nHeight    = 0;
    VP_GetVideoSize(_vpHandle, &nWidth, &nHeight);
    NSLog(@"Video size width is %d, height is %d", nWidth, nHeight);
}

- (IBAction)onClickGetPlayStatus:(id)sender
{
    if (NULL == _vpHandle)
    {
        NSLog(@"not playing");
        return;
    }
    
    NSLog(@"Play status is %d", VP_GetPlayState(_vpHandle));
}

- (IBAction)onClickPlayRecrod:(id)sender
{
    // 设置播放信息
    VideoPlayInfo *videoInfo = [[VideoPlayInfo alloc] init];
    videoInfo.strPlayUrl    = self.recordInfo.strRecordPath;
    NSLog(@"videoInfo.strPlayUrl is %@", videoInfo.strPlayUrl);
    videoInfo.protocalType  = PROTOCAL_TCP;
    videoInfo.playType      = PLAY_BACK;
    videoInfo.streamMethod  = STREAM_METHOD_LOCAL;
    videoInfo.pPlayHandle   = (id)_playView;
    videoInfo.bSystransform = NO;
    
    if (_vpHandle != NULL)
    {
        VP_Logout(_vpHandle);
        _vpHandle = NULL;
    }
    
    // 获取VideoPlaySDK 播放句柄
    if (_vpHandle == NULL)
    {
        _vpHandle = VP_Login(videoInfo);
    }
    
    // 设置状态回调
    if (_vpHandle != NULL)
    {
        VP_SetStatusCallBack(_vpHandle, StatusCallBack, (__bridge void *)self);
    }
    
    // 开始本地录像回放
    if (_vpHandle != NULL)
    {
        if (!VP_StartPlayRecord(_vpHandle))
        {
            NSLog(@"start VP_StartPlayRecord failed");
        }
    }
    
    // 说明，在StatusCallBack回调播放停止时，表明文件已经播放完毕，请停止播放
}

- (IBAction)ptzLeftBtnClick:(id)sender
{
    // 是否有云台控制权限
    if (!self.cameraInfo.isPTZControl)
    {
        NSLog(@"no ptz Control");
    }
    NSString *ptzServer = @"";
    int ptzPort;
    // PTZ Info
    if (self.cameraInfo.acsIP)
    {
        ptzServer = self.cameraInfo.acsIP;
        ptzPort = self.cameraInfo.acsPort;
    }

    VMSNetSDK *vmsNetSDK = [VMSNetSDK shareInstance];
    BOOL ret = [vmsNetSDK sendStartPTZCmd:ptzServer toPort:ptzPort toSessionID:self.serverInfo.sessionID toCameraID:self.cameraInfo.cameraID toCmdID:PTZ_CMD_LEFT toParam1:1 toParam2:0 toParam3:0 toParam4:0];
    if(!ret)
    {
        NSLog(@"send ptz cmd fail");
    }
}

- (IBAction)ptzStopBtnClick:(id)sender
{
    // 是否有云台控制权限
    if (!self.cameraInfo.isPTZControl)
    {
        NSLog(@"no ptz Control");
        return;
    }
    NSString *ptzServer = @"";
    int ptzPort = 0;
    // PTZ Info
    if (self.cameraInfo.acsIP)
    {
        ptzServer = self.cameraInfo.acsIP;
        ptzPort = self.cameraInfo.acsPort;
    }
    
    VMSNetSDK *vmsNetSDK = [VMSNetSDK shareInstance];
    [vmsNetSDK sendStopPTZCmd:ptzServer toPort:ptzPort toSessionID:self.serverInfo.sessionID toCameraID:self.cameraInfo.cameraID];
}

- (IBAction)ptzRightBtnClick:(id)sender
{
    // 是否有云台控制权限
    if (!self.cameraInfo.isPTZControl)
    {
        NSLog(@"no ptz Control");
        return;
    }
    NSString *ptzServer = @"";
    int ptzPort = 0;
    // PTZ Info
    if (self.cameraInfo.acsIP)
    {
        ptzServer = self.cameraInfo.acsIP;
        ptzPort = self.cameraInfo.acsPort;
    }
    
    
    VMSNetSDK *vmsNetSDK = [VMSNetSDK shareInstance];
    BOOL ret = [vmsNetSDK sendStartPTZCmd:ptzServer toPort:ptzPort toSessionID:self.serverInfo.sessionID toCameraID:self.cameraInfo.cameraID toCmdID:PTZ_CMD_RIGHT toParam1:1 toParam2:0 toParam3:0 toParam4:0];
    if(!ret)
    {
        NSLog(@"send ptz cmd fail");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark ios6.0设置屏幕方向 方法shouldAutorotate,方法supportedInterfaceOrientations组合
- (BOOL)shouldAutorotate{
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait ;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait ;
//}
//
//#pragma mark ios5.0
//- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation {
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//
//#ifdef __IPHONE_3_0
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
//#else
//    - (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation: (UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
//        UIInterfaceOrientation interfaceOrientation = self.interfaceOrientation;
//#endif
//        if (interfaceOrientation == UIInterfaceOrientationPortrait
//            || interfaceOrientation == UIInterfaceOrientationPortrait)
//        {
////            self.playView.frame = CGRectMake(0 ,0 , 320, 240);
//
//            self.navigationController.navigationBarHidden = NO;
//        }
//        else
//        {
//            self.navigationController.navigationBarHidden = YES;
//            CGRect rect = self.view.window.frame;
////            self.playView.frame = CGRectMake(0, 0, rect.size.height, rect.size.width);
//
//        }
// }
//
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
