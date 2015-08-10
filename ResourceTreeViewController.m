//
//  ResourceTreeViewController.m
//  IVMSDemo
//
//  Created by songqi on 15-4-7.
//  Copyright (c) 2015年 songqi. All rights reserved.
//

#import "ResourceTreeViewController.h"
#import "VMSNetSDK.h"
#import "CustomResourceTableViewCell.h"

@interface ResourceTreeViewController ()<UITableViewDataSource,UITableViewDelegate,CustomResourceTableViewCellDelegate>
{
    IBOutlet UITableView *_resourceTreeTableView; //显示资源树的tableView
    NSMutableArray *_resourceArray; //保存tableView显示的数据
    NSInteger  _currentControlUnitID;
    NSString *_serverAddr;
    NSMutableDictionary *_resourceDict;
    UIActivityIndicatorView *activity;//活动指示器

}
@property(nonatomic,retain)CMSPInfo *serverInfo;
@end

@implementation ResourceTreeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withServerInfo:(CMSPInfo *)serverInfo
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.serverInfo = serverInfo;
        _currentControlUnitID = 0;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];//指定进度轮的大小
    //    activity.backgroundColor = [UIColor lightGrayColor];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    //    [homeWebView addSubview:activity];
    activity.frame = CGRectMake(0, 49, ScreenWidth, ScreenHeight-49);
    activity.center=CGPointMake(ScreenWidth/2.0, (ScreenHeight-49)/2.0);
    activity.backgroundColor=[UIColor clearColor];
    activity.hidden=YES;
    
    [self.view addSubview:activity];
    
    
    _resourceArray = [[NSMutableArray alloc] init];
    _resourceDict = [[NSMutableDictionary alloc]init];
    _resourceTreeTableView.dataSource = self;
    _resourceTreeTableView.delegate = self;
    _resourceTreeTableView.tableFooterView=[[UIView alloc]init];
    _serverAddr = [[NSUserDefaults standardUserDefaults] objectForKey:SERVER_ADDRESS];
    if(!_serverAddr || [_serverAddr length] <= 0)
    {
        NSLog(@"server error");
        _serverAddr = @"";
    }
    [[VMSNetSDK shareInstance] getControlUnitList:_serverAddr toSessionID:self.serverInfo.sessionID toControlUnitID:_currentControlUnitID toNumPerOnce:20 toCurPage:1 toControlUnitList:_resourceArray];
    
    NSMutableArray *curResourceArray  = [NSMutableArray array];
    [curResourceArray addObjectsFromArray:_resourceArray];
    [_resourceDict setObject:curResourceArray forKey:@"0"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 35, 35);
    //当点击的时候显示为高亮
    button.showsTouchWhenHighlighted = NO;
    [button addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;
    self.title=@"视频监控";
//    self.navigationItem.leftBarButtonItem.action = @selector(backBtnClicked:);
}

- (void)backBtnClicked:(id)sender
{
    if([self hasSuperiorCurrResourceArray])
    {
        BOOL ret = [[VMSNetSDK shareInstance] logout:_serverAddr toSessionID:self.serverInfo.sessionID toTokenID:nil];
        if(!ret)
        {
            NSLog(@"logout fail");
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSMutableArray *tmpArray = [_resourceDict objectForKey:[NSString stringWithFormat:@"%d",_currentControlUnitID]];
    if(!tmpArray)
    {
        NSLog(@"error");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [_resourceArray removeAllObjects];
    [_resourceArray  addObjectsFromArray:tmpArray];
    
    [self findSuperior];
    
    [_resourceTreeTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}

//判断当前是否在根目录
- (BOOL)hasSuperiorCurrResourceArray
{
    id data = [_resourceArray objectAtIndex:0];
    if([data isKindOfClass:[CControlUnitInfo class]])
    {
        if(((CControlUnitInfo *)data).parentID == 0)
        {
            return YES;
        }
    }
    else if ([data isKindOfClass:[CRegionInfo class]])
    {
        if(((CRegionInfo *)data).parentID == 0)
        {
            return YES;
        }
    }
    return NO;
}

//查找上级目录，更新_currentControlUnitID
-(void)findSuperior
{
    id data = [_resourceArray firstObject];
    if([data isKindOfClass:[CControlUnitInfo class]])
    {
        NSInteger dataId = ((CControlUnitInfo *)data).parentID;
        for(NSArray *array in [_resourceDict allValues])
        {
            for(id tmpData in array)
            {
                if([tmpData isKindOfClass:[CControlUnitInfo class]])
                {
                    if(((CControlUnitInfo *)tmpData).controlUnitID == dataId)
                    {
                        _currentControlUnitID = ((CControlUnitInfo *)tmpData).parentID;
                        break;
                    }
                }
                else if([tmpData isKindOfClass:[CRegionInfo class]])
                {
                    if(((CRegionInfo *)tmpData).regionID == dataId)
                    {
                        _currentControlUnitID = ((CRegionInfo *)tmpData).regionID;
                        break;
                    }
                }
            }
        }
    }
    else if([data isKindOfClass:[CRegionInfo class]])
    {
        NSInteger dataId = ((CRegionInfo *)data).parentID;
        for(NSArray *array in [_resourceDict allValues])
        {
            for(id tmpData in array)
            {
                if([tmpData isKindOfClass:[CControlUnitInfo class]])
                {
                    if(((CControlUnitInfo *)tmpData).controlUnitID == dataId)
                    {
                        _currentControlUnitID = ((CControlUnitInfo *)tmpData).parentID;
                        break;
                    }
                }
                else if([tmpData isKindOfClass:[CRegionInfo class]])
                {
                    if(((CRegionInfo *)tmpData).regionID == dataId)
                    {
                        _currentControlUnitID = ((CRegionInfo *)tmpData).regionID;
                        break;
                    }
                }
            }
        }
    }

}
- (void)dealloc
{
   
    self.serverInfo = nil;
    if(_serverAddr)
    {
       
        _serverAddr = nil;
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_resourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"test";
    CustomResourceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil)
    {
        if(indexPath.row >= [_resourceArray count])
        {
            return nil;
        }
        
        id data = [_resourceArray objectAtIndex:indexPath.row];
        
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([CustomResourceTableViewCell class]) bundle:nil];
        
        cell = [[nib instantiateWithOwner:self options:nil] lastObject];
        cell.delegate = self;
        [cell setCellContent:data withServerInfo:self.serverInfo];
        cell.fatherDataID = _currentControlUnitID;
        
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomResourceTableViewCell *cell = (CustomResourceTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell getsource];
    
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

#pragma mark - CustomResourceTableViewCellDelegate
//进入下一级资源目录
- (void)cell:(CustomResourceTableViewCell *)cell expandToNextStage:(NSMutableArray *)array
{
//    if(![_resourceDict objectForKey:[NSString stringWithFormat:@"%d",_currentControlUnitID]])
//    {
//        NSMutableArray *tmpArray = [NSMutableArray array];
//        [tmpArray addObjectsFromArray:_resourceArray];
//        [_resourceDict setObject:tmpArray forKey:[NSString stringWithFormat:@"%d",_currentControlUnitID]];
//    }
    if([cell.dataInfo isKindOfClass:[CControlUnitInfo class]])
    {
        _currentControlUnitID = ((CControlUnitInfo *)cell.dataInfo).parentID;
    }
    else if([cell.dataInfo isKindOfClass:[CRegionInfo class]])
    {
        _currentControlUnitID = ((CRegionInfo *)cell.dataInfo).parentID;
    }
    if(![_resourceDict objectForKey:[NSString stringWithFormat:@"%d",_currentControlUnitID]])
    {
        NSMutableArray *tmpArray = [NSMutableArray array];
        [tmpArray addObjectsFromArray:_resourceArray];
        [_resourceDict setObject:tmpArray forKey:[NSString stringWithFormat:@"%d",_currentControlUnitID]];
    }
    [_resourceArray removeAllObjects];
    [_resourceArray addObjectsFromArray:array];
    [_resourceTreeTableView reloadData];
    
}
-(void)stopLoading{
    
    [activity stopAnimating];
    activity.hidden=YES;
}
-(void)startLoading{
    activity.hidden=NO;
    [activity startAnimating];
    
}

//获得资源树viewController对象
- (UIViewController *)fetchFatherViewCtrl
{
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}
@end
