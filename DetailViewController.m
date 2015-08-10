//
//  DetailViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/25.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    NSArray *dataArray;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.isBack=YES;
        self.isCancel=NO;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"档案管理";
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
    [self getData];
    self.table.tableFooterView=[[UIView alloc]init];
}
-(void)getData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/person/manage_health/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    NSString *dataString=self.dateLab.text;
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy-M-d"];
    
    NSDate*inputDate = [inputFormatter dateFromString:dataString];
        NSDictionary *trackingDic=@{
                                    @"person_id":@"123456",
                                    @"type":self.type,
                                    @"date":inputDate
                                    };
[self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"档案：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            dataArray=[json objectForKey:@"data"];
            [self.table reloadData];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}
-(void)refreshUI{
    NSDictionary *tempDic1=dataArray[0];
    NSDictionary *tempDic2=dataArray[1];
    self.label0.text=[tempDic1 objectForKey:@"remark"];
    self.lab1.text=[tempDic1 objectForKey:@"value"];
    self.label2.text=[tempDic1 objectForKey:@"unit"];
    
    self.laber21.text=[tempDic2 objectForKey:@"remark"];
    self.lab2.text=[tempDic2 objectForKey:@"value"];
    self.label22.text=[tempDic2 objectForKey:@"unit"];
}
//前一天
- (IBAction)beforeAction:(UIButton *)sender {
    NSString *current=self.dateLab.text;
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];    [inputFormatter setDateFormat:@"yyyy-M-d"];
    
    NSDate*inputDate = [inputFormatter dateFromString:current];
    

    
   //前一天
     NSLog(@"----%@",inputDate);
     NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:inputDate];
    self.dateLab.text=[inputFormatter stringFromDate:lastDay];
    [self getData];
}
//后一天
- (IBAction)afterAction:(UIButton *)sender {
    NSString *current=self.dateLab.text;
    NSDateFormatter *inputFormatter= [[NSDateFormatter alloc] init] ;
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];    [inputFormatter setDateFormat:@"yyyy-M-d"];
    
    NSDate*inputDate = [inputFormatter dateFromString:current];
    
    
    
    //后一天
    NSLog(@"----%@",inputDate);
    NSDate *lastDay = [NSDate dateWithTimeInterval:+24*60*60 sinceDate:inputDate];
    self.dateLab.text=[inputFormatter stringFromDate:lastDay];
    [self getData];
}
#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
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
    DetailRecordTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"DetailRecordTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic1=dataArray[indexPath.row];
    firstCell.lab1.text=[tempDic1 objectForKey:@"remark"];
    firstCell.lab2.text=[tempDic1 objectForKey:@"value"];
    firstCell.lab3.text=[tempDic1 objectForKey:@"unit"];
    
    return firstCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
