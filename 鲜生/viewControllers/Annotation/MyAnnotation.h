//
//  MyAnnotation.h
//  VamaMap
//
//  Created by DMG on 13-4-30.
//  Copyright (c) 2013年 DMG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    myMapAnnotationTypePig = 1
} myMapAnnotationType;

@interface MyAnnotation : NSObject<MKAnnotation>{
    NSString *title;
    NSString *subtitle;
    NSString *logoImage;
    CLLocationCoordinate2D coordinate;
    myMapAnnotationType annotationType;
    NSInteger buttonTag;
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,assign) myMapAnnotationType annotationType;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *subtitle;
@property (nonatomic,strong) NSString *logoImage;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic) NSInteger buttonTag;

@end
