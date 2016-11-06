

//
//  LoginModel.h
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginDelegate <NSObject>
@optional

-(void)LoginSuccessInData:(NSString*)message;
-(void)LoginFailInData:(NSString*)message;

@end

@interface LoginModel : NSObject

- (void)loginByAccount:(NSString*)phone andPassword:(NSString*)password;
+ (LoginModel*)shareLoginModel;
@property(nonatomic,assign)id <LoginDelegate> delegate;

@end


