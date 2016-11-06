//
//  MyAnnotation.m
//  VamaMap
//
//  Created by DMG on 13-4-30.
//  Copyright (c) 2013年 DMG. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize annotationType;
@synthesize logoImage;
@synthesize buttonTag;
@synthesize btn;

-(id)init{
    return self;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)inCoord{
    coordinate = inCoord;
    return self;
}

@end
