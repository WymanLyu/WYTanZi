//
//  NSFileManager+WY.h
//  WY-BSBDJ
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (WY)

#pragma mark - 文件大小
/**
*  同步获取缓存文件大小
*
*  @param filePath 文件路径字符串
*
*  @return 文件总大小
*/
- (CGFloat)getFileSizeForFilePath:(NSString *)filePath;

/**
 *  同步获取缓存文件夹 总大小(不包含子文件夹)
 *
 *  @param cachePath 文件夹路径字符串
 *
 *  @return 文件夹总大小（不含子文件夹大小）
 */
- (CGFloat)getAllFileSizeExceptSubDirectoryInDirectoryPath:(NSString *)cachePath;


/**
 *  同步获取缓存文件夹中文件总大小(包含子文件夹)
 *
 *  @param cachePath 文件夹路径字符串
 *
 *  @return 文件夹总大小（含子文件夹大小）
 */
- (CGFloat)getAllFileSizeIncludeSubDirectoryInDirectoryPath:(NSString *)cachePath;

#pragma mark - 文件删除
/**
 *  异步清除缓存文件夹中所有文件
 *
 *  @param cachePath       文件夹路径字符串
 *  @param completionBlock 删除完后在主线程回调的block
 */
- (void)cleanAllFileIncludeSubDirectoryInDirectoryPath:(NSString *)cachePath WithCompletionBlock:(void(^)(void))completionBlock;

/**
 *  异步清除缓存文件夹中根文件（保留子文件夹内容）
 *
 *  @param cachePath       文件夹路径字符串
 *  @param completionBlock 删除完后在主线程回调的block
 */
- (void)cleanAllFileExceptSubDirectoryInPath:(NSString *)cachePath WithCompletionBlock:(void(^)(void))completionBlock;

@end
