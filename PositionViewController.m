//
//  PositionViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "PositionViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface PositionViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) MAMapView *mapView;
@end

@implementation PositionViewController
{
    AMapSearchAPI *_search;
    NSDictionary *dic;
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self.mapView addObserver:self forKeyPath:@"showsUserLocation" options:NSKeyValueObservingOptionNew context:nil];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=YES;
    self.mapView.userTrackingMode  = MAUserTrackingModeNone;
    
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];

}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title=@"位置";
    [MAMapServices sharedServices].apiKey = @"f945bab7a3c779bd588558ae5bbed96d";
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
//    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    [self.mapView setCompassImage:[UIImage imageNamed:@"compass"]];
    [self.view addSubview:self.mapView];
    
    [self getData];
    //[self mapshow];
}
-(void)getData{
   
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/lbs/place/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    NSLog(@"用户personID:%@",personID);
    if (!personID) {
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲,请选择家人！"];
        return;
    }
        NSDictionary *trackingDic=@{
                                        @"person_id":personID
    
                                        };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"当前位置：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
          
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
//            [self mapshow];
            dic=[json objectForKey:@"data"];
            [self mapshow];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}
-(void)mapshow{
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] initWithSearchKey:@"f945bab7a3c779bd588558ae5bbed96d" Delegate:self];
    NSString *lat=[dic objectForKey:@"lat"];
    NSString *lng=[dic objectForKey:@"lng"];
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location =[AMapGeoPoint locationWithLatitude:lat.doubleValue  longitude:lng.doubleValue];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
   
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = lat.doubleValue;//[addressDto.latitude doubleValue];
    coordinate.longitude = lng.doubleValue;//[addressDto.longitude doubleValue];
//    self.mapView.centerCoordinate = coordinate;
//    self.mapView.region = MACoordinateRegionMake(coordinate ,1000 ,1000);
}
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        CLLocationCoordinate2D coordinate;
        NSString *lat=[dic objectForKey:@"lat"];
        NSString *lng=[dic objectForKey:@"lng"];
        coordinate.latitude = lat.doubleValue ;//[addressDto.latitude doubleValue];
        coordinate.longitude = lng.doubleValue;
        [self addAnnotationWithCooordinate:coordinate];
        [self.mapView setCenterCoordinate:coordinate animated:YES];
    }
}
-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = [dic objectForKey:@"address"];
    annotation.subtitle = @"";
    
    [self.mapView addAnnotation:annotation];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
//        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:0.3];
//        pre.strokeColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.9 alpha:1.0];
//        pre.image = [UIImage imageNamed:@"location.png"];
//        pre.lineWidth = 3;
//        pre.lineDashPattern = @[@6, @3];
//        
//        [self.mapView updateUserLocationRepresentation:pre];
//        
//        view.calloutOffset = CGPointMake(0, 0);
    }
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
      //  annotationView.pinColor                     = [self.annotations indexOfObject:annotation];
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - NSKeyValueObservering

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"showsUserLocation"])
    {
//        NSNumber *showsNum = [change objectForKey:NSKeyValueChangeNewKey];
        
//        self.showSegment.selectedSegmentIndex = ![showsNum boolValue];
    }
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"%ld",item.tag);
    
}
@end
