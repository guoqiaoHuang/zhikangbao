//
//  HealthInformationViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/15.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "HealthInformationViewController.h"

@interface HealthInformationViewController ()

@end

@implementation HealthInformationViewController
{
    NSArray *array;
    NSArray *valueArr;
    UILabel *lab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"健康信息";
    self.healthTable.tableFooterView=[[UIView alloc]init];
   lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    lab.text=@"最近一次健康检查信息时间是：2012-03-12";
    lab.font=[UIFont  systemFontOfSize:12.0];
    lab.textAlignment=1;
    self.healthTable.tableHeaderView=lab;
    array=@[@"血压",@"脉率",@"血糖",@"血红蛋白",@"血氧饱和度",@"心率"];
    [self getData];
}
-(void)getData{
    
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",warmstring);
    NSString *warmingURL=[NSString stringWithFormat:@"%@/rhm/info/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",warmingURL);
    NSDictionary *sendDic=@{
                            @"person_id":@"1",
                            
                            };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:warmingURL parameters:sendDic sucess:^(id json){
        NSLog(@"健康信息：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            NSDictionary *dic=[json objectForKey:@"data"];
            valueArr=[dic objectForKey:@"info"];
            lab.text=[dic objectForKey:@"datetime"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.healthTable reloadData];
            
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}

#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return array.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    HealthTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"HealthTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic=valueArr[indexPath.row];
    firstCell.label1.text =array[indexPath.row];
    firstCell.label2.text=[tempDic objectForKey:@"value"];
    firstCell.label3.text=[tempDic objectForKey:@"unit"];
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
