//
//  GenerateViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/5.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "GenerateViewController.h"
#import "SliderViewController.h"
@interface GenerateViewController ()

@end

@implementation GenerateViewController
{
    NSArray *generateArr;
}
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
    self.title=@"通用设备";
    generateArr=@[@"消息推送",@"密码修改"];//,@"清除缓存",@"检测新版本",@"意见反馈"];
    self.generateTable.tableFooterView=[[UIView alloc]init];
}
- (void)cancelButtonTapped:(UIButton *)button
{
    [[SliderViewController sharedSliderController]showContentControllerWithModel:@"MainViewController"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }else{
        return generateArr.count-1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"UIKitCell";
            FirstRowTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!firstCell) {
                
                firstCell = [[[NSBundle mainBundle] loadNibNamed:@"FirstRowTableViewCell" owner:self options:nil]lastObject];
            }
            firstCell.label.text=generateArr[indexPath.section];
            return firstCell;
        }
            break;
        case 1:
        {
            static NSString *CellIdentifier = @"UIKitCell";
            //
            //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            //    if(cell == nil)
            //    {
            //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            //    }
            SettingTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!firstCell) {
                
                firstCell = [[[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil]lastObject];
            }
            firstCell.label.text=generateArr[indexPath.row+1];
            if (indexPath.row==1) {
                firstCell.image.image=[UIImage imageNamed:@"爱康宝-60.png"];
            }
            
            return firstCell;
            break;
            
        }
        default:
            break;
    }
    
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 12.0;
    } else {
        return 20.0;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section=indexPath.section;
    switch (section) {
        case 0:
            
            break;
        case 1:
          
            [self.navigationController pushViewController:[ModifyViewController new] animated:YES];
            break;
        default:
            break;
    }
    
}



@end
