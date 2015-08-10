//
//  YKTViewController.m
//  AiKangBao
//
//  Created by 黄国桥 on 15/5/16.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "YKTViewController.h"
#import "VMSNetSDK.h"
@interface YKTViewController ()

@end
@implementation YKTViewController{
    NSArray *valueArr;
     UIActivityIndicatorView *activity;//活动指示器
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
        self.title=@"视频监控";
    self.YKTtable.tableFooterView=[[UIView alloc]init];
    [self getData];
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];//指定进度轮的大小
    //    activity.backgroundColor = [UIColor lightGrayColor];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    //    [homeWebView addSubview:activity];
    activity.frame = CGRectMake(0, 49, ScreenWidth, ScreenHeight-49);
    activity.center=CGPointMake(ScreenWidth/2.0, (ScreenHeight-49)/2.0);
    activity.backgroundColor=[UIColor clearColor];
    activity.hidden=YES;
    [self.view addSubview:activity];
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
        NSLog(@"小区视频：%@,/n%@",json,[json objectForKey:@"data"]);
        if ([BaseHttpRequestResult requestResultInfoBack:json]==0) {
            valueArr=[json objectForKey:@"data"];
            [[CustomMBProgressHUD sharedCustomHUD]showAllTextDialogHud:self.view withTitle:[json objectForKey:@"message"]];
            [self.YKTtable reloadData];
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
    YKTTableViewCell *firstCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!firstCell) {
        
        firstCell = [[[NSBundle mainBundle] loadNibNamed:@"YKTTableViewCell" owner:self options:nil]lastObject];
    }
    NSDictionary *temp=valueArr[indexPath.row];
    firstCell.xiaoquName.text=[temp objectForKey:@"video_name"];
      return firstCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            [self loginTV:indexPath.row];
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3:
            
            break;
        default:
            break;
    }
}
-(void)loginTV:(NSInteger)index{
    NSString *serverAddr = @"http://110.52.103.89:8001";
    serverAddr = [serverAddr uppercaseString];
    if(![serverAddr hasPrefix:@"HTTP://"])
    {
        serverAddr = [NSString stringWithFormat:@"HTTP://%@",serverAddr];
    }
    NSDictionary *temp=valueArr[index];
    NSString *userName = [temp objectForKey:@"video_name"];
    NSString *password = [temp objectForKey:@"video_pwd"];
    [self startLoading];
    dispatch_queue_t aQueue;
    aQueue = dispatch_get_global_queue(0,0);
    dispatch_async(aQueue, ^{
    VMSNetSDK * vmsNetSdk = [VMSNetSDK shareInstance];
    
    
    self.serverInfo = [[CMSPInfo alloc]init];
   

    dispatch_async(dispatch_get_main_queue(), ^{
        
    //    BOOL ret = [vmsNetSdk loginV40:serverAddr toUserName:userName toPassword:password toServInfo:self.serverInfo];
    BOOL ret = [vmsNetSdk login:serverAddr toUserName:userName toPassword:password toLineID:1 toServInfo:self.serverInfo];
        
    if(!ret)
    {[self stopLoading];
        //如果登录不上，可能是新6.x平台，再使用新平台登录方式登录
        ret = [vmsNetSdk loginV40:serverAddr toUserName:userName toPassword:password toServInfo:self.serverInfo];
        if(!ret)
        {
            NSLog(@"login failed ! errno = %d",vmsNetSdk.nLastError);
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"视频登陆失败" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    
    NSLog(@"login sucess! sessonId = %@",self.serverInfo.sessionID);
    //保存登录信息
    [[NSUserDefaults standardUserDefaults] setObject:serverAddr forKey:SERVER_ADDRESS];
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:USER_NAME];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:PASSWORD];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",vmsNetSdk.version] forKey:SERVER_VERSION];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     [self stopLoading];
    ResourceTreeViewController *treeViewController = [[ResourceTreeViewController alloc] initWithNibName:NSStringFromClass([ResourceTreeViewController class]) bundle:nil withServerInfo:self.serverInfo];
    treeViewController.title=self.title;
    //跳转到资源树列表
        
    [self.navigationController pushViewController:treeViewController animated:YES];
    });
    });
    
}
-(void)stopLoading{
    
    [activity stopAnimating];
    activity.hidden=YES;
}
-(void)startLoading{
    activity.hidden=NO;
    [activity startAnimating];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
@end
