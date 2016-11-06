//
//  AppDelegate.m
//  鲜生
//
//  Created by 湘汇天承 on 15/7/7.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "PayOrderViewController.h"


@interface AppDelegate (){
    UIScrollView *_scrollview;

}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [MobClick startWithAppkey:@"55efdd0e67e58e47f2003d53" reportPolicy:SEND_INTERVAL   channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setLogEnabled:YES];
    
    [WXApi registerApp:WX_APP_ID withDescription:@"GuoShuTang"];

    
    //创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%f %f",mainScreenWidth,mainScreenHeight);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMainViewNotification:)name:@"showMainView" object:nil];
    
    [self showMainView];

    //设置Window为主窗口并显示出来
    [self.window makeKeyAndVisible];

    /*
     add by 引导页
     */
    NSUserDefaults *udf=[NSUserDefaults standardUserDefaults];
    if ([udf objectForKey:@"LOADING_INDAO"]==nil) {
        
        _scrollview=[[UIScrollView alloc]init];
        _scrollview.frame=CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
        _scrollview.contentSize=CGSizeMake(5*mainScreenWidth, mainScreenHeight);
        _scrollview.pagingEnabled=YES;
        _scrollview.bounces=NO;
        _scrollview.showsHorizontalScrollIndicator=NO;
        _scrollview.showsVerticalScrollIndicator=NO;
        
        [self.window addSubview:_scrollview];
        
        for (int i=0;i<5;i++)
        {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(i*mainScreenWidth,0,mainScreenWidth, mainScreenHeight)];
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"引导页面%d.jpg",i+1]];
            image.userInteractionEnabled=YES;
            image.tag = i+2300;
            
            UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClickedImageView:)];
            [image addGestureRecognizer:tapGes1];
            [_scrollview addSubview:image];
            
            
            if (i==4) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake((mainScreenWidth-185)/2, mainScreenHeight-40, 185, 33);
                [btn setImage:[UIImage imageNamed:@"yindao_btn_n"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"yindao_btn_s"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(testBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                [image addSubview:btn];
            }
            
        }

        [udf setObject:@"1" forKey:@"LOADING_INDAO"];
    }
    
    return YES;
}
-(void)btnClickedImageView:(UITapGestureRecognizer *)ges

{
    
    UIScrollView *scorll=(UIScrollView *)_scrollview;
    NSLog(@"%d被点击",ges.view.tag);
    if (ges.view.tag == 2304) {
        return;
    }
    [scorll scrollRectToVisible:CGRectMake((ges.view.tag-2300+1)*mainScreenWidth,ges.view.frame.origin.y,ges.view.frame.size.width,ges.view.frame.size.height) animated:YES];
//    if (btn.tag==2307) {
//        NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//        if (![userDefault objectForKey:@"YINHUAN_GUIDE"]) {
//            [scorll removeFromSuperview];
//            
//        }else{
//            [UIView animateWithDuration:0.3 animations:^(){
//                CGRect frame=scorll.frame;
//                frame.origin.x-=SCREEN_WIDTH;
//                scorll.frame=frame;
//                
//            } completion:^(BOOL isFinished){
//                [scorll removeFromSuperview];
//            }];
//        }
        //            for (UIView *view in self.view.subviews) {
        //                view.hidden=NO;
        //            }
//    }
    
}
#pragma mark guide Method
-(void)testBtnClicked:(UIButton *)btn
{
    [UIView animateWithDuration:1 animations:^(){
        _scrollview.alpha=0.0f;
    }completion:^(BOOL isFinished){
        [_scrollview removeFromSuperview];
    }];
    
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
         NSLog(@"result = %@",resultDic);//返回的支付结果 //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接 口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方法 里面处理跟 callback 一样的逻辑】

     }];
    BOOL isSuc = [WXApi handleOpenURL:url delegate:[[PayOrderViewController alloc] init]];
//    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    
    return  isSuc;
//    return YES;
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url

{
    
    return  [WXApi handleOpenURL:url delegate:[[PayOrderViewController alloc] init]];
//    return  [WXApi handleOpenURL:url delegate:self];
    
}


//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//
//{
//    
//    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
//    
//    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
//    
//    return  isSuc;
//    
//}

//接受显示主界面的通知
-(void)showMainViewNotification:(NSNotification *)notification{
    [self showMainView];
}

////进入新手指导
//-(void)showHelpView{
//    [[AppUtils shareAppUtils] saveIsFirstRun:NO];
//    HelpViewController* helpVC = [[HelpViewController alloc] init];
//    MyUINavigationController* nav = [[MyUINavigationController alloc] initWithRootViewController:helpVC];
//    self.window.rootViewController = nav;
//    
//}


/*
 9000 订单支付成功
 8000 正在处理中
 4000 订单支付失败
 6001 用户中途取消
 6002 网络连接出错
 */ // 这个callback是使用HTML5网页版支付时的回调，如果是用客户端支付，是不会回调到这里的



-(void)showMainView{
    RootViewController* rootView = [[RootViewController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:rootView];
    self.window.rootViewController = nav;
    return;
    
    //    //a.初始化一个tabBar控制器
    //    UITabBarController *tb= [[UITabBarController alloc]init];
    //    tb.tabBar.selectedImageTintColor = UIColorFromRGB(0xFFFFFF);
    //    tb.tabBar.barTintColor = UIColorFromRGB(0x65BECB);
    //
    //    // this will give selected icons and text your apps tint color
    //    tb.tabBar.tintColor = [UIColor whiteColor]; // appTintColor is a UIColor *
    //
    //    [[UITabBarItem appearance] setTitleTextAttributes:
    //     [NSDictionary dictionaryWithObjectsAndKeys:
    //      [UIColor whiteColor], UITextAttributeTextColor,
    //      [UIFont fontWithName:@"ProximaNova-Semibold" size:0.0], UITextAttributeFont,
    //      nil]
    //                                             forState:UIControlStateNormal];
    //
    ////    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainScreenWidth, 49)];
    ////    backView.backgroundColor = UIColorFromRGB(0x65BECB);
    ////    [tb.tabBar insertSubview:backView atIndex:0];
    ////    tb.tabBar.opaque = YES;
    //
    //    tb.tabBar.translucent = NO;
    //
    //    //b.创建子控制器
    //    HomeViewController *c1 = [[HomeViewController alloc]init];
    //    c1.view.backgroundColor = [UIColor grayColor];
    //    c1.title = @"首页";
    //    c1.tabBarItem.image = [UIImage imageNamed:@"Home"];
    //
    //
    //    ShoppingCenterViewController *c2 = [[ShoppingCenterViewController alloc]init];
    //    c2.title = @"分类";
    //    c2.tabBarItem.image = [UIImage imageNamed:@"HomeShoppingCenter"];
    //
    //
    //    ShoppingCartViewController *c4 = [[ShoppingCartViewController alloc]init];
    //    c4.title = @"购物车";
    //    c4.tabBarItem.image = [UIImage imageNamed:@"HomeShoppingCart"];
    //
    //    PersonViewController *c5 = [[PersonViewController alloc]init];
    //    c5.title = @"个人";
    //    c5.tabBarItem.image = [UIImage imageNamed:@"HomePerson"];
    //
    //    //c.添加子控制器到ITabBarController中
    //    //c.1第一种方式
    //    //    [tb addChildViewController:c1];
    //    //    [tb addChildViewController:c2];
    //
    //    //c.2第二种方式
    //
    //    MyUINavigationController* nav1 = [[MyUINavigationController alloc] initWithRootViewController:c1];
    //    MyUINavigationController* nav2 = [[MyUINavigationController alloc] initWithRootViewController:c2];
    //    MyUINavigationController* nav4 = [[MyUINavigationController alloc] initWithRootViewController:c4];
    //    MyUINavigationController* nav5 = [[MyUINavigationController alloc] initWithRootViewController:c5];
    //    
    //    
    //    tb.viewControllers=@[nav1,nav2,nav4,nav5];
    //    
    //    self.window.rootViewController = tb;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "xhtc._11" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"_11" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"_11.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end