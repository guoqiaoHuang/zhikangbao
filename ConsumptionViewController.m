//
//  ConsumptionViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/20.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "ConsumptionViewController.h"

@interface ConsumptionViewController ()

@end

@implementation ConsumptionViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        self.isBack=YES;
//        self.isCancel=NO;
//        
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title=@"消费记录";
    self.consumptionTable.tableFooterView=[[UIView alloc]init];
//   / [self getData];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.urls];
    self.consumption.scalesPageToFit = YES;
    [self.consumption loadRequest:request];
}
-(void)getData{
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *bindUrl=[NSString stringWithFormat:@"%@/card/bill/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",bindUrl);
    //    NSDictionary *trackingDic=@{
    //                                @"device_id":self.textfield1.text,
    //                                @"person_id":personID
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:bindUrl parameters:nil sucess:^(id json){
        NSLog(@"账单记录：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
//            [self.vedioTable reloadData];
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
    
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
//    callTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!firstCell) {
//        
//        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"callTableViewCell" owner:self options:nil]lastObject];
//    }
//    firstCell.tittleLab.text =tittleArr[indexPath.section];
//    firstCell.tittleImage.image=[UIImage imageNamed:@"默认头像.png"];
    cell.textLabel.text=@"asdsa";
    return cell;
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
            //将抗信息
        {
            
        }
            break;
        case 1:
            //            报警设置
        {
            
        }
            break;
        case 2:
            //            健康促进
        {
            
        }
            break;
            
        default:
            break;
    }
}

@end
