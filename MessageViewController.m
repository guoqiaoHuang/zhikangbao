//
//  MessageViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/7/29.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
{
    NSArray *messages;
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
    self.title=@"我的消息";
    // Do any additional setup after loading the view from its nib.
    self.message.tableFooterView=[[UIView alloc]init];
    [self getData];
}
-(void)getData{
    
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);

//    http://www.zhengkang168.com/health/api/message/index/api_key/8bb921fb4623dbb73e1324200f5c28c688f05b07
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/message/index/api_key/%@",apiUrl,devicetring];
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
            //            [self mapshow];
            messages=[json objectForKey:@"data"];
            [self.message reloadData];
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
    
    return messages.count;
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
    MessageTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *dic=messages[indexPath.row];
    NSString *read=[dic objectForKey:@"is_read"];
    if (read.intValue==1) {
        firstCell.tittle.textColor=[UIColor lightGrayColor];
        firstCell.content.textColor=[UIColor lightGrayColor];
    }
    firstCell.tittle.text=[dic objectForKey:@"title"];
    firstCell.content.text=[dic objectForKey:@"content"];
    firstCell.time.text=[dic objectForKey:@"create_time"];
    return firstCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=messages[indexPath.row];
    DetailMessageViewController *detailVC=[[DetailMessageViewController alloc]init];
    NSString *strUrl=[dic objectForKey:@"url"];
    detailVC.urls=[NSURL URLWithString:strUrl];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
