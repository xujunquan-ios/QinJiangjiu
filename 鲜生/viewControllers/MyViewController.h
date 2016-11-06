//
//  MyViewController.h
//  水果糖
//
//  Created by MacPro on 15-7-7.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "AppUtils.h"
#import "AppDelegate.h"

@class MyViewController;

@protocol MyViewControllerDelegate <NSObject>

@optional

-(void)UIViewControllerBack:(MyViewController *)myViewController;

@end

@interface MyViewController : UIViewController <MyViewControllerDelegate>

-(void)headImageViewCreat;

@property (assign, nonatomic)id <MyViewControllerDelegate>delegate;

-(void)backToRootViewControllerWithType:(NSInteger)type;
- (BOOL) isBlankString:(NSString *)string;
-(void)showAlt:(NSString *)message;
- (BOOL)isTelephone:(NSString *)str;//电话号检测
-(NSString *)md5:(NSString *)inPutText;



@end
