//
//  RootViewController.h
//  水果唐
//
//  Created by MacPro on 15-7-9.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "HomeViewController.h"
#import "ShoppingCenterViewController.h"
#import "ShoppingCartViewController.h"
#import "PersonViewController.h"
#import "AKTabBar.h"
#import "RNSwipeViewController.h"


@interface displayItem : NSObject
@property(nonatomic,copy)NSString *icon,*text;
@property(nonatomic,retain)UIColor *textColor;
@property(nonatomic,assign)NSInteger tag,count;
@end

@interface RootViewController : RNSwipeViewController <AKTabBarDelegate>
{
    NSMutableArray *menuData;
    AKTabBar *tabBar;
    NSInteger selectIndex;
    
    HomeViewController* homeView;
    ShoppingCenterViewController* shoppingCenterView;
    ShoppingCartViewController* shoppingCartView;
    PersonViewController* personView;
}

@property (nonatomic,retain)MyViewController* centerViewController;

-(void)showMainViewWithType:(NSInteger)type andFiler:(NSString*)filterString;
-(void)selectTab:(NSInteger)index andFilter:(NSString*)filterString;

@end
