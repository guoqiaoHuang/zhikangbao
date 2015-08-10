//
//  NSFileManager+Search.h
//  golo
//  文件管理类
//  Created by xinguandong on 14-5-6.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Search)

/**
 *  根据文件名，查找当前目录的文件，如果文件名有重复，则生成一个包含当前文件名且不重复的文件名
 *
 *  @param filename 查找的文件名
 *  @param path     查找的文件路径
 *
 *  @return 不重复的文件名
 */
+ (NSString *)nonRepeatFileName:(NSString *)filename withPath:(NSString *)path;
/**
 *  根据文件文件名，获取文件mime类型
 *
 *  @param extName 文件名
 *
 *  @return mime类型字符串
 */
+ (NSString *)getMimeStringByFile:(NSString *)fileName;
/**
 *  获取文件类型
 *
 *  @param mime 文件mime类型
 *
 *  @return 文件类型
 */
+ (NSString *)getFileTypeStringByMime:(NSString *)mime;
/**
 *  文件是否可以发送
 *
 *  @param fileExtName 文件扩展名
 *
 *  @return 
 */
+ (BOOL)isCanSendFileType:(NSString *)fileExtName;
/**
 *  是否是可识别的文件类型
 *
 *  @param fileType
 *
 *  @return
 */
+ (BOOL)isReconizeFileType:(NSString *)fileMime;
@end
