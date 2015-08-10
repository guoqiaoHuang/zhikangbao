//
//  BaseHttpRequest.h
//  Legend
//
//  Created by fuhuiqiang on 15/3/9.
//  Copyright (c) 2015年 frocky. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BaseHttpRequestSucess)(id json);
typedef void (^BaseHttpRequestFailur)(NSError *error);

@interface BaseHttpRequest : NSObject


/*
 
 *网络可达性判断
 
 */
+(int)reachabilityConnectionNetWork;



/**
 *  普通的 get 请求 (默认返回json格式数据)
 *
 *  @param url        接口地址 Url
 *  @param parameters 请求参数
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
+(void)getWithUrl:(NSString *)url  parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur;

/**
 *  普通的 post 请求 (默认返回json格式数据)
 *
 *  @param url        接口地址 Url
 *  @param parameters 请求参数
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
+(void)postWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur;

/**
 *  提交Json的 post 请求 (默认返回json格式数据)
 *
 *  @param url        接口地址 Url
 *  @param parameters 请求参数
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
+(void)postJsonWithUrl:(NSString *)url parameters:(NSDictionary *)parameters sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur;

/**
 *  提交Json的 post 请求 (默认返回json格式数据)
 *
 *  @param url        接口地址 Url
 *  @param parameters 请求参数
 *  @param imageData  图片流
 *  @param sucess     成功后的回调
 *  @param failur     失败后的回调
 */
+(void)postDataWithUrl:(NSString *)url parameters:(NSDictionary *)parameters WithImageData:(NSData *)imageData sucess:(BaseHttpRequestSucess)sucess failur:(BaseHttpRequestFailur)failur;
@end
