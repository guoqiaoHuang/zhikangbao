//
//  PositionTabBarVieewcontroller.m
//  AiKangBao
//
//  Created by ydcq on 15/5/18.
//  Copyright (c) 2015年 LiuJian. All rights reserved.
//

#import "PositionTabBarVieewcontroller.h"

@interface PositionTabBarVieewcontroller ()
{
    NSArray *tittleArr;
    NSArray *imageArr;
    NSArray *imageSelect;
}
@property(nonatomic,weak) UIButton *selectedBtn;
@end

@implementation PositionTabBarVieewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"位置";
    BaseNavigationController *nav=[[BaseNavigationController alloc]initWithRootViewController:PositionViewController.new];
    BaseNavigationController *nav2=[[BaseNavigationController alloc]initWithRootViewController:Position2ViewController.new];
    BaseNavigationController *nav3=[[BaseNavigationController alloc]initWithRootViewController:Position3ViewController.new];

    self.viewControllers=@[nav,nav2,nav3];
    tittleArr=@[@"实时追踪",@"历史回放",@"报警记录"];
    imageArr=@[@"实时追踪",@"历史",@"求救记录"];
    imageSelect=@[@"实时追踪选中",@"历史回放选中",@"求救记录选中"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    //button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(0, 0, 35, 35);
    //当点击的时候显示为高亮
    //        button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButton;

     float width = ScreenWidth/3.0;
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, 49)];
        btn.backgroundColor = [UIColor clearColor];
        
        [btn setTitle:tittleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:72.0/255.0 green:204/255.0 blue:220.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.titleLabel.textAlignment=1;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        NSLog(@"-----------%@",NSStringFromCGSize(btn.size));
        NSString *imageName = [imageArr objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:imageName];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        NSString *imageSelName = [imageSelect objectAtIndex:i];
        [btn setImage:[UIImage imageNamed:imageSelName] forState:UIControlStateSelected];
        
        CGFloat imageWidth = image.size.width;
        CGFloat imageHeight = image.size.height;
        NSString *title = [tittleArr objectAtIndex:i];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size = [title boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
        CGFloat titleWidth = size.width;
       CGFloat titleHeight = size.height;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-10, (width-imageWidth)/2.0, 0, 0)];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(imageHeight+4, -imageWidth+37, 0, 0)];
    
        
//        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, (width-imageWidth)/2.0, 14, 0)];
//        [btn setTitleEdgeInsets:UIEdgeInsetsMake(34, (width-titleWidth)/2.0-imageWidth, 5, 0)];
        
        //CGFloat right        btn.imageEdgeInsets=UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, )
       // btn.titleEdgeInsets=UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, CGFloat bottom, <#CGFloat right#>)
//        [self.tabbarView addSubview:btn];
        //设置刚进入时,第一个按钮为选中状态
        if (0 == i) {
            btn.selected = YES;
            self.selectedBtn = btn;  //设置该按钮为选中的按钮
        }
        [self.tabBar addSubview:btn];
    }
}
- (void)cancelButtonTapped:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickAction:(UIButton *)btn
{
    
    NSInteger tag = btn.tag;
    
    
    //    if ((tag -100)== 2&&![[user objectForKey:kUserIsLogin]boolValue]) {
    //
    //        NSLog(@"未登录");
    //        LegendLoginController *loginVC = [[LegendLoginController alloc] initWithNibName:@"LegendLoginController" bundle:nil];
    
    //        BaseNavigationController *loginNav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    //self.loginNav要公开，否则跳到二级页面再点击时会崩
    //        [self presentViewController:loginNav animated:YES completion:^{
    //
    //        }];
    
    //    }else{
    
    //1.先将之前选中的按钮设置为未选中
    self.selectedBtn.selected = NO;
    //2.再将当前按钮设置为选中
    btn.selected = YES;
    //3.最后把当前按钮赋值为之前选中的按钮
    self.selectedBtn = btn;
    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
    self.selectedIndex = tag-100;
    //    }
    
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

@end
