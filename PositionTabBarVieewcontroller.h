//
//  PositionTabBarVieewcontroller.h
//  AiKangBao
//
//  Created by ydcq on 15/5/18.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PositionViewController.h"
#import "Position3ViewController.h"
#import "Position2ViewController.h"
@interface PositionTabBarVieewcontroller : UITabBarController
@property (weak, nonatomic) IBOutlet UITabBar *positionTab;
@property (weak, nonatomic) IBOutlet UITabBarItem *item1;
@property (weak, nonatomic) IBOutlet UITabBarItem *item2;
@property (weak, nonatomic) IBOutlet UITabBarItem *item3;

@end
