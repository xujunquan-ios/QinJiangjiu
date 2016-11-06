//
//  MyAnnotationView.h
//  VamaMap
//
//  Created by DMG on 13-4-30.
//  Copyright (c) 2013年 DMG. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface MyAnnotationView : MKAnnotationView{
    UIImageView *imageView;
}
@property (nonatomic,retain) UIImageView *imageView;
@end
