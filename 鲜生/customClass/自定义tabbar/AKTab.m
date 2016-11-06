// AKTab.m
//
// Copyright (c) 2012 Ali Karagoz (http://alikaragoz.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKTab.h"

// cross fade animation duration.
static const float kAnimationDuration = 0.15;

// Padding of the content
static const float kPadding = 4.0;

// Margin between the image and the title
static const float kMargin = 2.0;

// Margin at the top
static const float kTopMargin = 2.0;

@interface AKTab ()

@property (nonatomic, strong) UIButton *badgeButton;

// Permits the cross fade animation between the two images, duration in seconds.
- (void)animateContentWithDuration:(CFTimeInterval)duration;

@end

@implementation AKTab

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.backgroundColor = [UIColor clearColor];
        _titleIsHidden = NO;
    }
    return self;
}

#pragma mark - Touche handeling

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self animateContentWithDuration:kAnimationDuration];
}

#pragma mark - Animation

- (void)animateContentWithDuration:(CFTimeInterval)duration
{    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contents"];
    animation.duration = duration;
    [self.layer addAnimation:animation forKey:@"contents"];
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    // If the height of the container is too short, we do not display the title
    CGFloat offset = 1.0;
    
    if (!_minimumHeightToDisplayTitle)
        _minimumHeightToDisplayTitle = _tabBarHeight - offset;
    
    BOOL displayTabTitle = (CGRectGetHeight(rect) + offset >= _minimumHeightToDisplayTitle) ? YES : NO;
    
    if (_titleIsHidden) {
        displayTabTitle = NO;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Container, basically centered in rect
    CGRect container = CGRectInset(rect, kPadding, kPadding);
    container.size.height -= kTopMargin;
    container.origin.y += kTopMargin;
    
    // Tab's image
    UIImage *image = [UIImage imageNamed:!self.selected?_tabImageWithName:[NSString stringWithFormat:@"%@_click",_tabImageWithName]];
    
    // Getting the ratio for eventual scaling
    CGFloat ratio = image.size.width / image.size.height;
    
    // Setting the imageContainer's size.
    CGRect imageRect = CGRectZero;
    imageRect.size = image.size;
    
    // Title label
    UILabel *tabTitleLabel = [[UILabel alloc] init];
    tabTitleLabel.text = self.selected?@"":_tabTitle;
    tabTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:11.0];
    CGSize labelSize = [tabTitleLabel.text sizeWithFont:tabTitleLabel.font forWidth:CGRectGetWidth(rect) lineBreakMode:NSLineBreakByTruncatingMiddle ];
    
    CGRect labelRect = CGRectZero;
    
    labelRect.size.height = (displayTabTitle) ? labelSize.height : 0;
    
    // Container of the image + label (when there is room)
    CGRect content = CGRectZero;
    content.size.width = CGRectGetWidth(container);
    
    // We determine the height based on the longest side of the image (when not square) , presence of the label and height of the container
    content.size.height = MIN(MAX(CGRectGetWidth(imageRect), CGRectGetHeight(imageRect)) + ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0), CGRectGetHeight(container));
    
    // Now we move the boxes
    content.origin.x = floorf(CGRectGetMidX(container) - CGRectGetWidth(content) / 2);
    content.origin.y = floorf(CGRectGetMidY(container) - CGRectGetHeight(content) / 2);
    
    labelRect.size.width = CGRectGetWidth(content);
    labelRect.origin.x = CGRectGetMinX(content);
    labelRect.origin.y = CGRectGetMaxY(content) - CGRectGetHeight(labelRect);
    
    if (!displayTabTitle) {
        labelRect = CGRectZero;
    }
    
    CGRect imageContainer = content;

    imageContainer.size.height = !self.selected ? CGRectGetHeight(content) - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0):image.size.height;
    
    // When the image is not square we have to make sure it will not go beyond the bonds of the container
    if (CGRectGetWidth(imageRect) >= CGRectGetHeight(imageRect)) {
        imageRect.size.width = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.height = floorf(CGRectGetWidth(imageRect) / ratio);
        
        
    } else {
        imageRect.size.height = MIN(CGRectGetHeight(imageRect), MIN(CGRectGetWidth(imageContainer), CGRectGetHeight(imageContainer)));
        imageRect.size.width = floorf(CGRectGetHeight(imageRect) * ratio);
    }
    
    imageRect.origin.x = floorf(CGRectGetMidX(content) - CGRectGetWidth(imageRect) / 2);
    imageRect.origin.y = floorf(CGRectGetMidY(imageContainer) - CGRectGetHeight(imageRect) / 2);
    
//    CGFloat offsetY = rect.size.height - ((displayTabTitle) ? (kMargin + CGRectGetHeight(labelRect)) : 0) + kTopMargin;
    
    if (!self.selected) {
        [image drawInRect:imageRect];
        
        if (displayTabTitle) {
            CGContextSaveGState(ctx);
            {
                UIColor *textColor = [UIColor colorWithRed:0.461 green:0.461 blue:0.461 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _textColor ? _textColor.CGColor : textColor.CGColor);
                [tabTitleLabel.text drawInRect:labelRect withFont:tabTitleLabel.font lineBreakMode:NSLineBreakByTruncatingMiddle  alignment:NSTextAlignmentCenter];
            }
            CGContextRestoreGState(ctx);
        }
        
    } else if (self.selected) {
        [image drawInRect:imageRect];
        
        if (displayTabTitle) {
            CGContextSaveGState(ctx);
            {
                UIColor *textColor = [UIColor colorWithRed:0.961 green:0.961 blue:0.961 alpha:1.0];
                CGContextSetFillColorWithColor(ctx, _selectedTextColor ? _selectedTextColor.CGColor : textColor.CGColor);
                [tabTitleLabel.text drawInRect:labelRect withFont:tabTitleLabel.font lineBreakMode:NSLineBreakByTruncatingMiddle  alignment:NSTextAlignmentCenter];
            }
            CGContextRestoreGState(ctx);
        }
        
    }
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (self.badgeButton) {
        NSInteger swidth = 12;
        if (self.frame.size.width<75) {
            swidth = 7;
        }else if (self.frame.size.width>75) {
            swidth = 16;
        }
        
        if (self.badgeButton.currentTitle) {
            self.badgeButton.frame = CGRectMake(frame.size.width-16-swidth, self.badgeButton.frame.origin.y, self.badgeButton.frame.size.width, self.badgeButton.frame.size.height);
        } else {
            self.badgeButton.frame = CGRectMake(frame.size.width-16-swidth+4, self.badgeButton.frame.origin.y, self.badgeButton.frame.size.width, self.badgeButton.frame.size.height);
        }
    }
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    if (!self.badgeButton) {
        self.badgeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.badgeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.badgeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.badgeButton setBackgroundImage:[UIImage imageNamed:@"round.png"] forState:UIControlStateNormal];
        [self addSubview:self.badgeButton];
    }
    
    NSInteger swidth = 12;
    if (self.frame.size.width<75) {
        swidth = 7;
    }else if (self.frame.size.width>75) {
        swidth = 16;
    }
    NSString *badgeText = [NSString stringWithFormat:@"%ld",(long)_badgeNumber];
    if (_badgeNumber > 99) {
        badgeText = @"99+";
        [self.badgeButton setTitle:badgeText forState:UIControlStateNormal];
        [self.badgeButton setBackgroundImage:[UIImage imageNamed:@"round1.png"] forState:UIControlStateNormal];
        [self.badgeButton setFrame:CGRectMake(self.frame.size.width-16-swidth, 2, 28, 16)];
        //NSLog(@"width = %f, height =  %f",self.frame.size.width,self.frame.size.height);
    }else if (_badgeNumber > 9 && _badgeNumber <100) {
        [self.badgeButton setTitle:badgeText forState:UIControlStateNormal];
        [self.badgeButton setBackgroundImage:[UIImage imageNamed:@"round1.png"] forState:UIControlStateNormal];
        [self.badgeButton setFrame:CGRectMake(self.frame.size.width-16-swidth, 2, 24, 16)];
        //NSLog(@"width = %f, height =  %f",self.frame.size.width,self.frame.size.height);
    }
    else if (_badgeNumber > 0 && _badgeNumber <10) {
        [self.badgeButton setTitle:badgeText forState:UIControlStateNormal];
        [self.badgeButton setBackgroundImage:[UIImage imageNamed:@"round.png"] forState:UIControlStateNormal];
        [self.badgeButton setFrame:CGRectMake(self.frame.size.width-16-swidth, 2, 16, 16)];
    }
    
    if (_badgeNumber > 0 || _badgeNumber == -1) {
        self.badgeButton.hidden = NO;
    } else {
        self.badgeButton.hidden = YES;
    }
}
@end