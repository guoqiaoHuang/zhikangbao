//
//  AddDeviceViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/5.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController
{
    NSArray *qingArr;
    BOOL isHiden;
    NSString *personID;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"增加设备";
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(bind:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.familyTable=[[UITableView alloc]init];
    self.familyTable.delegate=self;
    self.familyTable.dataSource=self;
    self.familyTable.hidden=YES;
    isHiden=YES;
    [self.view addSubview:self.familyTable];
    [self.familyTable mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view1.mas_bottom).with.offset(1);
        make.left.equalTo(self.view1.mas_left).with.offset(0);
                make.right.equalTo(self.view1.mas_right).with.offset(0);
//        make.bottom.equalTo(askLab.mas_top).offset(-1);
        make.size.mas_equalTo(CGSizeMake(self.view1.width, 125));
    }];
    [self familyData];
}
-(void)bind:(UIButton *)button{
    NSLog(@"添加设备");
    [self getData];
}
-(void)getData{
   NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *bindUrl=[NSString stringWithFormat:@"%@/device/bind/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",bindUrl);
        NSDictionary *trackingDic=@{
                                    @"device_sn":self.textfield1.text,
                                    @"person_id":personID
                                    };
    [self.mbHUD showSimple:self.view1];
    [BaseHttpRequest postWithUrl:bindUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"绑定设备：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            
            
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
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
    
    return qingArr.count;
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
//    UITableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!firstCell) {
//        
//        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"QinqingTableViewCell" owner:self options:nil]lastObject];
//    }
//    NSDictionary *tempDic=qingArr[indexPath.row];
//    firstCell.lab0.text=[tempDic objectForKey:@"relationship"];
//    firstCell.lab1.text=[tempDic objectForKey:@"mobile"];
    NSDictionary *tempDic=qingArr[indexPath.row];
    cell.textLabel.text=[tempDic objectForKey:@"relationship"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tempDic=qingArr[indexPath.row];
    personID=[tempDic objectForKey:@"person_id"];
    self.relationLab.text=[tempDic objectForKey:@"relationship"];
    tableView.hidden=YES;
}


- (IBAction)checkAction:(UIButton *)sender {
    if (isHiden) {
        self.familyTable.hidden=NO;
        isHiden=NO;
    } else {
        self.familyTable.hidden=YES;
        isHiden=YES;

    }
}
-(void)familyData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/members/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    ////    NSDictionary *trackingDic=@{
    //                                @"device_id":@"123456"
    //
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"情亲：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            qingArr=[json objectForKey:@"data"];
           
            [self.familyTable reloadData];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
    
}
#pragma textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    return  [textField resignFirstResponder];
}


@end
