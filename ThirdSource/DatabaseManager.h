//
//  DatabaseManager.h
//  SQLiteDemo
//
//  Created by JayWon on 13-9-24.
//  Copyright (c) 2013年 JayWon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject

+(DatabaseManager *)shareInstance;

//插入数据, 添加一个用户
-(BOOL)addUser:(NSString *)searchRecord;
//
////更新一个用户
//-(BOOL)updateUser:(TouristListModel *)model;
//
////删除一个用户
-(BOOL)deleteUser:(NSString *)searchRecord;
//
////查询一个用户
//-(TouristListModel *)findUser:(NSString *)username;
//
//查询所有用户
-(NSMutableArray *)findUsers;

//演示sql注入
//-(BOOL)loginAction:(TouristListModel *)model;

//删除所有用户
-(BOOL)deleteAllUser;
@end
