//
//  MessageTableViewCell.m
//  水果唐
//
//  Created by MacPro on 15-7-25.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell
@synthesize contentLabel;

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
        
        markView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        markView1.layer.cornerRadius = 7;
        [self.contentView addSubview:markView1];
        
        markView2 = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 10, 10)];
        markView2.layer.borderWidth = 2;
        markView2.layer.borderColor = UIColorFromRGB(0xFFFFFF).CGColor;
        markView2.layer.cornerRadius = 5;
        [markView1 addSubview:markView2];
        
        markView1.frame = CGRectMake(30, (100-markView1.frame.size.height)/2, markView1.frame.size.width, markView1.frame.size.height);
        
        
        UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(markView1.frame.size.width+markView1.frame.origin.x+10, 10, mainScreenWidth-(markView1.frame.size.width+markView1.frame.origin.x+30+10), 100-10*2)];
        backgroundView.backgroundColor = UIColorFromRGB(0xF2F0F1);
        backgroundView.layer.borderWidth = 1;
        backgroundView.layer.borderColor = UIColorFromRGB(0xC0C0C0).CGColor;
        [self.contentView addSubview:backgroundView];
        
        contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, backgroundView.frame.size.width-20*2, backgroundView.frame.size.height-10*2)];
        contentLabel.numberOfLines = 0;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = FONTSIZE3;
        [backgroundView addSubview:contentLabel];
        
    }
    return self;
}

-(void)setMarkUIColor:(UIColor*)color{
    markView1.backgroundColor = color;
    markView2.backgroundColor = color;
}

@end
