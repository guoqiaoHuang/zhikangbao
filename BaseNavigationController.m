//
//  BaseNavigationController.m
//  Legend
//
//  Created by fuhuiqiang on 15/3/6.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:197/255.00 green:0 blue:26/255.00 alpha:1]];
  //  [[UINavigationBar appearance]setBarTintColor: [UIColor colorWithRed:72.0/255.0 green:204.0/255.0 blue:220.0/255.0 alpha:1.0]];
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:248/255.00 green:248/255.0 blue:248/255.00 alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor HexColorSixteen:@"48CCDB"]];

    //设置导航栏字体及颜色
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowColor = [UIColor whiteColor];
    
    //去除title的阴影
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [UIFont boldSystemFontOfSize:20], NSFontAttributeName,
                                              [UIColor whiteColor], NSForegroundColorAttributeName,
                                              shadow, NSShadowAttributeName,
                                              nil];

}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}


@end
