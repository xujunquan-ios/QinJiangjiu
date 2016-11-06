//
//  FMNetWorkManager.m
//  FreshMan
//
//  Created by VictorXiong on 15/8/13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "FMNetWorkManager.h"

@implementation FMNetWorkManager


+ (instancetype)sharedInstance
{
    static FMNetWorkManager *NetWork = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NetWork = [[FMNetWorkManager alloc] init];
    });
    return NetWork;
}

- (instancetype)init {
    return [self initWithBaseURL:[NSURL URLWithString:MF_URL_HOST]];
}

- (void)cancelAllHTTPOperationsWithPath:(NSString *)path
{
    [[[FMNetWorkManager sharedInstance] session] getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        [self cancelTasksInArray:dataTasks withPath:path];
        [self cancelTasksInArray:uploadTasks withPath:path];
        [self cancelTasksInArray:downloadTasks withPath:path];
    }];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray withPath:(NSString *)path
{
    for (NSURLSessionTask *task in tasksArray) {
        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
        if (range.location != NSNotFound) {
            [task cancel];
        }
    }
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(NSString *)method
                          parameters:(id)parameters
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure
{
    return [self requestURL:URLString httpMethod:method parameters:parameters timeoutInterval:0 success:success failure:failure];
}

- (NSURLSessionDataTask *)requestURL:(NSString *)URLString
                          httpMethod:(NSString *)method
                          parameters:(id)parameters
                     timeoutInterval:(NSTimeInterval)timeout
                             success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                             failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure
{
    NSURLSessionDataTask *dataTask = [self FMdataTaskWithHTTPMethod:method URLString:URLString parameters:parameters timeoutInterval:timeout success:success failure:failure];
    [dataTask resume];
    return dataTask;
}


- (NSURLSessionDataTask *)FMdataTaskWithHTTPMethod:(NSString *)method
                                         URLString:(NSString *)URLString
                                        parameters:(id)parameters
                                           success:(void (^)(NSURLSessionDataTask *, id))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure
{
    return [self FMdataTaskWithHTTPMethod:method URLString:URLString parameters:parameters timeoutInterval:0 success:success failure:failure];
}

- (NSURLSessionDataTask *)FMdataTaskWithHTTPMethod:(NSString *)method
                                         URLString:(NSString *)URLString
                                        parameters:(id)parameters
                                   timeoutInterval:(NSTimeInterval)timeout
                                           success:(void (^)(NSURLSessionDataTask *, id))success
                                           failure:(void (^)(NSURLSessionDataTask *task, NSError *error, id responseObject))failure
{
    //公共参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"v"] = APP_VERSION;    
    NSLog(@"dic = %@",dic);
    
    NSError *serialError = nil;
    NSMutableURLRequest *urlRequest = [self.requestSerializer requestWithMethod:@"GET" URLString:URLString parameters:dic error:&serialError];
    NSString *theUrl = [urlRequest.URL absoluteString];
    
    NSError *serializationError = nil;
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:theUrl relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    
    NSLog(@"request URL : %@", [[NSURL URLWithString:theUrl relativeToURL:self.baseURL] absoluteString]);
    NSLog(@"request URL : %@", request.URL.absoluteString);
    if (timeout > 0) {
        [request setTimeoutInterval:timeout];
    }
    if (serializationError) {
        if (failure) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError ,nil);
            });
#pragma clang diagnostic pop
        }
        
        return nil;
    }

    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {

        if (error) {
            if (failure) {
                failure(dataTask, error ,responseObject);
            }
        } else {
            if (success) {
                success(dataTask, responseObject);
            }
        }
    }];
    
    return dataTask;
}


@end
