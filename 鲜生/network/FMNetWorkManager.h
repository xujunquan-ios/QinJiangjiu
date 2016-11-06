//
//  FMNetWorkManager.h
//  FreshMan
//
//  Created by VictorXiong on 15/8/13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "FMMacro_URL.h"
@interface FMNetWorkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

/** 取消制定path的全部网络请求 */
- (void)cancelAllHTTPOperationsWithPath:(NSString *)path;

/** 网络请求(可设置超时时长) */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(NSString *)method
                          parameters:(id)parameters
                     timeoutInterval:(NSTimeInterval)timeout
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure;

/** 网络请求(默认超时时长) */
- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(NSString *)method
                          parameters:(id)parameters
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure;


@end
