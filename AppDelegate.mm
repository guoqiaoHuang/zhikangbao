//
//  AppDelegate.m
//  AiKangBao
//
//  Created by ydcq on 15/5/11.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "AppDelegate.h"
#import "LeftViewController.h"
#import "MainViewController.h"
#import "SliderViewController.h"
#import "MLBlackTransition.h"
#import "VideoPlaySDK.h"
#import "RtspClientSDK.h"
#import "LoginViewController.h"
#import "NSString+Extension.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//     [NSThread sleepForTimeInterval:0.5];
//    fir bug hud
     VP_InitSDK();
    [FIR handleCrashWithKey:@"b18a3bac65f8bad148905ff16ba928f6"];
    self.window.backgroundColor=[UIColor colorWithRed:0 green:138.0/255.0 blue:153.0/255.0 alpha:1.0];
    LeftViewController *leftVC=[LeftViewController new];
    MainViewController *mainVC=[MainViewController new];
    [SliderViewController sharedSliderController].LeftVC = leftVC;
    [SliderViewController sharedSliderController].MainVC = mainVC;
    [SliderViewController sharedSliderController].LeftSContentOffset=275;
    [SliderViewController sharedSliderController].LeftContentViewSContentOffset = 90;
   
    [SliderViewController sharedSliderController].LeftSContentScale=0.77;
    [SliderViewController sharedSliderController].LeftSJudgeOffset=160;
    [SliderViewController sharedSliderController].changeLeftView = ^(CGFloat sca, CGFloat transX)
    {
//        leftVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
//        CGAffineTransform ltransS = CGAffineTransformMakeScale(sca, sca);
//        CGAffineTransform ltransT = CGAffineTransformMakeTranslation(transX, 0);
//        CGAffineTransform lconT = CGAffineTransformConcat(ltransT, ltransS);
//        leftVC.view.transform = lconT;
    };
    
    //注册极光
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [APService setupWithOption:launchOptions];
    //    极光链接
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
                        object:nil];
    application.applicationIconBadgeNumber=0;
    
    
    
    
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    //手势返回更新为MLBlackTransition
    [MLBlackTransition validatePanPackWithMLBlackTransitionGestureRecognizerType:MLBlackTransitionGestureRecognizerTypePan];
     NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    if (devicetring) {
        self.window.rootViewController=naviC;
    }else{
        self.window.rootViewController=[LoginViewController new];
    }
    
      return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    
    if (application.applicationState==UIApplicationStateActive) {
        
        NSLog(@"visibleclass %@",self.window.rootViewController.childViewControllers.lastObject);
        NSString *string=[self logDic:userInfo];
        NSDictionary *dic=[NSString parseJSONStringToNSDictionary:string];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"你有一条推送消息" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        
        [alert show];
        
        
    } else{
        SliderViewController *tabVC = (SliderViewController *)self.window.rootViewController;
        NSArray *arr= tabVC.childViewControllers;
      UIViewController *lastVC= ( UIViewController *) self.window.rootViewController.childViewControllers.lastObject;
        NSLog(@"visibleclass %@",self.window.rootViewController.childViewControllers.lastObject);
        
//        MessageDetailViewController *msgDetailVC = [[MessageDetailViewController alloc] init];
//        msgDetailVC.isNotification = YES;
//        msgDetailVC.model = model;
//        [nav2 pushViewController:msgDetailVC animated:YES];
    }

    
    completionHandler(UIBackgroundFetchResultNewData);
}
// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}
- (void)networkDidSetup:(NSNotification *)notification {
    
    NSLog(@"已连接");
    
}

- (void)networkDidClose:(NSNotification *)notification {
    
    NSLog(@"未连接");
    
}

- (void)networkDidRegister:(NSNotification *)notification {
    NSLog(@"%@", [notification userInfo]);
    
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    NSLog(@"已登录");
    
    if ([APService registrationID]) {
        
        NSLog(@"get RegistrationID");
        [self getData:[APService registrationID]];
    }
}
-(void)getData:(NSString *)registrationID{
    
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    
    //    http://www.zhengkang168.com/health/api/message/index/api_key/8bb921fb4623dbb73e1324200f5c28c688f05b07
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/bind_push_user_id/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",devicetring);
    //    NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    //    NSLog(@"用户personID:%@",personID);
        if (!devicetring) {
//            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲,请选择家人！"];
            return;
        }
        NSDictionary *trackingDic=@{
                                    @"push_user_id":registrationID
    
                                    };
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"消息：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            

            
        } else {
//            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
//        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}

-(void)dealloc{
    [self unObserveAllNotifications];
}

- (void)unObserveAllNotifications {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidSetupNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidCloseNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidRegisterNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidLoginNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFNetworkDidReceiveMessageNotification
                           object:nil];
    [defaultCenter removeObserver:self
                             name:kJPFServiceErrorNotification
                           object:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 1) {
        
//        HomeTabBarController *tabVC = (HomeTabBarController *)self.window.rootViewController;
//        BaseNavigationController *nav2 = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
//        NSLog(@"visibleclass %@",nav2.visibleViewController.class);
//        
//        MessageDetailViewController *msgDetailVC = [[MessageDetailViewController alloc] init];
//        msgDetailVC.isNotification = YES;
//        msgDetailVC.model = model;
//        [nav2 pushViewController:msgDetailVC animated:YES];
        AppDelegate *del=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [del.current presentViewController:next animated:YES completion:nil];
//        del.current=[self getCurrentVC];
        BaseNavigationController *basenav=(BaseNavigationController *)[self getCurrentVC];
        UINavigationController *test=[[UINavigationController alloc]initWithRootViewController:[MessageViewController new]];
        SliderViewController *root=(SliderViewController *)self.window.rootViewController;
        
        [root.navigationController.visibleViewController.navigationController pushViewController:[MessageViewController new] animated:YES];
//        [[self getCurrentVC] presentViewController:test animated:YES completion:nil];
    }
    
    
}
//获取当前viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    
    NSLog(@"frontView:%@",frontView);
    id nextResponder = [frontView nextResponder];
    NSLog(@"nextResponder:%@",nextResponder);
    if ([nextResponder isKindOfClass:[UIViewController class]])
    {
        
        NSLog(@"1111");
        result = nextResponder;
        
    }
    
    else{
        
        NSLog(@"2222");
        result = self.window.rootViewController;
    }
    
    return result;
    
}
- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
//      UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    
//    SliderViewController *sliderVC = (SliderViewController *)self.window.rootViewController;
//    if ([SliderViewController sharedSliderController].isleft == YES) {
//        return UIInterfaceOrientationMaskPortrait;
//    }else{
//        UINavigationController *nav = [SliderViewController sharedSliderController].navigationController;
//        NSInteger count = nav.childViewControllers.count;
//        UIViewController *vc = [nav.viewControllers objectAtIndex:count-1];
//        if ([vc isMemberOfClass:NSClassFromString(@"RealPlayViewController")]) {
//            return UIInterfaceOrientationMaskLandscapeRight;
//        }
//    }
    return UIInterfaceOrientationMaskPortrait;
}
@end
