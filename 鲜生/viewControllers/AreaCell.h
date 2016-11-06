//
//  AreaCell.h
//  FreshMan
//
//  Created by Jie on 15/11/16.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnnotationModel.h"
@interface AreaCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *distanceLab;
@property (nonatomic,strong) UIButton *locationBtn;
-(void)setModel:(AnnotationModel *)newModel;
@end
