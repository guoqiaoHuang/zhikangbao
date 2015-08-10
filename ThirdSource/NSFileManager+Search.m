//
//  NSFileManager+Search.m
//  golo
//
//  Created by administrator on 14-5-6.
//  Copyright (c) 2014年 LAUNCH. All rights reserved.
//

#import "NSFileManager+Search.h"

@implementation NSFileManager (Search)

+ (NSString *)nonRepeatFileName:(NSString *)filename withPath:(NSString *)path
{
    
    return @"";
}

+ (NSString *)getMimeStringByFile:(NSString *)fileName
{
    if (fileName == nil)
    {
        return @"";
    }
    
    NSString *extname = [[[fileName lowercaseString] componentsSeparatedByString:@"."] lastObject];
    NSDictionary *fileMimeDictionary = @{@"pdf"     :@"application/pdf",    //常用文档
                                         @"txt"     :@"image/plain",
                                         @"rtf"     :@"application/rtf",
                                         @"htm"     :@"text/html",
                                         @"html"    :@"text/html",
                                         //Microsoft文档
                                         @"doc"     :@"application/msword",
                                         @"xls"     :@"application/msexcel",
                                         @"ppt"     :@"application/mspowerpoint",
                                         @"docx"    :@"application/msword",
                                         @"xlsx"    :@"application/msexcel",
                                         @"pptx"    :@"application/mspowerpoint",
                                         //视频
                                         @"mp4"     :@"video/mp4",
                                         @"mpg4"    :@"video/mp4",
                                         @"rm"      :@"audio/x-pn-realaudio",
                                         @"avi"     :@"video/x-msvideo",
                                         @"mov"     :@"video/quicktime",
                                         //音频
                                         @"mp3"     :@"audio/mpeg",
                                         @"wav"     :@"audio/x-wav",
                                         @"amr"     :@"audio/amr",
                                         //图像
                                         @"gif"     :@"image/gif",
                                         //@"png"     :@"image/png",
                                         @"jpg"     :@"image/jpeg",
                                         @"jpeg"    :@"image/jpeg"};
    if ([fileMimeDictionary objectForKey:extname]) {
        return [fileMimeDictionary objectForKey:extname];
    }
    return @"";
}

+ (NSString *)getFileTypeStringByMime:(NSString *)mime
{
    if (mime == nil)
    {
        return @"";
    }
    
    NSDictionary *fileMimeDictionary = @{@"Pdf"     :@"application/pdf",    //常用文档
                                         @"Txt"     :@"image/plain",
                                         @"rtf"     :@"application/rtf",
                                         @"htm"     :@"text/html",
                                         @"html"    :@"text/html",
                                         //Microsoft文档
                                         @"Word"    :@"application/msword",
                                         @"Excel"   :@"application/msexcel",
                                         @"PPT" :@"application/mspowerpoint",
                                         @"Word"    :@"application/msword",
                                         @"Excel"    :@"application/msexcel",
                                         @"PPT"    :@"application/mspowerpoint",
                                         //视频
                                         @"mp4"     :@"video/mp4",
                                         @"mpg4"    :@"video/mp4",
                                         @"rm"      :@"audio/x-pn-realaudio",
                                         @"avi"     :@"video/x-msvideo",
                                         @"mov"     :@"video/quicktime",
                                         //音频
                                         @"mp3"     :@"audio/mpeg",
                                         @"wav"     :@"audio/x-wav",
                                         @"amr"     :@"audio/amr",
                                         //图像
                                         @"gif"     :@"image/gif",
                                         //@"png"     :@"image/png",
                                         @"jpg"     :@"image/jpeg",
                                         @"jpeg"    :@"image/jpeg"};
    
    NSArray *mimeArray = [fileMimeDictionary allKeysForObject:mime];
    if (mimeArray)
    {
        return [mimeArray firstObject];
    }
    return @"";
}

+ (BOOL)isCanSendFileType:(NSString *)fileExtName
{
    BOOL flag = NO;
    NSArray *fileTypeArray = @[@"pdf", @"txt", @"rtf", @"htm", @"html",
                               @"doc", @"xls", @"ppt", @"docx", @"xlsx", @"pptx",
                               //视频
                               @"mp4" , @"mpg4", @"rm"  , @"avi" , @"mov",
                               //音频
                               @"mp3" , @"wav" , @"amr" ,
                               //图像
                               @"gif" , @"jpg" , @"jpeg"];
    
    if ([fileTypeArray containsObject:fileExtName])
    {
        flag = YES;
    }
        
    return flag;
}

+ (BOOL)isReconizeFileType:(NSString *)fileMime
{
    BOOL isReconize = NO;
    NSDictionary *fileMimeDictionary = @{@"pdf"     :@"application/pdf",    //常用文档
                                         @"txt"     :@"image/plain",
                                         @"rtf"     :@"application/rtf",
                                         @"htm"     :@"text/html",
                                         @"html"    :@"text/html",
                                         //Microsoft文档
                                         @"doc"     :@"application/msword",
                                         @"xls"     :@"application/msexcel",
                                         @"ppt"     :@"application/mspowerpoint",
                                         @"docx"    :@"application/msword",
                                         @"xlsx"    :@"application/msexcel",
                                         @"pptx"    :@"application/mspowerpoint",
                                         //视频
                                         @"mp4"     :@"video/mp4",
                                         @"mpg4"    :@"video/mp4",
                                         @"rm"      :@"audio/x-pn-realaudio",
                                         @"avi"     :@"video/x-msvideo",
                                         @"mov"     :@"video/quicktime",
                                         //音频
                                         @"mp3"     :@"audio/mpeg",
                                         @"wav"     :@"audio/x-wav",
                                         @"amr"     :@"audio/amr",
                                         //图像
                                         @"gif"     :@"image/gif",
                                         //@"png"     :@"image/png",
                                         @"jpg"     :@"image/jpeg",
                                         @"jpeg"    :@"image/jpeg"};
    if ([[fileMimeDictionary allValues] containsObject:fileMime])
    {
        isReconize = YES;
    }
    return isReconize;
}
@end
