//
//  EarlyWarmingViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "EarlyWarmingViewController.h"

@interface EarlyWarmingViewController ()
{
    NSArray *tittleArr;
    NSArray *danwei;
    NSArray *valueArr;
}
@end

@implementation EarlyWarmingViewController
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
    tittleArr=@[@"体温",@"体重",@"身高"];
    danwei=@[@"℃",@"kg",@"cm"];
    self.title=@"预警设置";
    self.warmingTable.tableFooterView=[[UIView alloc]init];
    [self getData];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
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
//save
-(void)commit:(UIButton *)button{
    [self save];
}
-(void)getData{
    
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",warmstring);
    NSString *warmingURL=[NSString stringWithFormat:@"%@/rhm/setting/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",warmingURL);
    NSString *personid=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    NSDictionary *sendDic=@{
                            @"person_id":personid,
                            
                            };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:warmingURL parameters:sendDic sucess:^(id json){
        NSLog(@"warming：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            valueArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.warmingTable reloadData];
           
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
 
}
-(void)save{
    NSArray *array=  [self.warmingTable visibleCells];
    for (WarmingTableViewCell *cell in array) {
        cell.valueText.text;
    }
    
    NSString *warmstring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",warmstring);
    NSString *warmingURL=[NSString stringWithFormat:@"%@/rhm/setting_save/api_key/%@",apiUrl,warmstring];
    NSLog(@"--%@",warmingURL);
    NSString *personid=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    NSDictionary *sendDic=@{
                            @"person_id":personid,
//                            @"pulse":cells.string1,
//                            @"pressure":cells.string2,
//                            @"diabetes":cells.string3,
                            };
    NSMutableDictionary *dics=[NSMutableDictionary dictionary];
    NSMutableArray *tittle=[NSMutableArray array];
    for (int i=0; i<valueArr.count; i++) {
        NSDictionary *temp=valueArr[i];
        NSString *key=[temp objectForKey:@"name"];
        [tittle addObject:key];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        WarmingTableViewCell *cell = (WarmingTableViewCell *)[self.warmingTable cellForRowAtIndexPath:indexPath];
        NSString *myValue = cell.valueText.text;
        [dics setObject:myValue forKey:key];
    }
    [dics setObject:personid forKey:@"person_id"];
    NSLog(@"11111%@",dics);
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:warmingURL parameters:dics sucess:^(id json){
        NSLog(@"warming save：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            valueArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self getData];
            
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦"];
    }];
    
}

#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return tittleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"UIKitCell";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    WarmingTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"WarmingTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic=valueArr[indexPath.section];
    firstCell.lab1.text=[tempDic objectForKey:@"title"];
    firstCell.valueText.text=[tempDic objectForKey:@"value"];
    firstCell.valueText.tag=indexPath.row;
    firstCell.lab3.text=[tempDic objectForKey:@"unit"];

    return firstCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0;
}
#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return  [textField resignFirstResponder];
}
@end
