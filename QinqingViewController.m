//
//  QinqingViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/22.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "QinqingViewController.h"

@interface QinqingViewController ()

@end

@implementation QinqingViewController
{
    NSArray *qingArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"亲情号码";
    self.qinQingTable.tableFooterView=[[UIView alloc]init];
    [self setupRefresh];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(addDevice:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self getData];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    [self.myDeviceTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.qinQingTable addLegendFooterWithRefreshingBlock:^(void){
        // 1.添加假数据
        for (int i = 0; i<5; i++) {
            //        [self.fakeData insertObject:MJRandomData atIndex:0];
        }
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.qinQingTable reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.qinQingTable.footer endRefreshing];
        });
        
    }];
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.qinQingTable addLegendHeaderWithRefreshingBlock:^(void){
        // 1.添加假数据
        for (int i = 0; i<5; i++) {
            //        [self.fakeData addObject:MJRandomData];
        }
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.qinQingTable reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.qinQingTable.header endRefreshing];
        });
        
    }];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    //    [self.myDeviceTable addFooterWithTarget:self action:@selector(footerRereshing)];
}

-(void)getData{
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
            [self.qinQingTable reloadData];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        } else {
             [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
        }
    }failur:^(NSError *error){
        NSLog(@"%@",error.description);
        [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:@"亲，网络不给力哦！"];
    }];

}
-(void)addDevice:(UIButton *)button
{
    [self.navigationController pushViewController:[AddDeviceViewController new] animated:YES];
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
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if(cell == nil)
    //    {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //    }
    QinqingTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"QinqingTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *tempDic=qingArr[indexPath.row];
    firstCell.lab0.text=[tempDic objectForKey:@"relationship"];
    firstCell.lab1.text=[tempDic objectForKey:@"mobile"];
    return firstCell;
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
            //亲情号码
        {
            
        }
            break;
        case 1:
            //            求救通知
        {
            
        }
            break;
        case 2:
            //            历史记录
        {
            
        }
            break;
            
        default:
            break;
    }
}



@end
