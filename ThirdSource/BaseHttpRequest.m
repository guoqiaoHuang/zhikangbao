//
//  BaseHttpRequest.m
//  Legend
//
//  Created by fuhuiqiang on 15/3/9.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import "BaseHttpRequest.h"
//#import "Reachability.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
//#import "SellerLegend.pch"


@implementation BaseHttpRequest

+(int)reachabilityConnectionNetWork
{
//    Reachability *connectionNetWork = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    int status = [connectionNetWork currentReachabilityStatus];
    return 0;
}

+(void)getWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur
{
    // 1.创建GET请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
    
    // 设置超时时间
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    mgr.requestSerializer.timeoutInterval = 30.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kHTTPSessionCookies]];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in arcCookies){
//        [cookieStorage setCookie: cookie];
//    }
    
    [mgr GET:url parameters:parameters
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (sucess) {
             
             //获取cookies,保存到本地
//             NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//             for (NSHTTPCookie *cookie in cookies) {
//                 NSLog(@"Block cookie: %@", cookie);
//             }
//             NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//             [defaults setObject: cookiesData forKey: kHTTPSessionCookies];
//             [defaults synchronize];
             
             sucess(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failur) {
             failur(error);
            }
     }];
}

+(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur
{
    // 1.创建POST请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
//    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    // 开启网络指示器
    [[AFNetworkActivityIndicatorManager sharedManager]setEnabled:YES];
       // 设置超时时间
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    mgr.requestSerializer.timeoutInterval = 30.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kHTTPSessionCookies]];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in arcCookies){
//        [cookieStorage setCookie: cookie];
//    }
    // 2.发送请求
     [mgr POST:url parameters:parameters
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if (sucess) {
//              NSLog(@"------%@",responseObject);
              //获取cookies,保存到本地
//              NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];\[NSHTTPCookieStorage sharedHTTPCookieStorage] 
//              for (NSHTTPCookie *cookie in cookies) {
//                  NSLog(@"Block cookie: %@", cookie);
//              }
//              NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//              [defaults setObject: cookiesData forKey: kHTTPSessionCookies];
//              [defaults synchronize];
          
              sucess(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failur) {
              failur(error);
              
          }
      }];
   
//    NSLog(@"----%@",mgr);

}

+(void)postJsonWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur
{
    // 1.创建POST请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    //设置cookie
//    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:kHTTPSessionCookies]];
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in arcCookies){
//        [cookieStorage setCookie: cookie];
//    }
    
    // 2.发送请求
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error: &error];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:tempJsonData];
    
    
    NSOperation *operation =
    [mgr HTTPRequestOperationWithRequest:request
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     if (sucess) {
                                         
                                         //获取cookies,保存到本地
//                                         NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//                                         for (NSHTTPCookie *cookie in cookies) {
//                                             NSLog(@"Block cookie: %@", cookie);
//                                         }
//                                         NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
//                                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                         [defaults setObject: cookiesData forKey: kHTTPSessionCookies];
//                                         [defaults synchronize];
                                         
                                         sucess(responseObject);
                                     }
                                 }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                                     if (failur) {
                                     failur(error);
                                     }
                                 }];
    
    [mgr.operationQueue addOperation:operation];
}

+(void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters WithImageData:(NSData *)imageData sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur
{
    
    // 1.创建POST请求
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
    //设置cookie
    NSArray *arcCookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@""]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in arcCookies){
        [cookieStorage setCookie: cookie];
    }

    [mgr POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData :imageData name:@"file" fileName:@"file.png" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucess) {
            sucess(responseObject);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failur) {
            failur(error);
        }
    }];
 
}
@end
