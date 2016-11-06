//
//  SwipeContainerViewController.m
//  鲜生
//
//  Created by liu.wei on 12/18/13.
//  Copyright (c) 2013 王 苏诚. All rights reserved.
//

#import "SwipeContainerViewController.h"

@interface SwipeContainerViewController ()

@end

@implementation SwipeContainerViewController
@synthesize swipeCenterViewController;
@synthesize swipeLeftViewController;
@synthesize swipeRightViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    return [super init];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (swipeCenterViewController) {
        swipeCenterViewController.view.frame = self.view.bounds;
        self.centerViewController = swipeCenterViewController;
    }
    
    if (swipeLeftViewController) {
        self.leftViewController = swipeLeftViewController;
        self.leftVisibleWidth = self.view.bounds.size.width;
    } else {
        self.enablePopGesture = YES;
    }
    
    if (swipeRightViewController) {
        self.rightViewController = swipeRightViewController;
        self.rightVisibleWidth = self.view.bounds.size.width-50;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
