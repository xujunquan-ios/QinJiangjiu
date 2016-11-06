//
//  RegisterAgreementViewController.h
//  FreshMan
//
//  Created by MacPro on 15-8-13.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"

@interface RegisterAgreementViewController : MyViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* titleArray;
    NSMutableArray* contenctArray;
}

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

@end
