//
//  MyDeviceViewController.h
//  AiKangBao
//
//  Created by ydcq on 15/6/8.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "SliderViewController.h"
#import "DeviceTableViewCell.h"
#import "AddPhoneViewController.h"
@interface MyDeviceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *myDeviceTable;
-(void)getdata;
@end
