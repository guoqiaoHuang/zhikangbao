//
//  FamilyMermberViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/6/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "FamilyMermberViewController.h"

@interface FamilyMermberViewController ()

@end

@implementation FamilyMermberViewController
{
    NSArray  *memberArr;
    NSIndexPath * index;
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
    self.title=@"家庭成员";
    self.familyTable.tableFooterView=[[UIView alloc]init];
    [self getData];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];

}
//add people
-(void)add:(UIButton *)sender{
    [self.navigationController pushViewController:[AddFamilyViewController new] animated:YES];
}

-(void)getData{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/members/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
    //    NSDictionary *trackingDic=@{
    //                                    @"device_id":@"123456"
    //
    //                                    };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"家庭成员：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            memberArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.familyTable reloadData];
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
    return memberArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UIKitCell";
    FamilyTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"FamilyTableViewCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *temp=memberArr[indexPath.row];
     NSString *personID=[[NSUserDefaults standardUserDefaults]objectForKey:@"person_ID"];
    NSString *person=[NSString stringWithFormat:@"%@",[temp objectForKey:@"person_id"]];
    if ([person isEqualToString:personID]) {
        [firstCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    firstCell.relationLab.text=[temp objectForKey:@"relationship"];
//    firstCell.lab2.text=[temp objectForKey:@"device_sn"];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [firstCell addGestureRecognizer:longPressGr];
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
       
        
    }
    FamilyTableViewCell *cell=(FamilyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
   
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^(void){
       
    }];
    self.shoAdd(cell.relationLab.text);
    NSDictionary *temp=memberArr[indexPath.row];
    [UserInformation sharedUserManager].person_ID=[temp objectForKey:@"person_id"];
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.familyTable];
        index = [self.familyTable indexPathForRowAtPoint:point];
//        if(indexPa == nil) return ;
        //add your code here
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要删除这个家人吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex==0) {
        [self deletPerson];
    }
}
-(void)deletPerson{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSLog(@"用户api-key:%@",devicetring);
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/user/member_del/api_key/%@",apiUrl,devicetring];
    NSLog(@"--%@",trackingUrl);
     NSDictionary *temp=memberArr[index.row];
        NSDictionary *trackingDic=@{
                                        @"person_id":[temp objectForKey:@"person_id"]
    
                                        };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:trackingDic sucess:^(id json){
        NSLog(@"家庭成员：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            memberArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self getData];
        } else {
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];
}
@end
