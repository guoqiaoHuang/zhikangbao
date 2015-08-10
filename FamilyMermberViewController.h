//
//  FamilyMermberViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "FamilyTableViewCell.h"
#import "AddFamilyViewController.h"
#import "UserInformation.h"
typedef void(^ShopAddressBlock) (NSString *shopAddress);
@interface FamilyMermberViewController : BaseViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *familyTable;
@property(nonatomic,copy)ShopAddressBlock shoAdd;
@end
