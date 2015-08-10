//
//  PositionViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import <AMapSearchKit/AMapSearchAPI.h>
@interface PositionViewController : BaseViewController<UITabBarDelegate,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tab;

@end
