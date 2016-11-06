//
//  OneMoneyTableViewCell.m
//  FreshMan
//
//  Created by MacPro on 15-8-17.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "OneMoneyTableViewCell.h"

@implementation OneMoneyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.backGroupView.layer.borderWidth = 0.5;
    self.backGroupView.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    self.backGroupView.backgroundColor = [UIColor clearColor];
    
    self.titleLabel.textColor = UIColorFromRGB(0x31577E);
    
    self.subTitleLabel.textColor = UIColorFromRGB(0x999999);
    
    self.numberLabel.textColor = UIColorFromRGB(0x999999);
    
    self.buyBtn.layer.cornerRadius = 5;
    self.buyBtn.backgroundColor = UIColorFromRGB(0xEE751C);
    [self.buyBtn addTarget:self action:@selector(buyBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.addBtn.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [self.addBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addBtnPress) forControlEvents:UIControlEventTouchUpInside];
    
    self.decreaseBtn.backgroundColor = UIColorFromRGB(0xF1F1F1);
    [self.decreaseBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    [self.decreaseBtn addTarget:self action:@selector(decreaseBtnPress) forControlEvents:UIControlEventTouchUpInside];
}

-(void)addBtnPress{
    NSInteger number = [self.numberLabel.text integerValue];
    number ++;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

-(void)decreaseBtnPress{
    NSInteger number = [self.numberLabel.text integerValue];
    if (number > 0) {
        number --;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)number];
}

-(void)buyBtnPress{
    NSLog(@"去买商品");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
