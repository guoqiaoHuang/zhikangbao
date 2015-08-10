//
//  ShowTrackingViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/19.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "ShowTrackingViewController.h"

@interface ShowTrackingViewController ()<MAMapViewDelegate, TrackingDelegate>
@property (nonatomic, strong) MAMapView *mapView;

@property (nonatomic, strong) Tracking *tracking;
@property (assign)CLLocationCoordinate2D coords;


@property (nonatomic) NSArray *buttomRadioButtons;
@end

@implementation ShowTrackingViewController
{
    NSMutableArray *locationArr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=NO;
        self.isCancel=YES;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"轨迹回放";
    [self setupMapView];
    [self performSelector:@selector(handleRunAction) withObject:nil afterDelay:0.8];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
   
}
#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if (annotation == self.tracking.annotation)
    {
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"ball"];
        
        return annotationView;
    }
    
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == self.tracking.polyline)
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = [UIColor redColor];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}

- (void)didEndTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}


#pragma mark - Handle Action

- (void)handleRunAction
{
    if (self.tracking == nil)
    {
        [self setupTracking];
    }
    
}

#pragma mark - Setup

/* 构建mapView. */
- (void)setupMapView
{
    [MAMapServices sharedServices].apiKey = @"f945bab7a3c779bd588558ae5bbed96d";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self performSelector:@selector(handleRunAction) withObject:nil afterDelay:3];
    self.mapView.frame = self.view.bounds;

    [self.view addSubview:self.mapView];
}

/* 构建轨迹回放. */
- (void)setupTracking
{
    NSString *trackingFilePath = [[NSBundle mainBundle] pathForResource:@"GuGong" ofType:@"tracking"];
    
    NSData *trackingData = [NSData dataWithContentsOfFile:trackingFilePath];
    //    NSArray *traceArr=[NSKeyedUnarchiver unarchiveObjectWithData:trackingData];
    //    NSLog(@"-------0000%@",traceArr);
    //    NSString *trackstr = [[NSString alloc] initWithData:trackingData encoding:NSUTF8StringEncoding];
    ////    NSLog(@"=====%@ %@",trackingData,trackstr);
    //
        CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(trackingData.length);
    
    /* 提取轨迹原始数据. */
        [trackingData getBytes:coordinates length:trackingData.length];
#if 1
    
    NSString *keystring =[UserInformation sharedUserManager].api_key;
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/lbs/tracking/api_key/%@",apiUrl,warmstring];
    NSDate *date=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
//    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    
    NSString *current=@"2014-05-06";
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate*beginDate = [inputFormatter dateFromString:current];
     NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    NSDictionary *trackingDic=@{
                                @"person_id":personID,
                                @"begin_date":beginDate,
                                @"end_date":date
                                };
    NSString *tt=[NSString stringWithFormat:@"%@/person_id/%@/begin_date/%@/end_date/%@",trackingUrl,@"123456",beginDate,date];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"历史位置信息：%@/n,%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            NSArray *arr=[json objectForKey:@"data"];
            
            locationArr = [NSMutableArray arrayWithCapacity:arr.count];
            CLLocationCoordinate2D cll2ds[arr.count];
            for (int k = 0;k < arr.count;k++) {
                NSDictionary *dic=arr[k];
                NSString *latitude=[dic objectForKey:@"lat"];
                NSString *longitude=[dic objectForKey:@"lng"];
                
                self.coords = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                NSValue *value = [NSValue valueWithBytes:&_coords objCType:@encode(CLLocationCoordinate2D)];
                [locationArr addObject:value];
                cll2ds[k]=CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
                
            }
            
            NSData *data = [NSData dataWithBytes:(__bridge const void *)(locationArr) length:sizeof(CLLocationCoordinate2D)*locationArr.count];
            
            //            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
            //
            //            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            //               //定义记录文件全名以及路径的字符串filePath
            //
            //            NSString *filePath = [documentDirectory stringByAppendingPathComponent:@"UserNameAndPassWord.txt"];
            //             BOOL writeSuccess = [data writeToFile:filePath atomically:YES];
            if (TRUE) {
                
                CLLocationCoordinate2D *coordinate2 = (CLLocationCoordinate2D *)malloc(data.length);
                /* 提取轨迹原始数据. */
                
                [data getBytes:coordinate2 length:data.length];
                /* 构建tracking. */
                self.tracking = [[Tracking alloc] initWithCoordinates:cll2ds count:locationArr.count];
                /* 构建tracking. */
//                self.tracking = [[Tracking alloc] initWithCoordinates:coordinates count:trackingData.length / sizeof(CLLocationCoordinate2D)];
                self.tracking.delegate = self;
                self.tracking.mapView  = self.mapView;
                self.tracking.duration = 5.f;
                self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
                [self.tracking execute];
                
            }
            
            
        } else {
            
        }
    }failur:^(NSError *error){
        
    }];
    
    
#endif
    
    
    /* 构建tracking. */
    //    self.tracking = [[Tracking alloc] initWithCoordinates:coordinates count:trackingData.length / sizeof(CLLocationCoordinate2D)];
    
    
    
}

@end
