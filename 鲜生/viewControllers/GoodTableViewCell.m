//
//  GoodTableViewCell.m
//  FreshMan
//
//  Created by MacPro on 15-8-18.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "GoodTableViewCell.h"

@implementation GoodTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.showView.frame = CGRectMake(self.showView.frame.origin.x, self.showView.frame.origin.y+5, self.showView.frame.size.width, self.showView.frame.size.height);
    self.buyBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 31,0,0);
    self.buyBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -22,0,0);
    [self.buyBtn setImage:[UIImage imageNamed:@"buyIcon"] forState:UIControlStateHighlighted];
    [self.buyBtn setImage:[UIImage imageNamed:@"buyIcon"] forState:UIControlStateNormal];
    [self.buyBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopingCartBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 32,0,0);
    self.shopingCartBtn.titleEdgeInsets = UIEdgeInsetsMake(30, -22,0,0);
    [self.shopingCartBtn setImage:[UIImage imageNamed:@"addShoppingCart"] forState:UIControlStateHighlighted];
    [self.shopingCartBtn setImage:[UIImage imageNamed:@"addShoppingCart"] forState:UIControlStateNormal];
    [self.shopingCartBtn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];

    // Configure the view for the selected state
}

-(void)btnPress:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(btnPress:andFunction:)]) {
        [self.delegate btnPress:self.indexPath andFunction:sender.titleLabel.text];
    }
}


@end
