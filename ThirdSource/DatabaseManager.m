//
//  DatabaseManager.m
//  SQLiteDemo
//
//  Created by JayWon on 13-9-24.
//  Copyright (c) 2013年 JayWon. All rights reserved.
//

#import "DatabaseManager.h"
#import <sqlite3.h>

@implementation DatabaseManager


+(DatabaseManager *)shareInstance
{
    static DatabaseManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DatabaseManager alloc] init];
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        //1.拷贝工程里的数据库到沙盒路径
        [self copyDBFile];
    }
    return self;
}

-(void)copyDBFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //如果文件不存在才copy
    if (![fileManager fileExistsAtPath:[self dbPath]]) {
//        NSString *srcDbPath = [[NSBundle mainBundle] pathForResource:@"mydatabase" ofType:@"sqlite"];
//        
//        BOOL result = [fileManager copyItemAtPath:srcDbPath toPath:[self dbPath] error:NULL];
//        if (result) {
//            //2.如果拷贝成功就创建表
//            int result = [self createTable];
//            NSLog(@"create table result %d", result);
//        }else{
//            NSLog(@"拷贝数据库失败");
//        }
        [self createTable];
    }
    
}

-(NSString *)dbPath
{
    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @""];
}


-(BOOL)createTable
{
    //数据库对象
    sqlite3 *sqlite3 = nil;
    
    //1.open
    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
//   model.RelatedLine,model.Json
    //2.create
    NSString *sql = @"CREATE TABLE SearchTable    \
    (   \
        searchRecord TEXT NOT NULL PRIMARY KEY\
     );";
    
    char *error = nil;
    int execResult = sqlite3_exec(sqlite3, [sql UTF8String], NULL, NULL, &error);
    if (execResult != SQLITE_OK) {
        NSLog(@"创建数据库失败");
        return NO;
    }

    //3.close
    sqlite3_close(sqlite3);
    
    return YES;
}

//travelLineName,agencyName,minTeamDateAdult,iconUrl
//插入数据, 添加一个用户
-(BOOL)addUser:(NSString *)searchRecord
{
    sqlite3 *sqlite3 = nil;
    
    //1.open
    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }

    
    //2.prepare 编译sql语句
    NSString *sql = @"INSERT INTO SearchTable (searchRecord) VALUES (?);";
    sqlite3_stmt *stmt = nil;
    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
    if (prepareResult != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        return NO;
    }
    
    //3.bind 绑定参数, 第二个参数是 需要绑定的字段在数据库表中的索引位置, 起始索引从1开始
    sqlite3_bind_text(stmt, 1, [searchRecord UTF8String], -1, NULL);
    
    //4.step执行
    int stepResult = sqlite3_step(stmt);
    if (stepResult == SQLITE_ERROR || stepResult == SQLITE_MISUSE) {
        NSLog(@"执行sql语句失败");
        return NO;
    }
    
    //5.finalize
    sqlite3_finalize(stmt);
    
    //6.close
    sqlite3_close(sqlite3);
    
    return YES;
}


////更新一个用户
//-(BOOL)updateUser:(TouristListModel *)model
//{
//    sqlite3 *sqlite3 = nil;
//    
//    //1.open
//    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
//    if (openResult != SQLITE_OK) {
//        NSLog(@"打开数据库失败!");
//        return NO;
//    }
//    
//    //2.prepare 编译sql语句
//    NSString *sql = @"UPDATE UserTable SET travelLineName = ?, agencyName = ?, minTeamDateAdult = ?, iconUrl = ? WHERE username = ?;";
//    sqlite3_stmt *stmt = nil;
//    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
//    if (prepareResult != SQLITE_OK) {
//        NSLog(@"编译sql语句失败");
//        return NO;
//    }
// //travelLineName,agencyName,minTeamDateAdult,iconUrl
//    //3.bind 绑定参数, 第二个参数是 需要绑定的字段在数据库表中的索引位置, 起始索引从1开始
//    sqlite3_bind_text(stmt, 1, [model.travelLineName UTF8String], -1, NULL);
//    sqlite3_bind_text(stmt, 2, [model.agencyName UTF8String], -1, NULL);
//    sqlite3_bind_text(stmt, 3, [model.minTeamDateAdult UTF8String], -1, NULL);
//    sqlite3_bind_int(stmt, 4, model.iconUrl);
//
//    
//    //4.step执行
//    int stepResult = sqlite3_step(stmt);
//    if (stepResult == SQLITE_ERROR || stepResult == SQLITE_MISUSE) {
//        NSLog(@"执行sql语句失败");
//        return NO;
//    }
//    
//    //5.finalize
//    sqlite3_finalize(stmt);
//    
//    //6.close
//    sqlite3_close(sqlite3);
//    
//    return YES;
//}

//删除一个用户
-(BOOL)deleteUser:(NSString *)searchRecord
{
    sqlite3 *sqlite3 = nil;

    //1.open
    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.prepare 编译sql语句
    NSString *sql = @"DELETE FROM SearchTable WHERE searchRecord = ?;";
    sqlite3_stmt *stmt = nil;
    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
    if (prepareResult != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        return NO;
    }
    
    //3.bind
    sqlite3_bind_text(stmt, 1, [searchRecord UTF8String], -1, NULL);
    
    //4.step执行
    int stepResult = sqlite3_step(stmt);
    if (stepResult == SQLITE_ERROR || stepResult == SQLITE_MISUSE) {
        NSLog(@"执行sql语句失败");
        return NO;
    }
    
    //5.finalize
    sqlite3_finalize(stmt);
    
    //6.close
    sqlite3_close(sqlite3);
    
    return YES;
}

//删除所有用户
-(BOOL)deleteAllUser
{
    sqlite3 *sqlite3 = nil;
    
    //1.open
    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return NO;
    }
    
    //2.prepare 编译sql语句
    NSString *sql = @"DELETE  FROM SearchTable;";
    sqlite3_stmt *stmt = nil;
    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
    if (prepareResult != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        return NO;
    }
    
    //3.bind
//    sqlite3_bind_text(stmt, 1, [model.travelLineName UTF8String], -1, NULL);
    
    //4.step执行
    int stepResult = sqlite3_step(stmt);
    if (stepResult == SQLITE_ERROR || stepResult == SQLITE_MISUSE) {
        NSLog(@"执行sql语句失败");
        return NO;
    }
    
    //5.finalize
    sqlite3_finalize(stmt);
    
    //6.close
    sqlite3_close(sqlite3);
    
    return YES;
}

////查询一个用户
//-(TouristListModel *)findUser:(NSString *)username
//{
//    Person *ps = nil;
//    sqlite3 *sqlite3 = nil;
//    
//    //1.open
//    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
//    if (openResult != SQLITE_OK) {
//        NSLog(@"打开数据库失败!");
//        return ps;
//    }
//    
//    
//    //2.prepare 编译sql语句
//    NSString *sql = @"SELECT * FROM UserTable WHERE username = ?;";
//    sqlite3_stmt *stmt = nil;
//    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
//    if (prepareResult != SQLITE_OK) {
//        NSLog(@"编译sql语句失败");
//        return ps;
//    }
//    
//    //3.bind
//    sqlite3_bind_text(stmt, 1, [username UTF8String], -1, NULL);
//    
//    
//    //4.step执行
//    int stepResult = sqlite3_step(stmt);
//    if (stepResult == SQLITE_ROW) {
//        ps = [[[Person alloc] init] autorelease];
//        
//        //从数据库获取数据
//        const char *name = (const char *)sqlite3_column_text(stmt, 0);
//        const char *pwd = (const char *)sqlite3_column_text(stmt, 1);
//        const char *email = (const char *)sqlite3_column_text(stmt, 2);
//        int age = sqlite3_column_int(stmt, 3);
//        
//        ps.username = [NSString stringWithUTF8String:name];
//        ps.password = [NSString stringWithUTF8String:pwd];
//        ps.email = [NSString stringWithUTF8String:email];
//        ps.age = age;
//    }
//    
//    //5.finalize
//    sqlite3_finalize(stmt);
//    
//    //6.close
//    sqlite3_close(sqlite3);
//    
//    return ps;
//}

//查询所有用户
-(NSMutableArray *)findUsers
{
    NSMutableArray *mArr = [NSMutableArray array];
    sqlite3 *sqlite3 = nil;
    
    //1.open
    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
    if (openResult != SQLITE_OK) {
        NSLog(@"打开数据库失败!");
        return mArr;
    }
    
    
    //2.prepare 编译sql语句
    NSString *sql = @"SELECT * FROM SearchTable;";
    sqlite3_stmt *stmt = nil;
    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
    if (prepareResult != SQLITE_OK) {
        NSLog(@"编译sql语句失败");
        return mArr;
    }
    
    //3.step
    while (sqlite3_step(stmt) == SQLITE_ROW) {

        //从数据库获取数据
        const char *search = (const char *)sqlite3_column_text(stmt, 0);
        NSString *searchRecord = [NSString stringWithUTF8String:search];
        [mArr addObject:searchRecord];

    }
    
    //4.finalize
    sqlite3_finalize(stmt);
    
    //5.close
    sqlite3_close(sqlite3);
    
    return mArr;
}

////演示sql注入
//-(BOOL)loginAction:(TouristListModel *)model
//{
//    BOOL loginResult = NO;
//    sqlite3 *sqlite3 = nil;
//    
//    //1.open
//    int openResult = sqlite3_open([[self dbPath] UTF8String], &sqlite3);
//    if (openResult != SQLITE_OK) {
//        NSLog(@"打开数据库失败!");
//        return loginResult;
//    }
//    
//    
//    //2.prepare 编译sql语句
//    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM UserTable WHERE username = '%@' AND password = '%@'", person.username, person.password];
//    
//    sqlite3_stmt *stmt = nil;
//    int prepareResult = sqlite3_prepare(sqlite3, [sql UTF8String], -1, &stmt, NULL);
//    if (prepareResult != SQLITE_OK) {
//        NSLog(@"编译sql语句失败");
//        return loginResult;
//    }
//    
//    //3.step
//    int result = sqlite3_step(stmt);
//    if (result == SQLITE_ROW) {
//        int count = sqlite3_column_int(stmt, 0);
//        if (count > 0) {
//            loginResult = YES;
//        }
//    }
//    
//    //4.finalize
//    sqlite3_finalize(stmt);
//    
//    //5.close
//    sqlite3_close(sqlite3);
//    
//    return loginResult;
//}

@end
