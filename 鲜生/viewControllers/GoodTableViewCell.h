//
//  GoodTableViewCell.h
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodTableViewCellDelegate <NSObject>

-(void)btnPress:(NSIndexPath*)indexPath andFunction:(NSString*)function;

@end

@interface GoodTableViewCell : UITableViewCell

@property (nonatomic,retain)NSIndexPath* indexPath;
@property (nonatomic,assign)id <GoodTableViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *markView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopingCartBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *goodImageView;

@end
