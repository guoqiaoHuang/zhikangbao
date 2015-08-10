//
//  VedioViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/20.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "VedioViewController.h"

@interface VedioViewController ()
{
    NSArray *vedioArr;
    NSArray *vedioArr2;
    NSDictionary *valueDic;
}
@end

@implementation VedioViewController
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
    vedioArr=@[@"交易记录",@"卡号",@"状态",@"余额"];
//    vedioArr2=@[@"25661164865532",@"深圳市",@"56.5"];
    self.title=@"一卡通";
    self.vedioTable.tableFooterView=[[UIView alloc]init];
    [self getData];
//    [self.vedioTable.delegate tableView:self.vedioTable viewForHeaderInSection:1];
}
-(void)getData{
    NSString *devicetring =[UserInformation sharedUserManager].api_key;
    NSString *bindUrl=[NSString stringWithFormat:@"%@/card/account/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",bindUrl);
//    NSDictionary *trackingDic=@{
//                                @"device_id":self.textfield1.text,
//                                @"person_id":personID
//                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:bindUrl parameters:nil sucess:^(id json){
        NSLog(@"一卡通：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            valueDic=[json objectForKey:@"data"];
            NSString *number=[valueDic objectForKey:@"card_no"];
            NSString *amount=[valueDic objectForKey:@"amount"];
            NSString *statue=[valueDic objectForKey:@"status"];
           vedioArr2 =@[number,statue,amount];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.vedioTable reloadData];
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
    if (section==0) {
        return 1;
    }else{
       return vedioArr.count-1;
    }
    return vedioArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"UIKitCell";
            FirstTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!firstCell) {
                
                firstCell = [[[NSBundle mainBundle] loadNibNamed:@"FirstTableViewCell" owner:self options:nil]lastObject];
            }
            firstCell.tittleLab.text=vedioArr[indexPath.section];
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
            VedioTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (!firstCell) {
                
                firstCell = [[[NSBundle mainBundle] loadNibNamed:@"VedioTableViewCell" owner:self options:nil]lastObject];
            }
            
            firstCell.lab0.text=vedioArr[indexPath.row+1];
            firstCell.lab.text=vedioArr2[indexPath.row];
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
    switch (indexPath.section) {
        case 0:
            //将抗信息
        {
            ConsumptionViewController *consumVC=[ConsumptionViewController new];
            NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
            NSString *bindUrl=[NSString stringWithFormat:@"%@/card/bill/api_key/%@",apiUrl,warmstring];
            NSURL *urls=[NSURL URLWithString:bindUrl];
            consumVC.urls=urls;
            [self.navigationController pushViewController:consumVC animated:YES];
        }
            break;
        case 1:
            //            报警设置
        {
            
        }
            break;
        
            default:
            break;
    }
}


@end
