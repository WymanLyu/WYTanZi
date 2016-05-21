//
//  NSFileManager+WY.m
//  WY-BSBDJ
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "NSFileManager+WY.h"

@implementation NSFileManager (WY)

/** 同步获取缓存文件大小 */
- (CGFloat)getFileSizeForFilePath:(NSString *)filePath {
    // 0.非文件路径则崩溃
    if(!filePath) { // 路径为空
        NSAssert(NO, @"cachePath不能为空");
    }else if(!filePath.pathExtension) { // 不存在则为文件夹
        NSAssert(NO, @"请传入文件路径");
    }
    __block NSUInteger size = 0;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *attrs = [self attributesOfItemAtPath:filePath error:nil];
            // 5.从属性中获取文件大小
            size = [attrs fileSize];
    });
    return size * 1.0;
}

/** 同步获取缓存文件夹 总大小(包含子文件夹) */
- (CGFloat)getAllFileSizeIncludeSubDirectoryInDirectoryPath:(NSString *)cachePath {
    // 0.非文件夹路径则崩溃
    if(!cachePath) { // 不存在路径
        NSAssert(NO, @"cachePath不能为空");
    }else if(cachePath.pathExtension.length != 0) { // 存在则为文件
        NSString *lastComponent = cachePath.lastPathComponent;
        NSString *pattern = @"[.]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [regular matchesInString:lastComponent options:NSMatchingReportProgress range:NSMakeRange(0, lastComponent.length)];
        if (results.count == 1) { // 除去命名中带多个点的路径,带一个.则作为文件处理
            NSAssert(NO, @"请传入文件夹路径");
        }
    }
    // 1.文件管理者
    __block NSUInteger size = 0;
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        // 2.获取路径下的文件数 集合
        NSDirectoryEnumerator *fileEnumerator = [self enumeratorAtPath:cachePath];
        // 3.遍历文件获取全路径
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            // 4.获取文件属性
            NSDictionary *attrs = [self attributesOfItemAtPath:filePath error:nil];
            // 5.从属性中获取文件大小
            size += [attrs fileSize];
        }
    });
    return size * 1.0;
}

/** 同步获取缓存文件夹中文件总大小(不包含子文件夹) */
- (CGFloat)getAllFileSizeExceptSubDirectoryInDirectoryPath:(NSString *)cachePath {
    // 0.非文件夹路径则崩溃
    if(!cachePath) { // 路径不存在
        NSAssert(NO, @"cachePath不能为空");
    }else if(cachePath.pathExtension.length != 0) { // 存在则为文件
        // 正则表达判断
        NSString *lastComponent = cachePath.lastPathComponent;
        NSString *pattern = @"[.]";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *results = [regular matchesInString:lastComponent options:NSMatchingReportProgress range:NSMakeRange(0, lastComponent.length)];
//        WYLog(@"%@", results);
        if (results.count == 1) { // 除去命名中带多个点的路径
            NSAssert(NO, @"请传入文件夹路径");
        }
    }
    // 1.文件管理者
    __block NSUInteger size = 0;
    // 2.定义需要获取的属性字典
    NSArray *resourceKeys = @[NSURLIsDirectoryKey,NSURLLocalizedNameKey, NSURLFileSizeKey];
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        // 3.获取路径下的文件元素 集合
        NSDirectoryEnumerator *fileEnumerator = [self enumeratorAtURL:[NSURL fileURLWithPath:cachePath]
                                                   includingPropertiesForKeys:resourceKeys
                                                                      options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                                 errorHandler:NULL];
        // 4.遍历文件元素获取其属性字典
        for (NSURL *fileURL in fileEnumerator) {
            NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:nil];
            // 4.1.判断是否为文件夹,是则跳过
            if ([resourceValues[NSURLIsDirectoryKey] boolValue]) continue;
            // 4.2.从属性中获取文件大小
            size += [resourceValues[NSURLFileSizeKey] longLongValue];
        }
    });
    return size;
}

/** 异步清除缓存文件夹中所有文件 */
- (void)cleanAllFileIncludeSubDirectoryInDirectoryPath:(NSString *)cachePath WithCompletionBlock:(void(^)(void))completionBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1.获取路径下的文件数 集合
        NSDirectoryEnumerator *fileEnumerator = [self enumeratorAtPath:cachePath];
        // 2.遍历文件获取全路径
        for (NSString *fileName in fileEnumerator) {
            NSString *filePath = [cachePath stringByAppendingPathComponent:fileName];
            // 4.删除文件
            [self removeItemAtPath:filePath error:nil];
        }
        // 3.返回主队列执行block
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}

/** 异步清除缓存文件夹中根文件（保留子文件夹内容） */
- (void)cleanAllFileExceptSubDirectoryInPath:(NSString *)cachePath WithCompletionBlock:(void(^)(void))completionBlock {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1.定义需要获取的属性字典
        NSArray *resourceKeys = @[NSURLIsDirectoryKey, NSURLLocalizedNameKey, NSURLFileSizeKey];
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            // 2.获取路径下的文件元素 集合
            NSDirectoryEnumerator *fileEnumerator = [self enumeratorAtURL:[NSURL fileURLWithPath:cachePath]
                                               includingPropertiesForKeys:resourceKeys
                                                                  options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                             errorHandler:NULL];
            // 3.遍历文件元素获取其属性字典
            for (NSURL *fileURL in fileEnumerator) {
                NSDictionary *resourceValues = [fileURL resourceValuesForKeys:resourceKeys error:nil];
                // 4.1.判断是否为文件夹,是则跳过
                if ([resourceValues[NSURLIsDirectoryKey] boolValue]) continue;
                // 4.2.删除文件
                [self removeItemAtURL:fileURL error:nil];
            }
        });
        // 4.返回主队列执行block
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock();
        });
    });
}


@end
