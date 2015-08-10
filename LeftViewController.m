//
//  LeftViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/12.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()
{
    NSArray *tittleArr;
    NSArray *imageArr;
}
@end

@implementation LeftViewController
@synthesize message;
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"asssdfsf:%@",NSStringFromCGRect(self.view.frame));
    [self getData];
    self.navigationController.navigationBarHidden=YES;
    self.headImage.layer.cornerRadius=self.headImage.width/2;
    self.headImage.layer.borderWidth=4.0;
    self.headImage.layer.borderColor=[UIColor colorWithRed:114.0/255.0 green:201.0/255.0 blue:194.0/255.0 alpha:1.0].CGColor;
    self.headImage.layer.masksToBounds=YES;
    tittleArr=@[@"我的设备",@"我的消息",@"通用设置",@"退出"];
    imageArr=@[@"我的设备",@"消息",@"通用设备",@"退出"];
    self.menuTable.tableFooterView=[[UIView alloc]init];
    self.menuTable.backgroundColor=[UIColor brownColor];
    self.menuTable.separatorColor=[UIColor clearColor];
    self.menuTable.backgroundColor=[UIColor clearColor];
    self.view.backgroundColor=[UIColor colorWithRed:0 green:138.0/255.0 blue:153.0/255.0 alpha:1.0];
}
-(void)getData{
    
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    
    //    http://www.zhengkang168.com/health/api/message/unread/api_key/8bb921fb4623dbb73e1324200f5c28c688f05b07
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/message/unread/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    //    NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    //    NSLog(@"用户personID:%@",personID);
    //    if (!personID) {
    //        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲,请选择家人！"];
    //        return;
    //    }
    //    NSDictionary *trackingDic=@{
    //                                @"person_id":personID
    //
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"消息：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            NSDictionary *temp=[json objectForKey:@"data"];
            NSString *count=[temp objectForKey:@"count"];
            self.message=count.intValue;
            [self.menuTable reloadData];
            
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *nickName=[[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    self.nickLable.text=[NSString stringWithFormat:@"昵称：%@",nickName];
//    NSString *add=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernamess"];
//    self.addressLabel.text=[NSString stringWithFormat:@"地址：%@",add];
}
#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
       return tittleArr.count;
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
    LeftTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"LeftTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row==1&&self.message>1) {
        firstCell.xiaoxi.hidden=NO;
    }
    firstCell.funcLabel.text=tittleArr[indexPath.row];
   firstCell.funcImage.image=[UIImage imageNamed:imageArr[indexPath.row]];
    return firstCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            MyDeviceViewController *deviceVC=[MyDeviceViewController new];
            //            [self.navigationController pushViewController:loginVC animated:YES];
            BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:deviceVC];
            [self presentViewController:NAV animated:YES completion:^(void){
                
            }];

        }
            break;
        case 1:
        {
            MessageViewController *deviceVC=[MessageViewController new];
            //            [self.navigationController pushViewController:loginVC animated:YES];
            BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:deviceVC];
            [self presentViewController:NAV animated:YES completion:^(void){
                
            }];

        }
            break;
        case 2:
        {
            GenerateViewController *generateVC=[GenerateViewController new];
            //            [self.navigationController pushViewController:loginVC animated:YES];
            BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:generateVC];
            [self presentViewController:NAV animated:YES completion:^(void){
                
            }];
        }
            break;
        case 3:
        {
            LoginViewController *loginVC=[LoginViewController new];
//            [self.navigationController pushViewController:loginVC animated:YES];
            BaseNavigationController *NAV=[[BaseNavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:NAV animated:YES completion:^(void){
                
            }];
        }
            break;
        
        default:
            break;
    }
}
@end
