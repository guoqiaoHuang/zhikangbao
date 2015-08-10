//
//  QiujiuViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/28.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "QiujiuViewController.h"
#import "SendHelpViewController.h"
@interface QiujiuViewController ()

@end

@implementation QiujiuViewController
{
    NSArray *valueArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"求救记录";
    self.myTable.tableFooterView=[[UIView alloc]init];
    [self getData];
   
}

-(void)getData{
    
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",warmstring);
    NSString *warmingURL=[NSString stringWithFormat:@"%@/lbs/sos/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",warmingURL);
    NSDictionary *sendDic=@{
                            @"device_id":@"1",
                            
                            };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:warmingURL parameters:sendDic sucess:^(id json){
        NSLog(@"warming：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            valueArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.myTable reloadData];
            
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
    
    return valueArr.count;
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
    BaoJingTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"BaoJingTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic=valueArr[indexPath.row];
    firstCell.createTimeLab.text =[tempDic objectForKey:@"create_time"];
    firstCell.addresslab.text=[tempDic objectForKey:@"address"];
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
