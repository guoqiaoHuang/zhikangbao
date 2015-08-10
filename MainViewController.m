
//
//  MainViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "FamilyMermberViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view0.backgroundColor=[UIColor HexColorSixteen:@"48ccdb"];
    self.positionLab1.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.callLab2.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.recordLab1.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.shipinLab2.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.farLab1.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.yktLab.textColor=[UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
    self.view.backgroundColor=[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    self.biaoshi.layer.cornerRadius=4.5;
    self.biaoshi.layer.masksToBounds=YES;
    [self getData];
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSDictionary *dicsss=@{NSFontAttributeName: font};
    NSString *text = @"这是一个测试！！时发生发勿忘我勿忘我勿忘我勿忘我勿忘我阿阿阿阿阿阿阿阿阿阿阿阿阿啊0000000什顿。。。dsfds第三方士大夫第三方第三方over";
    UILabel *la=[[UILabel alloc]init];
    la.text=text;
    la.numberOfLines=0;
    CGSize constraint = CGSizeMake(300, 20000.0f);
    

   CGSize size = [text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:dicsss context:nil].size;
    
//    NSString *path = [NSString stringWithFormat:@"http://www.baidu.com.cn"];
//    NSURL *url = [NSURL URLWithString:path];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        NSLog(@"=====%@,%@",dic,response);
//    }];

    
    
    
    NSLog(@"%f====%f",size.width,size.height);
    la.frame=CGRectMake(10, 20, size.width, size.height+20);
    la.center=self.view.center;
//    [self.view addSubview:la];
}
-(void)getData{
    
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    
    //    http://www.zhengkang168.com/health/api/message/unread/api_key/8bb921fb4623dbb73e1324200f5c28c688f05b07
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/message/unread/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    //    NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    //    NSLog(@"用户personID:%@",personID);
    //    if (!personID) {
    //        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲,请选择家人！"];
    //        return;
    //    }
    //    NSDictionary *trackingDic=@{
    //                                @"person_id":personID
    //
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"消息：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            NSDictionary *temp=[json objectForKey:@"data"];
            NSString *count=[temp objectForKey:@"count"];
            LeftViewController *left=[LeftViewController new];
            left.message=(int)count.intValue;
            if (count.intValue>0) {
                self.biaoshi.hidden=NO;
            }
            
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}

-(void)updateViewConstraints
{
    [super updateViewConstraints];
    self.vew1Height.constant=110* ScreenWidth/320;
    self.view2Height.constant=110* ScreenWidth/320;
    self.view3Height.constant=110* ScreenWidth/320;
    self.scHeight.constant=128* ScreenWidth/320;
    
}
- (IBAction)showLeft:(UIButton *)sender {
   [[SliderViewController sharedSliderController]showLeftViewController];
}
//档案管理
- (IBAction)record:(UIButton *)sender {
    RecordViewController *recordVC=[RecordViewController new];
    BaseNavigationController *recordNav=[[BaseNavigationController alloc]initWithRootViewController:recordVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;//@"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [recordNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:recordNav animated:NO completion:^(void){
        
    }];
}
//一卡通
- (IBAction)yktAction:(UIButton *)sender {
    VedioViewController *vedioVC=[VedioViewController new];
    BaseNavigationController *vedioNav=[[BaseNavigationController alloc]initWithRootViewController:vedioVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionReveal;//@"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [vedioNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:vedioNav animated:NO completion:^(void){
        
    }];

}
//位置
- (IBAction)positionAction:(UIButton *)sender {
   
    PositionTabBarVieewcontroller *positionVC=[[PositionTabBarVieewcontroller alloc]initWithNibName:@"PositionTabBarVieewcontroller" bundle:nil];
    BaseNavigationController *positionNav=[[BaseNavigationController alloc]initWithRootViewController:positionVC];
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"pageCurl";
        animation.subtype = kCATransitionFromLeft;
      //  [self.view.window.layer addAnimation:animation forKey:nil];
//    [positionNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication];
//    SliderViewController *sliderVC=(SliderViewController *)app.window.rootViewController;
//    [self presentViewController:positionNav animated:NO completion:^(void){
//        
//    }];
    [self.view.window.rootViewController presentViewController:positionNav
                                                     animated:YES completion:nil];
    

}
//远程监控
- (IBAction)longDistanceAction:(UIButton *)sender {
    LongDistanceViewController *longDistanceVC=[[LongDistanceViewController alloc]initWithNibName:@"LongDistanceViewController" bundle:nil];
    BaseNavigationController *longDistanceNav=[[BaseNavigationController alloc]initWithRootViewController:longDistanceVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    //  [self.view.window.layer addAnimation:animation forKey:nil];
    //    [positionNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication];
    //    SliderViewController *sliderVC=(SliderViewController *)app.window.rootViewController;
    [self presentViewController:longDistanceNav animated:NO completion:^(void){
        NSLog(@"dsd");
    }];

}
//智能呼叫
- (IBAction)callAction:(UIButton *)sender {
    CallViewController *callVC=[[CallViewController alloc]initWithNibName:@"CallViewController" bundle:nil];
    BaseNavigationController *callNav=[[BaseNavigationController alloc]initWithRootViewController:callVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    //  [self.view.window.layer addAnimation:animation forKey:nil];
    //    [positionNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication];
    //    SliderViewController *sliderVC=(SliderViewController *)app.window.rootViewController;
    [self presentViewController:callNav animated:NO completion:^(void){
        
    }];
}
//视屏监控
- (IBAction)vedioAction:(UIButton *)sender {
    YKTViewController *yktVC=[[YKTViewController alloc]initWithNibName:@"YKTViewController" bundle:nil];
    BaseNavigationController *yktNav=[[BaseNavigationController alloc]initWithRootViewController:yktVC];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"pageCurl";
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [yktNav setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:yktNav animated:NO completion:^(void){
        
    }];

}
//查看家庭成员
- (IBAction)rightAction:(UIButton *)sender {
//    MyDeviceViewController *deviceVC=[MyDeviceViewController new];
//    //            [self.navigationController pushViewController:loginVC animated:YES];
//    BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:deviceVC];
//    [self presentViewController:NAV animated:YES completion:^(void){
//        
//    }];
    FamilyMermberViewController *deviceVC=[FamilyMermberViewController new];
    //            [self.navigationController pushViewController:loginVC animated:YES];
    BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:deviceVC];
    [self presentViewController:NAV animated:YES completion:^(void){
        
    }];
    deviceVC.shoAdd=^(NSString *shopAddress){
        
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:shopAddress];
    };
}
@end
