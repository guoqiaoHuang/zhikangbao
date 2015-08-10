//
//  MyDeviceViewController.m
//  AiKangBao
//
//  Created by ydcq on 15/6/8.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "AddDeviceViewController.h"
@interface MyDeviceViewController ()

@end

@implementation MyDeviceViewController
{
    NSArray *deviceArr;
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
    self.title=@"我的设备";
    self.myDeviceTable.tableFooterView=[[UIView alloc]init];
//    [self setupRefresh];
    UIButton *rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 55, 30)];
    [rightBtn setTitle:@"绑定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    rightBtn.layer.borderWidth=1.0;
    rightBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    rightBtn.layer.cornerRadius=14.0;
    rightBtn.layer.masksToBounds=YES;
    rightBtn.backgroundColor=[UIColor clearColor];
    [rightBtn addTarget:self action:@selector(addDevice:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getdata];
}
-(void)getdata{
    NSString *devicetring=[[NSUserDefaults standardUserDefaults]objectForKey:@"key"];
    NSString *trackingUrl=[NSString stringWithFormat:@"%@/device/lists/api_key/%@",apiUrl,devicetring];
    NSLog(@"%@",trackingUrl);
    ////    NSDictionary *trackingDic=@{
    //                                @"device_id":@"123456"
    //
    //                                };
    [self.mbHUD showSimple:self.view];
    [BaseHttpRequest postWithUrl:trackingUrl parameters:nil sucess:^(id json){
        NSLog(@"设备：%@,/n%@",json,[json objectForKey:@"message"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            deviceArr=[json objectForKey:@"data"];
            [self.myDeviceTable reloadData];
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
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
//    [self.myDeviceTable addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.myDeviceTable addLegendFooterWithRefreshingBlock:^(void){
        // 1.添加假数据
        for (int i = 0; i<5; i++) {
            //        [self.fakeData insertObject:MJRandomData atIndex:0];
        }
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.myDeviceTable reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myDeviceTable.footer endRefreshing];
        });

    }];
//#warning 自动刷新(一进入程序就下拉刷新)
    [self.myDeviceTable addLegendHeaderWithRefreshingBlock:^(void){
        // 1.添加假数据
        for (int i = 0; i<5; i++) {
            //        [self.fakeData addObject:MJRandomData];
        }
        
        // 2.2秒后刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.myDeviceTable reloadData];
            
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.myDeviceTable.header endRefreshing];
        });

    }];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
//    [self.myDeviceTable addFooterWithTarget:self action:@selector(footerRereshing)];
}
- (void)cancelButtonTapped:(UIButton *)button
{
    [[SliderViewController sharedSliderController]showContentControllerWithModel:@"MainViewController"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return deviceArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UIKitCell";
    DeviceTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"DeviceTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *temp=deviceArr[indexPath.row];
    firstCell.deviceData=deviceArr;
    firstCell.lab1.text=[temp objectForKey:@"device_type"];
    firstCell.lab2.text=[temp objectForKey:@"device_sn"];
    firstCell.unbind.tag=indexPath.row;
    firstCell.jiaren.text=[temp objectForKey:@"relationship"];
    return firstCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *temp=deviceArr[indexPath.row];

    [self.navigationController pushViewController:[AddPhoneViewController new] animated:YES];
    }



@end
