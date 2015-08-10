//
//  FirstRowTableViewCell.m
//  AiKangBao
//
//  Created by ydcq on 15/6/5.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "FirstRowTableViewCell.h"

@implementation FirstRowTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.openwitch.offImage=[UIImage imageNamed:@"off.jpg"];
    self.openwitch.onImage=[UIImage imageNamed:@"on.jpg"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.on) {
//        kai

    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
     }else{
        [[UIApplication sharedApplication]unregisterForRemoteNotifications];

//         sender.tintColor=[UIColor clearColor];

    }
}
@end
