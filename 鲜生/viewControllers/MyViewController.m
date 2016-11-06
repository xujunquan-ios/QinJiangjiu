//
//  MyViewController.m
//  水果糖
//
//  Created by MacPro on 15-7-7.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "RootViewController.h"
#import "CommonCrypto/CommonDigest.h"


@interface MyViewController ()

@end

@implementation MyViewController
@synthesize delegate;

-(void)headImageViewCreat{
    CGFloat itemCount = 8;
    CGFloat itemWidth = self.view.frame.size.width/itemCount;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        UIView* itemView = [[UIView alloc] initWithFrame:CGRectMake(i*itemWidth, 44+STATUSBAR_OFFSET-itemWidth/2+5, itemWidth, itemWidth)];
        if (i % 2 == 0) {
            itemView.backgroundColor = tabBarColor;
        }else{
            itemView.backgroundColor = navigationBarBtnColor;
        }
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:itemView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight  cornerRadii:CGSizeMake(itemWidth/2, itemWidth/2)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = itemView.bounds;
        maskLayer.path = maskPath.CGPath;
        itemView.layer.mask = maskLayer;
        [self.view addSubview:itemView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
-(void)showAlt:(NSString *)message{
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alt show];
}
-(void)backToRootViewControllerWithType:(NSInteger)type{
    UINavigationController* navController = (UINavigationController*)Etappdelegate.window.rootViewController;
    NSArray* viewControllerArray = navController.viewControllers;
    NSInteger rootViewCount = 0;
    UIViewController* rootVC = nil;
    for (NSInteger i = 0; i<viewControllerArray.count; i++) {
        UIViewController *vc = [viewControllerArray objectAtIndex:i];
        if ([vc isKindOfClass:[RootViewController class]]) {
            rootVC = vc;
            rootViewCount = i;
        }
    }
    
    if (rootViewCount == viewControllerArray.count-1) {
        if (rootVC) {
            if ([rootVC isKindOfClass:[RootViewController class]]){
                RootViewController* rootView = (RootViewController*)rootVC;
                [rootView selectTab:type andFilter:@""];
                [rootView resetView];
            }
        }
    }else{
        if (rootVC) {
            [self.navigationController popToViewController:rootVC animated:NO];
            if ([rootVC isKindOfClass:[RootViewController class]]){
                RootViewController* rootView = (RootViewController*)rootVC;
                [rootView selectTab:type andFilter:@""];
                [rootView resetView];
            }
        }
    }
}
- (BOOL)isTelephone:(NSString *)str
{
    NSString * MOBILE = @"^1(3[0-9]|5[0-9]|8[0-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:str]   ||
    [regextestphs evaluateWithObject:str]      ||
    [regextestct evaluateWithObject:str]       ||
    [regextestcu evaluateWithObject:str]       ||
    [regextestcm evaluateWithObject:str];
}
-(NSString *) md5: (NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
