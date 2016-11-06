//
//  AppUtils.h
//  鲜生
//
//  Created by liu.wei on 8/20/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "GoodModel.h"
#import "AnnotationModel.h"
#import "AddressModel.h"

@interface AppUtils : NSObject<SKStoreProductViewControllerDelegate>

+ (AppUtils*)shareAppUtils;

- (void)saveAlertVersionTime:(NSString *)obj andUserId:(NSString *)userId;
- (NSString*)getAlertVersionTimeAndUserId:(NSString *)userId;


- (void)saveAccount:(NSString*)obj;
- (NSString*)getAccount;

- (void)savePassword:(NSString*)obj;
- (NSString*)getPassword;

- (void)saveUserName:(NSString*)obj;
- (NSString*)getUserName;

//- (void)saveAddress:(NSString*)obj;
//- (NSString*)getUserName;

- (void)saveUserId:(NSString*)obj;
- (NSString*)getUserId;

- (void)saveId:(NSString*)obj;
- (NSString*)getId;

-(void)saveIsFirstRun:(BOOL)firstRun;
-(BOOL)getIsFirstRun;

-(void)saveIsLogin:(BOOL)login;
-(BOOL)getIsLogin;

-(void)saveAddress:(AnnotationModel *)model;
-(AnnotationModel *)getAddress;


-(void)saveDefaultAddress:(AddressModel *)model;
-(AddressModel*)getDefaultAddress;


-(void)saveToShoppingCar:(GoodModel *)obj;
-(GoodModel *)getShoppingCarGood;
-(int)getGoodNumber:(GoodModel *)good;
-(NSArray *)getOneGood:(GoodModel *)good;
-(void)changeGoodNumber:(int)number andModel:(GoodModel *)good;
-(void)changeGoodNumberAs:(int)tarNumber andModel:(GoodModel *)good;
-(void)deleteOneGood:(GoodModel *)good;
-(void)deleteAllGood;

- (NSString*)getVersion;
- (NSDate*)getYestoday;
- (NSDate*)getToday;
- (NSDate*)getTomorrow;
- (NSDate*)getFuture;
- (NSComparisonResult)compareDate:(NSDate*)date withOther:(NSDate*)other;
- (NSString*)getDateString:(NSDate*)date withFormat:(NSString*)format;
- (NSDate*)getDateWithString:(NSString*)string withFormat:(NSString*)format;
//日期获取
- (NSString *)getCalcDaysFromBegin:(NSDate *)inBegin;


- (void)showAlert:(NSString*)text;
- (void)showHUD:(NSString*)text;

- (void)openAppWithIdentifier:(NSString *)appId andOwner:(UIViewController*)vc;
- (void)openAppGoCommentWithAppId:(NSString*)appId andOwner:(UIViewController*)vc;

- (BOOL)validateEmail:(NSString *)candidate;
- (BOOL)validateMobile:(NSString *)mobileNum;
- (BOOL)validatePhone:(NSString *)phoneNum;

- (void)cleanPushMessages:(BOOL)quit;
- (void)setBadgeNumber;

- (BOOL)cameraEnbled;
- (BOOL)AudioEnbled;

- (NSInteger)getSumMessageNumber;

@end
