//
//  PayOrderCell.m
//  FreshMan
//
//  Created by Jie on 15/9/15.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "PayOrderCell.h"
#define IMAGE_WIDTH 120
#define ADD_BTN_WIDTH 20
@implementation PayOrderCell
@synthesize mainImageView,nameLabel,subNameLabel,priceLaberl,numberLab;
@synthesize addBtn,subBtn;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(20, 10, 20, 100)];
        view3.backgroundColor = UIColorFromRGB(0x60c2b2);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view3.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft  cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view3.bounds;
        maskLayer.path = maskPath.CGPath;
        view3.layer.mask = maskLayer;
        
        [self.contentView addSubview:view3];
        
        UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(40, 10, mainScreenWidth-50, view3.frame.size.height)];
        view4.backgroundColor = UIColorFromRGB(0xf0f6e5);
        maskPath = [UIBezierPath bezierPathWithRoundedRect:view4.bounds byRoundingCorners:UIRectCornerBottomRight|UIRectCornerTopRight  cornerRadii:CGSizeMake(10, 10)];
        maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view4.bounds;
        maskLayer.path = maskPath.CGPath;
        view4.layer.mask = maskLayer;

        [self.contentView addSubview:view4];
        
        
        mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, view4.frame.size.height)];
        [view4 addSubview:mainImageView];
        mainImageView.image = [UIImage imageNamed:@"ios_商场选购.png"];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGE_WIDTH + 15, 10, 100, 15)];
        nameLabel.font = FONTSIZE3;
        nameLabel.textAlignment = 0;
        [view4 addSubview:nameLabel];
        
        subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(IMAGE_WIDTH + 15, 35, 160, 15)];
        subNameLabel.font = FONTSIZE4;
        subNameLabel.textAlignment = 0;
        [view4 addSubview:subNameLabel];
        
        
        priceLaberl = [[UILabel alloc] initWithFrame:CGRectMake(IMAGE_WIDTH + 15, 70, 100, 15)];
        priceLaberl.font = FONTSIZE3;
        priceLaberl.textAlignment = 0;
        [view4 addSubview:priceLaberl];
        
        
        
//        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [addBtn setImage:[UIImage imageNamed:@"shoppingCart_addafter"] forState:UIControlStateNormal];
//        [addBtn setImage:[UIImage imageNamed:@"shoppingCart_add"] forState:UIControlStateDisabled];
//        addBtn.frame = CGRectMake(IMAGE_WIDTH + 70-5, 70, ADD_BTN_WIDTH, ADD_BTN_WIDTH);
//        [view4 addSubview:addBtn];
//        
//        subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [subBtn setImage:[UIImage imageNamed:@"shoppingCart_cutafter"] forState:UIControlStateNormal];
//        [subBtn setImage:[UIImage imageNamed:@"shoppingCart_cut"] forState:UIControlStateDisabled];
//        subBtn.frame = CGRectMake(IMAGE_WIDTH + 120-5, 70, ADD_BTN_WIDTH, ADD_BTN_WIDTH);
//        [view4 addSubview:subBtn];
//
//        numberLab = [[UILabel alloc] initWithFrame:CGRectMake(IMAGE_WIDTH + 90-5, 70, 30, ADD_BTN_WIDTH)];
//        numberLab.backgroundColor = [UIColor whiteColor];
//        numberLab.text = @"1";
//        numberLab.textAlignment = 1;
//        [view4 addSubview:numberLab];
//        view4.userInteractionEnabled = YES;
        
        
    }
    return self;
}

@end
