//
//  WYNetTool.m
//  WYTanZi
//
//  Created by sialice on 16/5/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYNetTool.h"

@interface WYNetTool ()

/** 网络管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation WYNetTool

/** 获取单例 */
static WYNetTool *_instance;
+ (instancetype)shareNetTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[WYNetTool alloc] init];
    });
    return _instance;
}

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


// 网络请求
- (void)requestWithType:(WYNetToolType)type urlString:(NSString *)urlStr parameters:(NSDictionary *)parameters success:(requestSucessBlock)sucessBlock failure:(requestFailureBlock)failureBlock {
    
    // AFN回调block
    void(^success)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        sucessBlock(responseObject);
    };
    void(^failure)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        failureBlock(error);
    };
    
    // 网络请求
    if (type == WYNetToolTypeGET) { // get
        [self.manager GET:urlStr parameters:parameters progress:nil success:success failure:failure];
    }else if (type == WYNetToolTypePOST) { // post
        [self.manager POST:urlStr parameters:parameters progress:nil success:success failure:failure];
    }
    
}
















@end
