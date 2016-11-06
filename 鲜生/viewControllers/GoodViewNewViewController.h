//
//  GoodViewNewViewController.h
//  FreshMan
//
//  Created by Jie on 15/10/30.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import "MyViewController.h"
#import "MBProgressHUD.h"


@interface GoodViewNewViewController : MyViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray* dataArray;

}
@property (nonatomic,strong) NSString *goodId;
@property (nonatomic,strong) NSString *goodType;

@end
