//
//  AppUtils.m
//  鲜生
//
//  Created by liu.wei on 8/20/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import "AppUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "MBProgressHUD.h"

@implementation AppUtils
AppUtils* mAppUtil = nil;
NSUserDefaults *defaults = nil;

+ (AppUtils*)shareAppUtils {
    if (mAppUtil == nil) {
        mAppUtil = [[AppUtils alloc] init];
        defaults = [NSUserDefaults standardUserDefaults];
    }
    return mAppUtil;
}

-(id)init {
    return [super init];
}

-(void)saveToShoppingCar:(GoodModel *)obj{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"shoppingCar"]];
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:obj.goodPid]];
    if (goodDic.count>0) {
        int count = [[goodDic objectForKey:@"amount"] intValue];
        count = count+1;
        [goodDic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"amount"];
        [dic setObject:goodDic forKey:obj.goodPid];
        
        [defaults setObject:dic forKey:@"shoppingCar"];
    }else{
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [newDic setObject:[NSString stringWithFormat:@"1"] forKey:@"amount"];
        [newDic setObject:obj.goodPid forKey:@"pid"];
        [dic setObject:newDic forKey:obj.goodPid];
        [defaults setObject:dic forKey:@"shoppingCar"];
//        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                      message:@"已加入购物车"
//                                                     delegate:nil
//                                            cancelButtonTitle:nil
//                                            otherButtonTitles:@"确定", nil];
//        [alt show];
    }
    NSLog(@"%@",[defaults objectForKey:@"shoppingCar"]);
}
-(int)getGoodNumber:(GoodModel *)good{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"shoppingCar"]];
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:good.goodPid]];
    
    return [[goodDic objectForKey:@"amount"] intValue];
}
-(NSArray *)getOneGood:(GoodModel *)good{
    
    
    return @[];
}
-(void)changeGoodNumberAs:(int)tarNumber andModel:(GoodModel *)good{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"shoppingCar"]];
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:good.goodPid]];
    if (goodDic.count>0) {
        [goodDic setObject:[NSString stringWithFormat:@"%d",tarNumber] forKey:@"amount"];
        [dic setObject:goodDic forKey:good.goodPid];
        
        [defaults setObject:dic forKey:@"shoppingCar"];
    }else{
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [newDic setObject:[NSString stringWithFormat:@"%d",tarNumber] forKey:@"amount"];
        [newDic setObject:good.goodPid forKey:@"pid"];
        [dic setObject:newDic forKey:good.goodPid];
        [defaults setObject:dic forKey:@"shoppingCar"];
    }
    //    [defaults removeObjectForKey:@"shoppingCar"];
    NSLog(@"%@",[defaults objectForKey:@"shoppingCar"]);
}
-(void)changeGoodNumber:(int)number andModel:(GoodModel *)good{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"shoppingCar"]];
    NSMutableDictionary *goodDic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:good.goodPid]];
    if (goodDic.count>0) {
        int count = [[goodDic objectForKey:@"amount"] intValue];
        count = count+number;
        [goodDic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"amount"];
        [dic setObject:goodDic forKey:good.goodPid];
        
        [defaults setObject:dic forKey:@"shoppingCar"];
    }else{
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        [newDic setObject:[NSString stringWithFormat:@"1"] forKey:@"amount"];
        [newDic setObject:good.goodPid forKey:@"pid"];
        [dic setObject:newDic forKey:good.goodPid];
        [defaults setObject:dic forKey:@"shoppingCar"];
    }
    //    [defaults removeObjectForKey:@"shoppingCar"];
    NSLog(@"%@",[defaults objectForKey:@"shoppingCar"]);
}
-(void)deleteOneGood:(GoodModel *)good{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"shoppingCar"]];
    [dic removeObjectForKey:good.goodPid];
    [defaults setObject:dic forKey:@"shoppingCar"];
//    [defaults setObject:good forKey:@"username"];

}
-(void)deleteAllGood{
    [defaults removeObjectForKey:@"shoppingCar"];

}
-(NSMutableArray *)getShoppingCarGood{
    if (defaults) {
        NSArray *arr = [[defaults objectForKey:@"shoppingCar"] allValues];
        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:arr];
        return mutArr;
    }
    return nil;
}

- (void)saveAccount:(NSString*)obj {
    if (defaults && obj)
    {
        [defaults setObject:obj forKey:@"username"];
        
        [defaults synchronize];
    }
}

- (NSString*)getAccount {
    if (defaults)
    {
        NSString *obj = [defaults objectForKey:@"username"];
        return obj ? obj : @"";
    }
    return nil;
}
- (void)saveUserName:(NSString*)obj{
    if (defaults && obj)
    {
        [defaults setObject:obj forKey:@"userName"];
        [defaults synchronize];
    }
}
- (NSString*)getUserName{
    if (defaults)
    {
        NSString *obj = [defaults objectForKey:@"userName"];
        return obj ? obj : @"";
    }
    return nil;
}

- (void)savePassword:(NSString*)obj {
    if (defaults && obj)
    {
        [defaults setObject:obj forKey:@"password"];
        [defaults synchronize];
    }
}

- (NSString*)getPassword {
    if (defaults)
    {
        NSString *obj = [defaults objectForKey:@"password"];
        return obj ? obj : @"";
    }
    return nil;
}
- (void)saveId:(NSString*)obj{
    if (defaults && obj)
    {
        [defaults setObject:obj forKey:@"id"];
        [defaults synchronize];
    }
}
- (NSString*)getId{
    if (defaults)
    {
        NSString *obj = [defaults objectForKey:@"id"];
        return obj ? obj : @"";
    }
    return nil;
}

- (void)saveUserId:(NSString*)obj {
    if (defaults && obj)
    {
        [defaults setObject:obj forKey:@"userid"];
        [defaults synchronize];
    }
}

- (NSString*)getUserId {
    if (defaults)
    {
        NSString *obj = [defaults objectForKey:@"userid"];
        return obj ? obj : @"";
    }
    return nil;
}

-(void)saveIsFirstRun:(BOOL)firstRun {
    if (defaults)
    {
        [defaults setObject:firstRun?@"YES":@"NO" forKey:@"IsFirstRun"];
        [defaults synchronize];
    }
}

-(BOOL)getIsFirstRun {
    if (defaults)
    {
        NSString *firstRun = [defaults stringForKey:@"IsFirstRun"];
        return (firstRun == nil) || (firstRun && [firstRun isEqual:@"YES"]);
    }
    return NO;
}


-(void)saveIsLogin:(BOOL)login{
    if (defaults)
    {
        [defaults setObject:login?@"YES":@"NO" forKey:@"IsLogin"];
        [defaults synchronize];
    }
}

-(BOOL)getIsLogin{
    if (defaults)
    {
        NSString *login = [defaults stringForKey:@"IsLogin"];
        return  (login && [login isEqual:@"YES"]);
    }
    return NO;
}


-(void)saveAddress:(AnnotationModel *)model{
    if (defaults)
    {
        [defaults setObject:model.name forKey:@"ziqudianName"];
        [defaults setObject:model.address forKey:@"ziqudianAddress"];
        [defaults setObject:model.time forKey:@"ziqudianTime"];
        [defaults setObject:model.annotationID forKey:@"ziqudianID"];
        [defaults setObject:model.coordinateX forKey:@"ziqudianX"];
        [defaults setObject:model.coordinateY forKey:@"ziqudianY"];
        [defaults setObject:model.phone forKey:@"ziqudianPhone"];
        [defaults setObject:model.staff forKey:@"ziqudianStaff"];
        [defaults synchronize];
    }
}

//获取自取点的位置
-(AnnotationModel *)getAddress{
    if (defaults)
    {
        NSString *name = [defaults objectForKey:@"ziqudianName"];
        NSString *address = [defaults objectForKey:@"ziqudianAddress"];
        NSString *time = [defaults objectForKey:@"ziqudianTime"];
        NSString *coorx = [defaults objectForKey:@"ziqudianX"];
        NSString *coory = [defaults objectForKey:@"ziqudianY"];
        NSString *annoId = [defaults objectForKey:@"ziqudianID"];
        NSString *phone = [defaults objectForKey:@"ziqudianPhone"];
        NSString *staff = [defaults objectForKey:@"ziqudianStaff"];
        AnnotationModel *anno = [[AnnotationModel alloc] init];
        anno.name = name;
        anno.coordinateY = coorx;
        anno.coordinateX = coory;
        anno.annotationID = annoId;
        anno.address = address;
        anno.phone = phone;
        anno.staff = staff;
        anno.time = time;
        return  anno;
    }
    return NO;
}


-(void)saveDefaultAddress:(AddressModel *)model{
    if (defaults)
    {
        [defaults setObject:model.name forKey:@"DefaultAddressName"];
        [defaults setObject:model.address forKey:@"DefaultAddressAddress"];
        [defaults setObject:model.addressId forKey:@"DefaultAddressID"];
        [defaults setObject:model.moren forKey:@"DefaultAddressMoren"];
        [defaults setObject:model.phone forKey:@"DefaultAddressPhone"];
        [defaults setObject:model.uid forKey:@"DefaultAddressUid"];
        [defaults synchronize];
    }
}
-(AddressModel*)getDefaultAddress{
    if (defaults)
    {
        AddressModel *anno = [[AddressModel alloc] init];
        anno.name = [defaults objectForKey:@"DefaultAddressName"];
        anno.address = [defaults objectForKey:@"DefaultAddressAddress"];
        anno.phone = [defaults objectForKey:@"DefaultAddressPhone"];
        anno.moren = [defaults objectForKey:@"DefaultAddressMoren"];
        anno.uid = [defaults objectForKey:@"DefaultAddressUid"];
        anno.addressId = [defaults objectForKey:@"DefaultAddressID"];
        return  anno;
    }
    return NO;
}



- (NSString*)getVersion {
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}

- (NSDate*)getYestoday {
    return [NSDate dateWithTimeInterval:0-24*60*60 sinceDate:[NSDate date]];
}

- (NSDate*)getToday {
    
    //    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    //    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    //    NSString *today = [NSString stringWithFormat:@"%4d-%02d-%02d 23:59:59", [dateComponent year], [dateComponent month], [dateComponent day]];
    //    return [dateformatter dateFromString:today];
    return [NSDate date];
}

- (NSDate*)getTomorrow {
    
    //    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    //    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    //    NSString *today = [NSString stringWithFormat:@"%4d-%02d-%02d 23:59:59", [dateComponent year], [dateComponent month], [dateComponent day]];
    //    return [NSDate dateWithTimeInterval:24*60*60 sinceDate:[dateformatter dateFromString:today]];
    return [NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]];
}

- (NSDate*)getFuture {
    
    //    NSDateFormatter *dateformatter=[[[NSDateFormatter alloc] init] autorelease];
    //    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    //    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    //    NSString *today = [NSString stringWithFormat:@"%4d-%02d-%02d 23:59:59", [dateComponent year], [dateComponent month], [dateComponent day]];
    //    return [NSDate dateWithTimeInterval:24*60*60*7 sinceDate:[dateformatter dateFromString:today]];
    return [NSDate dateWithTimeInterval:24*60*60*7 sinceDate:[NSDate date]];
}

- (NSComparisonResult)compareDate:(NSDate*)date withOther:(NSDate*)other {
    NSDate *one = [self getDateByRefer:date];
    NSDate *two = [self getDateByRefer:other];
    return [one compare:two];
}

- (NSDate*)getDateByRefer:(NSDate*)date {
    if (!date)
        return nil;
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSString *today = [NSString stringWithFormat:@"%4ld-%02ld-%02ld 23:59:59", (long)[dateComponent year], (long)[dateComponent month], (long)[dateComponent day]];
    return [dateformatter dateFromString:today];
}

- (NSString*)getDateString:(NSDate*)date withFormat:(NSString*)format {
    if (!date || !format)
        return nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    return [dateFormatter stringFromDate:date];
}

- (NSDate*)getDateWithString:(NSString*)string withFormat:(NSString*)format{
    if (!string || !format){
        return nil;
    }
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:format];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    return inputDate;
}

//算个时间
- (NSString *)getCalcDaysFromBegin:(NSDate *)date
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [NSDate date];
    NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    NSString *dateStr = [[AppUtils shareAppUtils] getDateString:date withFormat:@"HH:mm"];
    if ([dateString isEqualToString:todayString])
    {
        return dateStr;
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return [NSString stringWithFormat:@"昨天 %@",dateStr];
    }else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags0 = NSYearCalendarUnit;
        NSDateComponents *dateComponent0 = [calendar components:unitFlags0 fromDate:date];
        NSInteger year = [dateComponent0 year];
        NSUInteger unitFlags = NSMonthCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
        NSInteger month = [dateComponent month];
        NSUInteger unitFlags1 = NSCalendarUnitDay;
        NSDateComponents *dateComponent1 = [calendar components:unitFlags1 fromDate:date];
        NSInteger day = [dateComponent1 day];
        return  [NSString stringWithFormat:@"%ld年%ld月%ld日 %@",(long)year,(long)month,(long)day,dateStr];
    }
}


- (void)showAlert:(NSString*)text {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                     message:text
                                                    delegate:nil
                                           cancelButtonTitle:@"知道了"
                                           otherButtonTitles:nil];
    [alert show];
}

-(void)showHUD:(NSString*)text
{
    UIViewController *vc = ((UINavigationController*)(Etappdelegate.window.rootViewController)).topViewController;
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:vc.view];
    [vc.view addSubview:hud];
    hud.customView = [[UIView alloc] init] ;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud show:YES];
    [hud hide:YES afterDelay:0.3];
    
}


- (void)outerOpenAppWithIdentifier:(NSString *)appId {
    NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/us/app/id%@?mt=8", appId];
    NSURL *url = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)openAppWithIdentifier:(NSString *)appId andOwner:(UIViewController*)vc{
    
    //    if ([[[UIDevice currentDevice]systemVersion] floatValuze] < 6.0){
    [self outerOpenAppWithIdentifier:appId];
    return;
    //    }
    
    SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
    storeProductVC.delegate = self;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
    [storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error) {
        if (result) {
            [vc presentViewController:storeProductVC animated:YES completion:^{}];
        }
    }];
}

-(void)outerOpenAppGoCommentWithAppId:(NSString*)appId{
    NSString *evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",appId];
    BOOL bol =[[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    if (!bol){
        UIAlertView* alerVeiw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法打开APPStore 评论界面" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alerVeiw show];
    }
}

-(void)openAppGoCommentWithAppId:(NSString*)appId andOwner:(UIViewController*)vc{
    if ([[[UIDevice currentDevice]systemVersion] floatValue] < 6.0){
        [self outerOpenAppGoCommentWithAppId:appId];
        return;
    }
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    //设置代理请求为当前控制器本身
    storeProductViewContorller.delegate = self;
    //加载一个新的视图展示
    [storeProductViewContorller loadProductWithParameters:
     //appId唯一的
     @{SKStoreProductParameterITunesItemIdentifier :appId} completionBlock:^(BOOL result, NSError *error) {
         //block回调
         if(error){
             NSLog(@"error %@ with userInfo %@",error,[error userInfo]);
             UIAlertView* alerVeiw = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"无法打开APPStore 评论界面" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
             [alerVeiw show];
         }else{
             //模态弹出appstore
             [vc presentViewController:storeProductViewContorller animated:YES completion:^{
             }
              ];
         }
     }];
}


- (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^((\\+)?86)?1(3|4|5|7|8)\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
}

- (BOOL)validatePhone:(NSString *)phoneNum
{
    NSString * phone = @"(^(\\d{7,8})$)|(^\\((\\d{3,4})\\)(\\d{7,8})$)|(^(\\d{3,4})-(\\d{7,8})$)|(^(\\d{3,4})(\\d{7,8})$)|(^(\\d{3,4})(\\d{7,8})-(\\d{1,4})$)|(^(\\d{3,4})-(\\d{7,8})-(\\d{1,4})$)|(^\\((\\d{3,4})\\)(\\d{7,8})-(\\d{1,4})$)|(^(\\d{7,8})-(\\d{1,4})$)|(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)";
    
    NSPredicate *regextestphone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phone];
    
    return [regextestphone evaluateWithObject:phoneNum];
}



- (BOOL)cameraEnbled{
    BOOL result = YES;
    if (IS_IOS_7){
        result = NO;
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        NSLog(@"status%ld",(long)status);
        if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined){
            result = YES;
        }
    }
    return result;
}
-(BOOL)AudioEnbled{
    BOOL result = YES;
    if (IS_IOS_7){
        result = NO;
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:
                                        AVMediaTypeAudio];
        NSLog(@"status%ld",(long)status);
        if (status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined){
            result = YES;
        }
    }
    return result;
}

@end
