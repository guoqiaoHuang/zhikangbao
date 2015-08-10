//
//  RecordViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/13.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "RecordViewController.h"

@interface RecordViewController ()
{
    NSArray *recordArr;
    NSArray *imageArr;
    NSArray *typrarr;
}
@end

@implementation RecordViewController
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
    
    recordArr=@[@"血压",@"血脂",@"血糖",@"心电"];
    typrarr=@[@"pressure",@"diabetes",@"tc",@"ecg"];
    self.title=@"档案管理";
    imageArr=@[@"03",@"04",@"02",@"01"];
    self.recordTable.tableFooterView=[[UIView alloc]init];
}

#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return recordArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    RecordTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"RecordTableViewCell" owner:self options:nil]lastObject];
    }
    firstCell.tittleLabel.text=recordArr[indexPath.section];
    firstCell.image.image=[UIImage imageNamed:imageArr[indexPath.section]];
    return firstCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailVC=[DetailViewController new];
    detailVC.type=typrarr[indexPath.section];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
         
    
}
@end
