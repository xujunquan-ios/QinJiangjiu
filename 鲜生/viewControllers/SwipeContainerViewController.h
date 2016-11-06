//
//  SwipeContainerViewController.h
//  鲜生
//
//  Created by liu.wei on 12/18/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNSwipeViewController.h"

@interface SwipeContainerViewController : RNSwipeViewController

@property (nonatomic, retain) UIViewController *swipeCenterViewController;
@property (nonatomic, retain) UIViewController *swipeLeftViewController;
@property (nonatomic, retain) UIViewController *swipeRightViewController;
@end
