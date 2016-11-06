//
//  AnnotationModel.h
//  FreshMan
//
//  Created by Jie on 15/9/23.
//  Copyright © 2015年 湘汇天承. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationModel : NSObject
@property (nonatomic,strong) NSString *annotationID;//自取点ID
@property (nonatomic,strong) NSString *name;//自取点名称
@property (nonatomic,strong) NSString *time;//供货时间
@property (nonatomic,strong) NSString *address;//自取点地址
@property (nonatomic,strong) NSString *coordinateX;//经纬度x
@property (nonatomic,strong) NSString *coordinateY;//经纬度y
@property (nonatomic,strong) NSString *staff;//自取点店员
@property (nonatomic,strong) NSString *phone;//自取点店员电话
@property (nonatomic,strong) NSString *distance;//自取点距离

@end
