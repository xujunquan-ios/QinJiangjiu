/*
 * RNSwipeViewController
 *
 * Created by Ryan Nystrom on 10/2/12.
 * Copyright (c) 2012 Ryan Nystrom. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "RNSwipeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "RNDirectionPanGestureRecognizer.h"
#import "UIView+Sizes.h"
#import "MyViewController.h"

NSString * const RNSwipeViewControllerLeftWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerLeftWillAppear";
NSString * const RNSwipeViewControllerLeftDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerLeftDidAppear";
NSString * const RNSwipeViewControllerRightWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerRightWillAppear";
NSString * const RNSwipeViewControllerRightDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerRightDidAppear";
NSString * const RNSwipeViewControllerBottomWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerBottomWillAppear";
NSString * const RNSwipeViewControllerBottomDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerBottomDidAppear";
NSString * const RNSwipeViewControllerCenterWillAppear = @"com.whoisryannystrom.RNSwipeViewControllerCenterWillAppear";
NSString * const RNSwipeViewControllerCenterDidAppear = @"com.whoisryannystrom.RNSwipeViewControllerCenterDidAppear";

static CGFloat kRNSwipeMaxFadeOpacity = 0.5f;
static CGFloat kRNSwipeDefaultDuration = 0.3f;

@interface RNSwipeViewController ()

@property (assign, nonatomic, readwrite) BOOL isToggled;
@property (assign, nonatomic, readwrite) UIView *centerContainer;
@property (assign, nonatomic, readwrite) UIView *leftContainer;
@property (assign, nonatomic, readwrite) UIView *rightContainer;
@property (assign, nonatomic, readwrite) UIView *bottomContainer;

@end

@implementation RNSwipeViewController {
    UIView *_fadeView;
    
    RNDirection _activeDirection;
    UIView *_activeContainer;
    
    RNDirectionPanGestureRecognizer *_panGesture;
    
    UITapGestureRecognizer *_tapGesture;
    
    CGRect _centerOriginal;
    
    CGRect _leftOriginal;
    CGRect _leftActive;
    CGRect _rightOriginal;
    CGRect _rightActive;
    CGRect _bottomOriginal;
    CGRect _bottomActive;
    
    CGPoint _centerLastPoint;
    
    BOOL _isAnimating;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}

- (id)init {
    if (self = [super init]) {
        [self _init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

// initial vars
- (void)_init {
    _visibleState = RNSwipeVisibleCenter;
    
    _leftVisibleWidth = 200.f;
    _rightVisibleWidth = 200.f;
    _bottomVisibleHeight = 300.0f;
    
    _activeContainer = nil;
    
    _centerOriginal = CGRectZero;
    _leftOriginal = CGRectZero;
    _rightOriginal = CGRectZero;
    _bottomOriginal = CGRectZero;
    
    _leftActive = CGRectZero;
    _rightActive = CGRectZero;
    _bottomActive = CGRectZero;
    
    _canShowBottom = YES;
    _canShowLeft = YES;
    _canShowRight = YES;
    
    _isAnimating = NO;
    _enableGesture = YES;
}

- (void)dealloc {
    self.centerContainer = nil;
    self.leftContainer = nil;
    self.rightContainer = nil;
    self.bottomContainer = nil;
    [_fadeView release];
    [_panGesture release];
    [_tapGesture release];
    
    if (IS_IOS_7) {
        [_centerViewController removeFromParentViewController];
        [_rightViewController removeFromParentViewController];
        [_leftViewController removeFromParentViewController];
        [_bottomViewController removeFromParentViewController];
    }
    
    self.centerViewController = nil;
    self.rightViewController = nil;
    self.leftViewController = nil;
    self.bottomViewController = nil;
    [super dealloc];
}

#pragma mark - Viewcontroller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.centerContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    self.centerContainer.clipsToBounds = NO;
    self.centerContainer.layer.masksToBounds = NO;
    
    _centerOriginal = self.centerContainer.frame;
    
    self.rightContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.leftContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    
    self.bottomContainer = [[UIView alloc] initWithFrame:self.view.bounds];
    
    _centerLastPoint = CGPointZero;
    
    [self _layoutRightContainer];
    [self _layoutLeftContainer];
    [self _layoutBottomContainer];
    
    [self.view addSubview:self.rightContainer];
    [self.view addSubview:self.leftContainer];
    [self.view addSubview:self.bottomContainer];
    [self.view addSubview:self.centerContainer];
    
    _fadeView = [[UIView alloc] initWithFrame:self.centerContainer.bounds];
    _fadeView.backgroundColor = [UIColor blackColor];
    _fadeView.alpha = 0.f;
    _fadeView.hidden = YES;
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    _panGesture = [[RNDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePan:)];
    _panGesture.minimumNumberOfTouches = 1;
    _panGesture.maximumNumberOfTouches = 1;
    _panGesture.delegate = self;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerViewWasTapped:)];
    _tapGesture.numberOfTapsRequired = 1;
    
    [self.view addGestureRecognizer:_panGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self _layoutContainersAnimated:NO duration:0.f];
    if (self.visibleState == RNSwipeVisibleCenter) {
//        if ([self.centerViewController respondsToSelector:@selector(currentStatusStyle)]) {
//            [[UIApplication sharedApplication] setStatusBarStyle:
//             ((MyViewController*)self.centerViewController).currentStatusStyle];
//        } else {
//            [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_COLORFUL];
//        }
    } else {
//        [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_DARK];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - Public methods

- (void)showLeft {
    if (self.leftViewController) {
        _activeContainer = self.leftContainer;
        [self _sendCenterToPoint:CGPointMake(self.leftVisibleWidth, 0) panel:self.leftContainer toPoint:_leftActive.origin duration:kRNSwipeDefaultDuration];
        self.visibleState = RNSwipeVisibleLeft;
//        [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_DARK];
    }
}

- (void)showRight {
    if (self.rightViewController) {
        _rightViewController.view.hidden = NO;
        _activeContainer = self.rightContainer;
        [self _sendCenterToPoint:CGPointMake(-1 * self.rightVisibleWidth, 0) panel:self.rightContainer toPoint:_rightActive.origin duration:kRNSwipeDefaultDuration];
        self.visibleState = RNSwipeVisibleRight;
//        [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_DARK];
    }
}

- (void)showBottom {
    if (self.bottomViewController) {
        _activeContainer = self.bottomContainer;
        [self _sendCenterToPoint:CGPointMake(0, -1 * self.bottomVisibleHeight) panel:self.bottomContainer toPoint:_bottomActive.origin duration:kRNSwipeDefaultDuration];
        self.visibleState = RNSwipeVisibleBottom;
    }
}

- (void)resetView {
    [self _layoutContainersAnimated:YES duration:kRNSwipeDefaultDuration];
}

#pragma mark - Layout

- (void)_layoutRightContainer {
    self.rightContainer.width = _rightVisibleWidth;
    
    _rightOriginal = self.rightContainer.bounds;
    _rightOriginal.origin.x = _centerOriginal.size.width;
    
    _rightActive = _rightOriginal;
    _rightActive.origin.x = self.centerContainer.width - _rightActive.size.width;
}

- (void)_layoutLeftContainer {
    self.leftContainer.width = self.leftVisibleWidth;
    
    _leftOriginal = self.leftContainer.bounds;
    _leftOriginal.origin.x = - _leftOriginal.size.width;
    
    _leftActive = _leftOriginal;
    _leftActive.origin = CGPointZero;
}

- (void)_layoutBottomContainer {
    self.bottomContainer.height = self.bottomVisibleHeight;
    
    _bottomOriginal = self.bottomContainer.bounds;
    _bottomOriginal.origin.y = _centerOriginal.size.height;
    
    _bottomActive = _bottomOriginal;
    _bottomActive.origin.y = self.centerContainer.height - _bottomActive.size.height;
}

#pragma mark - Setters

- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (_centerViewController != centerViewController) {
        [_centerViewController.view removeFromSuperview];
        if (IS_IOS_7) {
            [_centerViewController removeFromParentViewController];
        }
        [_centerViewController release];
        
        if (centerViewController) {
            _centerViewController = [centerViewController retain];
            
            [self addChildViewController:_centerViewController];
            
            [self _loadCenter];
            
            [self.centerContainer addSubview:_fadeView];
        }
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (_rightViewController != rightViewController) {
        [_rightViewController.view removeFromSuperview];
        if (IS_IOS_7) {
            [_rightViewController removeFromParentViewController];
        }
        [_rightViewController release];
        
        if (rightViewController) {
            rightViewController.view.frame = self.rightContainer.bounds;
            _rightViewController = [rightViewController retain];
            _rightViewController.view.hidden = YES;
        
            [self addChildViewController:_rightViewController];
        
            [self _loadRight];
        }
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (_leftViewController != leftViewController) {
        [_leftViewController.view removeFromSuperview];
        if (IS_IOS_7) {
            [_leftViewController removeFromParentViewController];
        }
        [_leftViewController release];
        
        if (leftViewController) {
            leftViewController.view.frame = self.leftContainer.bounds;
            _leftViewController = [leftViewController retain];
            
            [self addChildViewController:_leftViewController];
            
            [self _loadLeft];
        }
        
    }
}

- (void)setBottomViewController:(UIViewController *)bottomViewController {
    if (_bottomViewController != bottomViewController) {
        [_bottomViewController.view removeFromSuperview];
        if (IS_IOS_7) {
            [_bottomViewController removeFromParentViewController];
        }
        [_bottomViewController release];
        
        if (bottomViewController) {
            bottomViewController.view.frame = self.bottomContainer.bounds;
            _bottomViewController = [bottomViewController retain];
            
            [self addChildViewController:_bottomViewController];
            
            [self _loadBottom];
        }
    }
}

- (void)setVisibleState:(RNSwipeVisible)visibleState {
    _visibleState = visibleState;
    if (visibleState == RNSwipeVisibleCenter) {
        // remove shadows
        [UIView animateWithDuration:0.1f
                              delay:0
                            options:kNilOptions
                         animations:^{
                             self.leftContainer.layer.shadowOpacity = 0.f;
                             
                             self.rightContainer.layer.shadowOpacity = 0.f;
                             
                             self.bottomContainer.layer.shadowOpacity = 0.f;
                         }
                         completion:^(BOOL finished) {
                             self.leftContainer.layer.shadowRadius = 0.f;
                             self.leftContainer.layer.shadowColor = nil;
                             
                             self.rightContainer.layer.shadowRadius = 0.f;
                             self.rightContainer.layer.shadowColor = nil;
                             
                             self.bottomContainer.layer.shadowRadius = 0.f;
                             self.bottomContainer.layer.shadowColor = nil;
                         }];
    }
}

// when we are toggled, add a tap gesture to the center view
- (void)setIsToggled:(BOOL)isToggled {
    if (isToggled) {
        [self.centerContainer addGestureRecognizer:_tapGesture];
    }
    else {
        [self.centerContainer removeGestureRecognizer:_tapGesture];
    }
    _isToggled = isToggled;
}

- (void)setLeftVisibleWidth:(CGFloat)leftVisibleWidth {
    if (_leftVisibleWidth != leftVisibleWidth) {
        _leftVisibleWidth = leftVisibleWidth;
        [self _layoutLeftContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
    }
}

- (void)setRightVisibleWidth:(CGFloat)rightVisibleWidth {
    if (_rightVisibleWidth != rightVisibleWidth) {
        _rightVisibleWidth = rightVisibleWidth;
        [self _layoutRightContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
    }
}

- (void)setBottomVisibleHeight:(CGFloat)bottomVisibleHeight {
    if (_bottomVisibleHeight != bottomVisibleHeight) {
        _bottomVisibleHeight = bottomVisibleHeight;
        [self _layoutBottomContainer];
        [self _layoutContainersAnimated:NO duration:0.f];
    }
}

- (void)setEnableGesture:(BOOL)enableGesture {
    _enableGesture = enableGesture;
    _panGesture.enabled = enableGesture;
}

- (void)setEnablePopGesture:(BOOL)enablePopGesture {
    _enablePopGesture = enablePopGesture;
}

- (void)enablePopGesture:(BOOL)enable {
    if (enable) {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(_handlePan:)];
            _panGesture.enabled = NO;
        }
    } else {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            [self.navigationController.interactivePopGestureRecognizer removeTarget:self action:@selector(_handlePan:)];
            _panGesture.enabled = YES;
        }
    }
}

-(void)removeDelegates{
    if ([self.swipeDelegate respondsToSelector:@selector(UIViewControllerBack:)]) {
        [self.swipeDelegate performSelector:@selector(UIViewControllerBack:) withObject:self];
    }
    [_panGesture removeTarget:self action:@selector(_handlePan:)];
    [_tapGesture removeTarget:self action:@selector(centerViewWasTapped:)];
    [self enablePopGesture:NO];
    if (_centerViewController) {
        [self release];
    }
    if (_rightViewController) {
        [self release];
    }
    if (_leftViewController) {
        [self release];
    }
    if (_bottomViewController) {
        [self release];
    }
}

#pragma mark - Getters

- (UIViewController*)visibleController {
    if (self.visibleState == RNSwipeVisibleLeft) return self.leftViewController;
    if (self.visibleState == RNSwipeVisibleRight) return self.rightViewController;
    if (self.visibleState == RNSwipeVisibleBottom) return self.bottomViewController;
    return self.centerViewController;
}

- (BOOL)canShowBottom {
    if (! self.bottomViewController) {
        return NO;
    }
    return _canShowBottom;
}

- (BOOL)canShowLeft {
    if (! self.leftViewController) {
        return NO;
    }
    return _canShowLeft;
}

- (BOOL)canShowRight {
    if (! self.rightViewController) {
        return NO;
    }
    return _canShowRight;
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark - Private Helpers

- (void)_layoutContainersAnimated:(BOOL)animate duration:(NSTimeInterval)duration {
    [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerCenterWillAppear object:nil];
    if (self.centerViewController && [self.centerViewController respondsToSelector:@selector(swipeController:willShowController:)]) {
        [self.centerViewController performSelector:@selector(swipeController:willShowController:) withObject:self withObject:self.centerViewController];
    }
    
    //    [self.centerViewController viewWillAppear:animate];
    
    CGRect leftFrame = self.view.bounds;
    CGRect rightFrame = self.view.bounds;
    CGRect bottomFrame = self.view.bounds;
    
    leftFrame.size.width = self.leftVisibleWidth;;
    leftFrame.origin.x = leftFrame.size.width * -1;
    
    rightFrame.size.width = self.rightVisibleWidth;
    rightFrame.origin.x = self.centerContainer.frame.origin.x + self.centerContainer.frame.size.width;
    
    bottomFrame.size.height = self.bottomVisibleHeight;
    bottomFrame.origin.y = self.view.bounds.size.height;
    
    void (^block)(void) = [self _toResetContainers];
    
    if (_enablePopGesture) {
        [self enablePopGesture:YES];
    }
    
    if (animate) {
        _fadeView.hidden = NO;
        [UIView animateWithDuration:duration
                              delay:0
                            options:kNilOptions
                         animations:block
                         completion:^(BOOL finished){
                             if (finished) {
                                 self.isToggled = NO;
                                 
                                 //                                 [self.centerViewController viewDidAppear:animate];
                                 
                                 _isAnimating = NO;
                                 _centerLastPoint = CGPointZero;
                                 _fadeView.hidden = YES;
                                 _activeContainer = self.centerContainer;
                                 
                                 self.visibleState = RNSwipeVisibleCenter;
                                 _rightViewController.view.hidden = YES;
//                                 if ([self.centerViewController respondsToSelector:@selector(currentStatusStyle)]) {
//                                     [[UIApplication sharedApplication] setStatusBarStyle:
//                                      ((MyViewController*)self.centerViewController).currentStatusStyle];
//                                 } else {
//                                     [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_COLORFUL];
//                                 }
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerCenterDidAppear object:nil];
                                 if (self.centerViewController && [self.centerViewController respondsToSelector:@selector(swipeController:didShowController:)]) {
                                     [self.centerViewController performSelector:@selector(swipeController:didShowController:) withObject:self withObject:self.centerViewController];
                                 }
                             }
                         }];
    }
    else {
        _fadeView.hidden = YES;
        block();
    }
    
}

- (void (^)(void))_toResetContainers {
    return Block_copy(^{
        self.leftContainer.frame = _leftOriginal;
        self.rightContainer.frame = _rightOriginal;
        self.bottomContainer.frame = _bottomOriginal;
        self.centerContainer.frame = _centerOriginal;
        _fadeView.alpha = 0.f;
    });
}

#pragma mark - Adding Views

- (void)_loadCenter {
    if (self.centerViewController && ! self.centerViewController.view.superview) {
        self.centerViewController.view.frame = self.centerContainer.bounds;
        [self.centerContainer addSubview:self.centerViewController.view];
    }
}

- (void)_loadLeft {
    if (self.leftViewController && ! self.leftViewController.view.superview) {
        self.leftViewController.view.frame = self.leftContainer.bounds;
        [self.leftContainer addSubview:self.leftViewController.view];
    }
}

- (void)_loadRight {
    if (self.rightViewController && ! self.rightViewController.view.superview) {
        self.rightViewController.view.frame = self.rightContainer.bounds;
        [self.rightContainer addSubview:self.rightViewController.view];
    }
}

- (void)_loadBottom {
    if (self.bottomViewController && ! self.bottomViewController.view.superview) {
        self.bottomViewController.view.frame = self.bottomContainer.bounds;
        [self.bottomContainer addSubview:self.bottomViewController.view];
    }
}

#pragma mark - Animations

- (CGFloat)_remainingDuration:(CGFloat)position threshold:(CGFloat)threshold {
    CGFloat maxDuration = kRNSwipeDefaultDuration;
    threshold /= 2.f;
    CGFloat suggestedDuration = maxDuration * (position / (CGFloat)threshold);
    if (suggestedDuration < 0.05f) {
        return 0.05f;
    }
    if (suggestedDuration < maxDuration) {
        return suggestedDuration;
    }
    return maxDuration;
}

- (CGFloat)_filterTop:(CGFloat)translation {
    if (! self.canShowBottom && self.visibleState == RNSwipeVisibleCenter) {
        return 0.f;
    }
    
    if (self.centerContainer.top >= 0.f) {
        return 0.f;
    }
    return translation + _centerLastPoint.y;
}

- (CGFloat)_filterLeft:(CGFloat)translation {
    if (! self.canShowRight && self.visibleState == RNSwipeVisibleCenter) {
        return 0.f;
    }
    
    if (self.centerContainer.left <= -1 * self.rightVisibleWidth) {
        return self.rightVisibleWidth * -1 + translation / 10.f;
    }
    return translation + _centerLastPoint.x;
}

- (CGFloat)_filterRight:(CGFloat)translation {
    if (! self.canShowLeft && self.visibleState == RNSwipeVisibleCenter) {
        return 0.f;
    }
    
    if (self.centerContainer.left >= self.leftVisibleWidth) {
        return self.leftVisibleWidth + translation / 10.f;
    }
    return translation + _centerLastPoint.x;
}

- (CGFloat)_filterBottom:(CGFloat)translation {
    if (! self.canShowBottom && self.visibleState == RNSwipeVisibleCenter) {
        return 0.f;
    }
    
    if (abs(self.centerContainer.top) >= self.bottomVisibleHeight) {
        return self.bottomVisibleHeight * -1;
    }
    return translation + _centerLastPoint.y;
}

- (void)_sendCenterToPoint:(CGPoint)centerPoint panel:(UIView*)container toPoint:(CGPoint)containerPoint duration:(NSTimeInterval)duration {
    _fadeView.hidden = NO;
    
    //    [self.visibleController viewWillAppear:YES];
    //    [self.centerViewController viewWillDisappear:YES];
    
    if (_enablePopGesture) {
        [self enablePopGesture:NO];
    }
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:kNilOptions
                     animations:^{
                         self.centerContainer.origin = centerPoint;
                         container.origin = containerPoint;
                         _fadeView.alpha = kRNSwipeMaxFadeOpacity;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             _isAnimating = NO;
                             _centerLastPoint = self.centerContainer.origin;
                             _activeContainer.layer.shouldRasterize = NO;
                             self.isToggled = YES;
                             
                             //                             [self.visibleController viewDidAppear:YES];
                             //                             [self.centerViewController viewDidDisappear:YES];
                             
                             NSString *notificationKey = nil;
                             UIViewController *controller = nil;
                             if (_activeContainer == self.centerContainer) {
                                 notificationKey = RNSwipeViewControllerCenterDidAppear;
                                 controller = self.centerViewController;
                             }
                             else if (_activeContainer == self.leftContainer) {
                                 notificationKey = RNSwipeViewControllerLeftDidAppear;
                                 controller = self.leftViewController;
                             }
                             else if (_activeContainer == self.rightContainer) {
                                 notificationKey = RNSwipeViewControllerRightDidAppear;
                                 controller = self.rightViewController;
                             }
                             else if (_activeContainer == self.bottomContainer) {
                                 notificationKey = RNSwipeViewControllerBottomDidAppear;
                                 controller = self.bottomViewController;
                             }
                             if (notificationKey) {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:notificationKey object:nil];
                             }
                             if (controller &&
                                 [controller respondsToSelector:@selector(swipeController:didShowController:)]) {
                                 [controller performSelector:@selector(swipeController:didShowController:) withObject:self withObject:controller];
                             }
                         }
                     }];
}

- (void)_handlePan:(RNDirectionPanGestureRecognizer*)recognizer {
    // beginning a pan gesture
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _activeDirection = recognizer.direction;
        
        _isAnimating = YES;
        
        switch (_activeDirection) {
            case RNDirectionLeft: {
                _rightViewController.view.hidden = NO;
                _activeContainer = self.rightContainer;
                
                if (self.visibleState == RNSwipeVisibleCenter) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerLeftWillAppear object:nil];
                    
                    if (self.rightViewController && [self.rightViewController respondsToSelector:@selector(swipeController:willShowController:)]) {
                        [self.rightViewController performSelector:@selector(swipeController:willShowController:) withObject:self withObject:self.rightViewController];
                    }
                }
            }
                break;
            case RNDirectionRight: {
                _activeContainer = self.leftContainer;
                
                if (self.visibleState == RNSwipeVisibleCenter) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerRightWillAppear object:nil];
                    
                    if (self.leftViewController && [self.leftViewController respondsToSelector:@selector(swipeController:willShowController:)]) {
                        [self.leftViewController performSelector:@selector(swipeController:willShowController:) withObject:self withObject:self.leftViewController];
                    }
                }
            }
                break;
            case RNDirectionDown:
            case RNDirectionUp: {
                _activeContainer = self.bottomContainer;
                
                if (self.visibleState == RNSwipeVisibleCenter) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:RNSwipeViewControllerBottomWillAppear object:nil];
                    
                    if (self.bottomViewController && [self.bottomViewController respondsToSelector:@selector(swipeController:willShowController:)]) {
                        [self.bottomViewController performSelector:@selector(swipeController:willShowController:) withObject:self withObject:self.bottomViewController];
                    }
                }
            }
                break;
        }
        
        // add shadow to active layer
        // could already be there if layer was visible
        _activeContainer.layer.shadowColor = [UIColor blackColor].CGColor;
        _activeContainer.layer.shadowRadius = 5.f;
        _activeContainer.layer.shadowOffset = CGSizeZero;
        _activeContainer.layer.shadowOpacity = 0.5f;
        
        // turn ON rasterizing for scrolling performance
        _activeContainer.layer.shouldRasterize = NO;
        
        // ensure fadeing view is visible
        _fadeView.hidden = NO;
    }
    
    // changing a pan gesture
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translate = [recognizer translationInView:self.centerContainer];
        BOOL doFade = NO;
        
        switch (_activeDirection) {
            case RNDirectionLeft: {
                if (self.visibleState != RNSwipeVisibleBottom && self.visibleState != RNSwipeVisibleRight) {
                    CGFloat left = recognizer.direction == RNDirectionLeft ? [self _filterLeft:translate.x] : [self _filterRight:translate.x];
                    self.centerContainer.left = left;
                    self.rightContainer.left = self.centerContainer.right;
                    self.leftContainer.right= self.centerContainer.left;
                    doFade = YES;
                }
            }
                break;
            case RNDirectionRight: {
                if (self.visibleState != RNSwipeVisibleBottom && self.visibleState != RNSwipeVisibleLeft) {
                    CGFloat left = recognizer.direction == RNDirectionLeft ? [self _filterLeft:translate.x] : [self _filterRight:translate.x];
                    self.centerContainer.left = left;
                    self.rightContainer.left = self.centerContainer.right;
                    self.leftContainer.right= self.centerContainer.left;
                    doFade = YES;
                }
            }
                break;
            case RNDirectionDown: {
                if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                    self.centerContainer.top = [self _filterTop:translate.y];
                    _activeContainer.top = _bottomOriginal.origin.y + [self _filterTop:translate.y];
                    doFade = YES;
                }
            }
                break;
            case RNDirectionUp: {
                if (self.visibleState != RNSwipeVisibleLeft && self.visibleState != RNSwipeVisibleRight) {
                    self.centerContainer.top = [self _filterBottom:translate.y];
                    _activeContainer.top = _bottomOriginal.origin.y + [self _filterBottom:translate.y];
                    doFade = YES;
                }
            }
                break;
        }
        
        // calculate the amount of fading
        // max static var defined as kRNSwipeMaxFadeOpacity in top of file
        if (doFade) {
            CGFloat position = 0.f;
            CGFloat threshold = 0.f;
            switch (_activeDirection) {
                case RNDirectionLeft: {
                    position = abs(self.centerContainer.left);
                    threshold = self.rightVisibleWidth;
                }
                    break;
                case RNDirectionRight: {
                    position = abs(self.centerContainer.left);
                    threshold = self.leftVisibleWidth;
                }
                    break;
                case RNDirectionDown:
                case RNDirectionUp: {
                    position = abs(self.centerContainer.top);
                    threshold = self.bottomVisibleHeight;
                }
                    break;
            }
            // max value is kRNSwipeMaxFadeOpacity, caluclation isn't perfect but i dont care
            CGFloat alpha = kRNSwipeMaxFadeOpacity * (position / (CGFloat)threshold);
            if (alpha > kRNSwipeMaxFadeOpacity) alpha = kRNSwipeMaxFadeOpacity;
            _fadeView.alpha = alpha;
        }
    }
    
    // ending a pan gesture
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // seems redundant, but it isn't
        if (self.centerContainer.left > self.leftVisibleWidth / 2.f) {
            // left will be shown
            CGFloat duration = [self _remainingDuration:abs(self.centerContainer.left) threshold:self.leftVisibleWidth];
            [self _sendCenterToPoint:CGPointMake(self.leftVisibleWidth, 0) panel:self.leftContainer toPoint:_leftActive.origin duration:duration];
            self.visibleState = RNSwipeVisibleLeft;
//            [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_DARK];
        }
        else if (self.centerContainer.left < (self.rightVisibleWidth / -2.f)) {
            // right will be shown
            CGFloat duration = [self _remainingDuration:abs(self.centerContainer.left) threshold:self.rightVisibleWidth];
            [self _sendCenterToPoint:CGPointMake(-1 * self.rightVisibleWidth, 0) panel:self.rightContainer toPoint:_rightActive.origin duration:duration];
            self.visibleState = RNSwipeVisibleRight;
//            [[UIApplication sharedApplication] setStatusBarStyle:STYLE_STATUS_BAR_DARK];
        }
        else if (self.centerContainer.top < self.bottomVisibleHeight / -2.f) {
            // bottom will be shown
            CGFloat duration = [self _remainingDuration:abs(self.centerContainer.top) threshold:self.bottomVisibleHeight];
            [self _sendCenterToPoint:CGPointMake(0, -1 * self.bottomVisibleHeight) panel:self.bottomContainer toPoint:_bottomActive.origin duration:duration];
            self.visibleState = RNSwipeVisibleBottom;
        }
        else {
            // not enough visible area, clear the scene
            CGFloat position = self.centerContainer.left == 0.f ? abs(self.centerContainer.top) : abs(self.centerContainer.left);
            CGFloat threshold = self.centerContainer.left == 0.f ? self.bottomVisibleHeight : self.leftVisibleWidth;
            CGFloat duration = [self _remainingDuration:position threshold:threshold];
            [self _layoutContainersAnimated:YES duration:duration];
            self.visibleState = RNSwipeVisibleCenter;
        }
    }
}

#pragma mark - Tap Gesture

- (void)centerViewWasTapped:(UITapGestureRecognizer*)recognizer {
    [self _layoutContainersAnimated:YES duration:kRNSwipeDefaultDuration];
}

@end
