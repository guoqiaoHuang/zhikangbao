//
//  UIView+Additions.m
//  WXHL_Weibo1.0
//
//  Created by JayWon on 13-7-1.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

-(UITableView *)tableView
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UITableView class]]) {
            
            return (UITableView *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

-(UITableViewCell *)tableViewCell
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UITableViewCell class]]) {
            
            return (UITableViewCell *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}
@end
