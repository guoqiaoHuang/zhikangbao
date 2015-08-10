//
//  LongDistanceViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/19.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "LongDistanceViewController.h"

@interface LongDistanceViewController ()
{
    NSArray *tittleArr;
    NSArray *imageArr;
}
@end

@implementation LongDistanceViewController
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
    tittleArr=@[@"健康信息查询",@"警报设置",@"健康促进"];
    imageArr=@[@"001.png",@"002.png",@"003.png"];

    self.title=@"远程监控";
    self.longDistanceTable.tableFooterView=[[UIView alloc]init];
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
    LongDistanceTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"LongDistanceTableViewCell" owner:self options:nil]lastObject];
    }
    firstCell.tittle.text =tittleArr[indexPath.section];
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
            //健康信息
        {
           [self.navigationController pushViewController:[HealthInformationViewController new] animated:YES];
        }
            break;
        case 1:
//            报警设置
        {
            [self.navigationController pushViewController:[EarlyWarmingViewController new] animated:YES];
        }
            break;
        case 2:
//            健康促进
        {
            [self.navigationController pushViewController:[WarmingHistoryViewController new] animated:YES];
        }
            break;
        
        default:
            break;
    }
}


@end
