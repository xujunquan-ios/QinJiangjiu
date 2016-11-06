//
//  MessageTableViewCell.h
//  水果唐
//
//  Created by MacPro on 15-7-25.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell
{
    UIView* markView1;
    UIView* markView2;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)setMarkUIColor:(UIColor*)color;

@property (nonatomic,retain)UILabel* contentLabel;

@end
