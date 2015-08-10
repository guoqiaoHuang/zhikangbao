//
//  RecordViewController.h
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/13.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "BaseViewController.h"
#import "RecordTableViewCell.h"
#import "DetailViewController.h"
@interface RecordViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *recordTable;

@end
