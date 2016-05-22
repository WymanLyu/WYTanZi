//
//  WYNetTool.h
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    WYNetToolTypeGET, // get请求
    WYNetToolTypePOST, // post请求
} WYNetToolType;

/** 请求成功回调的block */
typedef void(^requestSucessBlock)(id resultData);

/** 请求失败回调的block */
typedef void(^requestFailureBlock)(NSError *error);

@interface WYNetTool : NSObject

/** 获取单例 */
+ (instancetype)shareNetTool;

/** 网络请求 */
- (void)requestWithType:(WYNetToolType)type urlString:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(requestSucessBlock)sucessBlock failure:(requestFailureBlock)failureBlock;
@end
