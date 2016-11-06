//
//  MyAnnotationView.m
//  VamaMap
//
//  Created by DMG on 13-4-30.
//  Copyright (c) 2013年 DMG. All rights reserved.
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

@synthesize imageView;
#define kHeight 20
#define kWidth  20
#define kBorder 2

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    MyAnnotation *myAnnotation = (MyAnnotation *)annotation;
//    if ([myAnnotation annotationType] == myMapAnnotationTypePig) {
        self = [super initWithAnnotation:myAnnotation reuseIdentifier:reuseIdentifier];
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"position_annotation.png"]];
        imageView.frame = CGRectMake(kBorder, kBorder, kWidth - 2*kBorder, kWidth - 2*kBorder);
        [self addSubview:imageView];
//    }
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
