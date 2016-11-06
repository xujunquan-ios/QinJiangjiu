//
//  HomeViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-12.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "FMNetWorkManager.h"
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface HomeViewController : MyViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIView *QRCodeView;
@property (weak, nonatomic) IBOutlet UIImageView *oneWeekView;
@property (weak, nonatomic) IBOutlet UIImageView *oneMoneyView;
@property (weak, nonatomic) IBOutlet UIImageView *fruitView;
@property (weak, nonatomic) IBOutlet UIImageView *vegetablesView;

@end
