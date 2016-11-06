//
//  RootViewController.m
//  水果唐
//
//  Created by MacPro on 15-7-9.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "RootViewController.h"
#import "AppUtils.h"

@implementation displayItem

@end

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    [self showMainViewWithType:INDEX_HOME andFiler:@""];
    // Do any additional setup after loading the view.
}

//切换首页中间和右侧筛选页面，左侧关注页面永远不变
-(void)showMainViewWithType:(NSInteger)type andFiler:(NSString*)filterString{
    if (homeView && type == INDEX_HOME){
        if (self.centerViewController == homeView) {
            return;
        }
    }

    if (shoppingCenterView && type == INDEX_SHOPPING_CENTER){
        if (self.centerViewController == shoppingCenterView) {
            return;
        }
    }

    if (shoppingCartView && type == INDEX_SHOPPING_CART) {
        if (self.centerViewController == shoppingCartView) {
            return;
        }
    }

    if (personView && type == INDEX_PERSON){
        if (self.centerViewController == personView) {
            return;
        }
    }
    
   
    if (!tabBar){
        [self createTabBar];
    }

    if (self.centerViewController) {
        [self.centerViewController.view removeFromSuperview];
    }

    if (type == INDEX_HOME){
        if (!homeView) {
            homeView = [[HomeViewController alloc] init];
        }
        self.centerViewController = homeView;
    }
    else if (type == INDEX_SHOPPING_CENTER){
        if (!shoppingCenterView) {
            shoppingCenterView = [[ShoppingCenterViewController alloc] init];
        }
        self.centerViewController = shoppingCenterView;
    }
    else if (type == INDEX_SHOPPING_CART){
        if (!shoppingCartView) {
            shoppingCartView = [[ShoppingCartViewController alloc] init];
        }
        self.centerViewController = shoppingCartView;
    }
    else if (type == INDEX_PERSON){
        if (!personView) {
            personView = [[PersonViewController alloc] init];
        }
        self.centerViewController = personView;
    }

    if (self.centerViewController) {
        [tabBar removeFromSuperview];
        if (tabBar) {
            [self.centerViewController.view addSubview:tabBar];
        }
        [self.view addSubview:self.centerViewController.view];
    }
    

    selectIndex = type;
}

- (void)createMenuData
{
    if (menuData) {
        [menuData removeAllObjects];
    }else{
         menuData = [[NSMutableArray alloc] init];
    }
   
    
    //默认菜单按钮顺序
    NSArray *currentMenuIDs = @[@(INDEX_HOME), @(INDEX_SHOPPING_CENTER), @(INDEX_SHOPPING_CART), @(INDEX_PERSON)];
    
    
    //添加新增按钮
    for (NSInteger i = 0; i < currentMenuIDs.count; i++) {
        NSNumber *currentItem = [currentMenuIDs objectAtIndex:i];
        displayItem *menuItem = [self getMenuItemByTag:currentItem.intValue];
        [menuData insertObject:menuItem atIndex:i];
    }
    
}

- (displayItem*)getMenuItemByTag:(NSInteger)menuTag
{
    displayItem *menuItem = nil;
    
    switch (menuTag) {
        case INDEX_HOME:
            menuItem = [[displayItem alloc] init];
            menuItem.tag = INDEX_HOME;
            menuItem.text = @"首页";
            menuItem.icon = @"Home";
            break;
        case INDEX_SHOPPING_CENTER:
            menuItem = [[displayItem alloc] init];
            menuItem.tag = INDEX_SHOPPING_CENTER;
            menuItem.text = @"商城";
            menuItem.icon = @"HomeShoppingCenter";
            break;
        case INDEX_SHOPPING_CART:
            menuItem = [[displayItem alloc] init];
            menuItem.tag = INDEX_SHOPPING_CART;
            menuItem.text = @"购物车";
            menuItem.icon = @"HomeShoppingCart";
            break;
        case INDEX_PERSON:
            menuItem = [[displayItem alloc] init];
            menuItem.tag = INDEX_PERSON;
            menuItem.text = @"个人";
            menuItem.icon = @"HomePerson";
            break;
        default:
            break;
    }
    
    return menuItem;
}

#pragma mark - 创建菜单栏
//AKTabBar 点击回调
- (void)tabBar:(AKTabBar *)tabbar didSelectTabAtIndex:(NSInteger)index andFilter:(NSString*)filter
{
    AKTab *tab = [tabbar.tabs objectAtIndex:index];
    tab.titleLabel.text = @"test";
    if (tab.tag <= INDEX_PERSON) {
        [tabbar setSelectedTab:tab];
        [self showMainViewWithType:tab.tag andFiler:filter];
    }
//    else {
//        if (tab.tag == INDEX_MORE) {
//            
//            if (activityView.isShowing) {
//                [activityView hide];
//            } else {
//                [self createActivityView];
//                [activityView show];
//            }
//        }
//    }
}

//创新菜单视图
-(void)createTabBar
{
    if (tabBar) {
        [tabBar removeFromSuperview];
    }
    
    tabBar = [[AKTabBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-tabBarHeight1, self.view.bounds.size.width, tabBarHeight1)];
    tabBar.delegate = self;
    tabBar.edgeColor = [UIColor clearColor];
    tabBar.backgroundColor = tabBarColor;
    //    tabBar.alpha = 0.9;
    
    [self createMenuData];
    
    NSMutableArray *tabs = [[NSMutableArray alloc] init];
    
    for (displayItem * item in menuData) {
        AKTab *tab = [[AKTab alloc] init];
        tab.backgroundColor = [UIColor clearColor];
        tab.textColor = UIColorFromRGB(0xFFFFFF);
        tab.selectedTextColor = UIColorFromRGB(0x2187c5);
        //        tab.tabIconColors = @[(id)UIColorFromRGB(0x999999).CGColor,(id)UIColorFromRGB(0x999999).CGColor];
        //        tab.tabIconColorsSelected = @[(id)UIColorFromRGB(0x2187c5).CGColor,(id)UIColorFromRGB(0x2187c5).CGColor];
        //        tab.edgeColor = [UIColor clearColor];
        tab.tag = item.tag;
        tab.edgeColor = [UIColor redColor];
        tab.tabImageWithName = item.icon;
        tab.tabTitle = item.text;
        [tabs addObject:tab];
    }
    
    [tabBar setTabs:tabs];
    [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:0]];
    
    
    [self showTabBarNumbers];
    
    [self.view addSubview:tabBar];
}

//手动设置底部菜单按钮选中
- (void)selectTab:(NSInteger)tabIndex andFilter:(NSString *)filterString{
    AKTab *tab = nil;
    //底部菜单包含已选中按钮
    for (NSInteger i = 0; i < 5; i++) {
        AKTab *temp = [tabBar.tabs objectAtIndex:i];
        if (temp.tag == tabIndex) {
            tab = temp;
            break;
        }
    }
    if (tab) {
        [tabBar tabSelected:tab andFilter:filterString];
        return;
    }
    
    //底部菜单不包含已选中按钮
    //将第2，3按钮移到第3，4位置上
    for (NSInteger i = 3; i > 1; i--) {
        AKTab *tabOld = [tabBar.tabs objectAtIndex:i];
        AKTab *tabNew = [tabBar.tabs objectAtIndex:i-1];
        tabOld.tag = tabNew.tag;
        tabOld.tabImageWithName = tabNew.tabImageWithName;
        tabOld.tabTitle = tabNew.tabTitle;
        [tabOld setNeedsDisplay];
    }
    tab = [tabBar.tabs objectAtIndex:1];
    if (tab) {
        //将选中的按钮显示在第2个位置
        //        for (NSInteger i = 0; i < menuData.count; i++) {
        //            displayItem *menuItem = [menuData ObjectAtIndex:i];
        //
        //            if (menuItem.tag == tabIndex) {
        //                tab.tag = tabIndex;
        //                tab.tabImageWithName = menuItem.icon;
        //                tab.tabTitle = menuItem.text;
        //                [tab setNeedsDisplay];
        //                [tabBar tabSelected:tab andFilter:filterString];
        //
        //                [menuItem retain];
        //                [menuData removeObjectAtIndex:i];
        //                [menuData insertObject:menuItem atIndex:0];
        //                [menuItem release];
        //                break;
        //            }
        //        }
    }
    [self showTabBarNumbers];
    
    //保存新的菜单按钮顺序
    //    NSMutableArray *savedMenuIDs = [[NSMutableArray alloc] init];
    //    for (displayItem *menuItem in menuData) {
    //        [savedMenuIDs addObject:@(menuItem.tag)];
    //    }
    //    [[AppUtils shareAppUtils] saveMenuData:savedMenuIDs byUserId:[[AppUtils shareAppUtils] getUserId]];
    //    [savedMenuIDs release];
}

//创建更多按钮弹出菜单
- (void)createActivityView {
    
}

//- (ButtonViewHandler)buttonViewHandler {
//    return Block_copy(^(ButtonView *bv){
//
//        if (bv.tag < INDEX_MORE) {
//            [self selectTab:bv.tag andFilter:@""];
//        }
//        
//        if (bv.tag == INDEX_SETTING) {
//            [self goSettingView];
//        }
//        
//        if (bv.tag == INDEX_SPEAKER) {
//            [self goVoiceView];
//        }
//    });
//}

//- (ButtonViewHandler)buttonViewHandler {
//    return Block_copy(^(ButtonView *bv){
//        
//        if (bv.tag < INDEX_MORE) {
//            [self selectTab:bv.tag andFilter:@""];
//        }
//        
//        if (bv.tag == INDEX_SETTING) {
//            [self goSettingView];
//        }
//        
//        if (bv.tag == INDEX_SPEAKER) {
//            [self goVoiceView];
//        }
//    });
//}


//底部菜单按钮上显示数字
- (void)showTabBarNumbers {
//    [[AppUtils shareAppUtils] setBadgeNumber];
    
    NSInteger numbers = 0;
//    [[AppUtils shareAppUtils] getSumMessageNumber];
    
    for (AKTab *tab in tabBar.tabs) {
        tab.badgeNumber = 0;
        if (tab.tag == INDEX_SHOPPING_CART) {
            if (numbers > 0) {
                tab.badgeNumber = 0;
            }
        }
    }
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
