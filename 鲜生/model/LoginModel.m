//
//  LoginModel.m
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "LoginModel.h"
#import "FMNetWorkManager.h"
#import "AppUtils.h"
@implementation LoginModel

LoginModel * loginModel = nil;

+ (LoginModel*)shareLoginModel {
    if (loginModel == nil) {
        loginModel = [[LoginModel alloc] init];
    }
    return loginModel;
}


- (void)loginByAccount:(NSString*)phone andPassword:(NSString*)password{
    NSLog(@"account %@ password %@",phone,password);
    NSMutableDictionary* d = [NSMutableDictionary dictionaryWithObjectsAndKeys:phone,@"phone",password,@"pwd", nil];
    [[FMNetWorkManager sharedInstance] requestURL:MF_URL_LOGIN httpMethod:@"POST" parameters:d success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"response%@",responseObject);
        NSMutableDictionary* response = (NSMutableDictionary*)responseObject;
        NSString* status = [response objectForKey:@"status"];
        [[AppUtils shareAppUtils] saveUserId:[response objectForKey:@"token"]];
        [[AppUtils shareAppUtils] saveUserName:[response objectForKey:@"name"]];
        [[AppUtils shareAppUtils] saveId:[response objectForKey:@"uid"]];
        if ([status integerValue] == 1) {
            if ([self.delegate respondsToSelector:@selector(LoginSuccessInData:)]) {
                [self.delegate LoginSuccessInData:@"成功"];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(LoginFailInData:)]) {
                [self.delegate LoginFailInData:[response objectForKey:@"err_msg"]];
            }
        }
       
    }failure:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        NSLog(@"Error: %@", error);
        if ([self.delegate respondsToSelector:@selector(LoginFailInData:)]) {
            [self.delegate LoginFailInData:@"失败信息"];
        }
    }];
    
    return;
}

@end
