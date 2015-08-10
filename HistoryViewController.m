//
//  HistoryViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/14.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "HistoryViewController.h"
#import "SendHelpViewController.h"
@interface HistoryViewController ()

@end

@implementation HistoryViewController
{
    NSArray *dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"求助记录";
    self.view0.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:252.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.dateLab.textColor=[UIColor cyanColor];
    NSDate *date=[NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-M-d"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    NSLog(@"+++++%@",currentDateStr);
    self.dateLab.text=currentDateStr;
    self.historyTable.tableFooterView=[[UIView alloc]init];
    [self getData];
    UIButton *rightBtn=[[UIButton alloc]init];
    rightBtn.frame=CGRectMake(0, 0, 55, 30);
    [rightBtn setTitle:@"求助" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    
    
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}
-(void)commit:(UIButton *)button{
    [self.navigationController pushViewController:[SendHelpViewController new] animated:YES];
}
-(void)getData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/call/help/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
//    NSDictionary *trackingDic=@{
//                                    @"device_id":@"123456"
//    
//                                    };
[self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"历史记录：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            dataArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.historyTable reloadData];
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
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    HistoryTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"HistoryTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic=dataArr[indexPath.section];
    firstCell.tittleLab.text =[tempDic objectForKey:@"title"];
   firstCell.timeLab.text=[tempDic objectForKey:@"create_time"];
    firstCell.contentLab.text=[tempDic objectForKey:@"content"];
    firstCell.statueLab.text=[tempDic objectForKey:@"status_text"];
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *tempDic=dataArr[indexPath.section];
    DetailHistoryViewController *detailVC=[DetailHistoryViewController new];
    detailVC.historyID=[tempDic objectForKey:@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)rightAction:(UIButton *)sender {
    NSString *current=self.dateLab.text;
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];    [inputFormatter setDateFormat:@"yyyy-M-d"];
    
    NSDate*inputDate = [inputFormatter dateFromString:current];
    
    
    
    //前一天
    NSLog(@"----%@",inputDate);
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:inputDate];
    self.dateLab.text=[inputFormatter stringFromDate:lastDay];

}
- (IBAction)leftAction:(UIButton *)sender {
    NSString *current=self.dateLab.text;
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];    [inputFormatter setDateFormat:@"yyyy-M-d"];
    
    NSDate*inputDate = [inputFormatter dateFromString:current];
    
    
    
    //后一天
    NSLog(@"----%@",inputDate);
    NSDate *lastDay = [NSDate dateWithTimeInterval:+24*60*60 sinceDate:inputDate];
    self.dateLab.text=[inputFormatter stringFromDate:lastDay];

}
@end
