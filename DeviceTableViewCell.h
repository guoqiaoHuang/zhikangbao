//
//  DeviceTableViewCell.h
//  AiKangBao
//
//  Created by ydcq on 15/6/8.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyDeviceViewController;
@interface DeviceTableViewCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIButton *unbind;
@property(weak,nonatomic)NSArray *deviceData;
- (IBAction)unbind:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *jiaren;

@end
