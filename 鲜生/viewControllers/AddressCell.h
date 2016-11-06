//
//  AddressCell.h
//  FreshMan
//
//  Created by Jie on 15/9/16.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressCellDelegate<NSObject>


@end

//@protocol GoodTableViewCellDelegate <NSObject>

@interface AddressCell : UITableViewCell
@property (nonatomic,retain)UILabel* nameLabel;//姓名
@property (nonatomic,retain)UILabel *addressLabel;//地址
@property (nonatomic,retain)UILabel *phoneLabel;//电话
@property (nonatomic,retain)UIButton *selectBtn;//选中
@end
