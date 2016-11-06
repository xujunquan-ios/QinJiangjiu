//
//  PersonTableViewCell.h
//  水果唐
//
//  Created by MacPro on 15-8-3.
//  Copyright (c) 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonTableViewCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,retain)UIImageView* imageView;
@property (nonatomic,retain)UILabel* titleLabel;

@end
