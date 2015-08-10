//
//  CallViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/19.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "CallViewController.h"
#import "HistoryViewController.h"
@interface CallViewController ()
{
    NSArray *tittleArr;
    NSArray *imageArr;
}
@end

@implementation CallViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=NO;
        self.isCancel=YES;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tittleArr=@[@"亲情号码",@"求救记录",@"求助记录"];
    imageArr=@[@"亲情号码",@"求救通知",@"历史记录"];

    self.title=@"智能呼救";
    self.callTable.tableFooterView=[[UIView alloc]init];

}

#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    callTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"callTableViewCell" owner:self options:nil]lastObject];
    }
    firstCell.tittleLab.text =tittleArr[indexPath.section];
    firstCell.tittleImage.image=[UIImage imageNamed:imageArr[indexPath.section]];
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            //亲情号码
        {
            [self.navigationController pushViewController:[QinqingViewController new] animated:YES];
        }
            break;
        case 1:
            //            求救通知
        {
            [self.navigationController pushViewController:[QiujiuViewController new] animated:YES];
        }
            break;
        case 2:
            //            历史记录
        {
            [self.navigationController pushViewController:[HistoryViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
