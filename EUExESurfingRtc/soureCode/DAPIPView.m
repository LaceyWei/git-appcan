//
//  DAPIPView.m
//  DAPIPViewExample
//
//  Created by Daniel Amitay on 4/15/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import "DAPIPView.h"

@interface DAPIPView ()
{
    UIImageView *_frameView;
    UIImageView *_displayView;
    UIButton    *_hideActionButton;
}

- (CGPoint)closestCornerUnit;
- (CGFloat)frameInsetFromDevice;
- (CGRect)boundsFromDevice;

@end

@implementation DAPIPView

@synthesize borderInsets = _borderInsets;

#pragma mark - Init Methods

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:[self boundsFromDevice]];
    if (self)
    {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _borderInsets = UIEdgeInsetsMake(1.0f,      // top
                                         1.0f,      // left
                                         1.0f,      // bottom
                                         1.0f);     // right
        
        _displayView = [[UIImageView alloc] init];
        _displayView.frame = super.bounds;
         NSLog(@"%@",NSStringFromCGRect(_displayView.frame));
        _displayView.clipsToBounds = YES;
        _displayView.backgroundColor = [UIColor grayColor];
        _displayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                         UIViewAutoresizingFlexibleHeight);
        [super addSubview:_displayView];
        
        _frameView = [[UIImageView alloc] init];
        _frameView.frame = CGRectMake(-[self frameInsetFromDevice],
                                      -[self frameInsetFromDevice],
                                      _displayView.bounds.size.width + [self frameInsetFromDevice] * 2.0f,
                                      _displayView.bounds.size.height + [self frameInsetFromDevice] * 2.0f);
        NSLog(@"%@",NSStringFromCGRect(_frameView.frame));
        _frameView.backgroundColor = [UIColor clearColor];
        _frameView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                       UIViewAutoresizingFlexibleHeight);
        [super addSubview:_frameView];
        
        self.multipleTouchEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
        _borderInsets = UIEdgeInsetsMake(1.0f,      // top
                                         1.0f,      // left
                                         1.0f,      // bottom
                                         1.0f);     // right
        
        _displayView = [[UIImageView alloc] init];
        _displayView.frame = super.bounds;
        NSLog(@"bbbb>>>>>>>>>%@",NSStringFromCGRect(_displayView.frame));
        _displayView.clipsToBounds = YES;
        _displayView.backgroundColor = [UIColor grayColor];
        _displayView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                         UIViewAutoresizingFlexibleHeight);
        [super addSubview:_displayView];
        
        _frameView = [[UIImageView alloc] init];
        _frameView.frame = CGRectMake(-[self frameInsetFromDevice],
                                      -[self frameInsetFromDevice],
                                      _displayView.bounds.size.width + [self frameInsetFromDevice] * 2.0f,
                                      _displayView.bounds.size.height + [self frameInsetFromDevice] * 2.0f);
        _frameView.backgroundColor = [UIColor clearColor];
        _frameView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | 
                                       UIViewAutoresizingFlexibleHeight);
        [super addSubview:_frameView];
        
        self.multipleTouchEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationDidChange)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Touch Methods

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    CGPoint fromLocation = [touch previousLocationInView:self];
    CGPoint toLocation = [touch locationInView:self];
    CGPoint changeLocation = CGPointMake(toLocation.x - fromLocation.x,
                                         toLocation.y - fromLocation.y);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    super.center = CGPointMake(self.center.x + changeLocation.x,
                              self.center.y + changeLocation.y);
    [UIView commitAnimations];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self moveToClosestCornerAnimated:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self moveToClosestCornerAnimated:YES];
}

#pragma mark - Math

- (CGPoint)closestCornerUnit
{
    CGFloat xCenter = (self.superview.bounds.size.width + _borderInsets.left - _borderInsets.right)/2.0f;
    CGFloat yCenter = (self.superview.bounds.size.height + _borderInsets.top - _borderInsets.bottom)/2.0f;
    
    CGFloat xCenterDist = self.center.x - xCenter;
    CGFloat yCenterDist = self.center.y - yCenter;
    
    return CGPointMake(xCenterDist/fabs(xCenterDist),
                       yCenterDist/fabs(yCenterDist));
}

- (CGFloat)frameInsetFromDevice
{
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? 11.0f : 16.0f);
}
- (CGRect)boundsFromDevice
{
    //NSInteger captureFrameWidth = [[NSUserDefaults standardUserDefaults]integerForKey:@"VIDEO_CAPTURE_FRAME_WIDTH"];
    //NSInteger captureFrameHeight = [[NSUserDefaults standardUserDefaults]integerForKey:@"VIDEO_CAPTURE_FRAME_HEIGHT"];
    //应用层调用setVideoAttr设置的分辨率
    NSInteger netFrameWidth = [[NSUserDefaults standardUserDefaults]integerForKey:@"VIDEO_CAPTURE_NET_FRAME_WIDTH"];
    NSInteger netFrameHeight = [[NSUserDefaults standardUserDefaults]integerForKey:@"VIDEO_CAPTURE_NET_FRAME_HEIGHT"];
    
    
    const NSInteger maxWidth = 100;
    double rate = (double)netFrameWidth/(double)maxWidth;
    NSInteger height = netFrameHeight/rate;
    return CGRectMake(0.0f,
                      0.0f,
                      maxWidth,
                      height);
    
    //这是原始大小,但一般情况下是不能这样用的,有可能很大,所以要有比例
}

#pragma mark - Public Commands

- (void)moveToTopLeftAnimated:(BOOL)animated
{
    [self moveToCornerUnit:CGPointMake(-1.0f, -1.0f) animated:animated];
}

- (void)moveToTopRightAnimated:(BOOL)animated
{
    [self moveToCornerUnit:CGPointMake(1.0f, -1.0f) animated:animated];
}

- (void)moveToBottomLeftAnimated:(BOOL)animated
{
    [self moveToCornerUnit:CGPointMake(-1.0f, 1.0f) animated:animated];
}

- (void)moveToBottomRightAnimated:(BOOL)animated
{
    [self moveToCornerUnit:CGPointMake(1.0f, 1.0f) animated:animated];
}

#pragma mark - Private Commands

- (void)moveToClosestCornerAnimated:(BOOL)animated
{
    CGPoint closestCornerUnit = [self closestCornerUnit];
    [self moveToCornerUnit:closestCornerUnit animated:animated];
}

- (void)moveToCornerUnit:(CGPoint)unit animated:(BOOL)animated
{
    if (!self.superview)
        return;
    
    CGFloat xCenter = (self.superview.bounds.size.width + _borderInsets.left - _borderInsets.right)/2.0f;
    CGFloat yCenter = (self.superview.bounds.size.height + _borderInsets.top - _borderInsets.bottom)/2.0f;
    
    CGFloat xWidth = (self.superview.bounds.size.width - _borderInsets.left - _borderInsets.right - self.bounds.size.width - [self frameInsetFromDevice]*2.0f);
    CGFloat yHeight = (self.superview.bounds.size.height - _borderInsets.top - _borderInsets.bottom - self.bounds.size.height - [self frameInsetFromDevice]*2.0f);
    
    CGPoint cornerPoint = CGPointMake((xCenter) + (xWidth/2.0f * unit.x),
                              (yCenter) + (yHeight/2.0f * unit.y));
        
    CGFloat xd = cornerPoint.x - self.center.x;
    CGFloat yd = cornerPoint.y - self.center.y;
    
    CGFloat directDistance = sqrt(xd*xd + yd*yd);
    
    CGFloat distancePerSecond = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone? 720.0f : 1440.0f);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:(animated ? directDistance/distancePerSecond : 0.0f)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    super.center = cornerPoint;
    [UIView commitAnimations];
    
    super.autoresizingMask = ((unit.x ? UIViewAutoresizingFlexibleLeftMargin : UIViewAutoresizingFlexibleRightMargin) | 
                              (unit.y ? UIViewAutoresizingFlexibleTopMargin : UIViewAutoresizingFlexibleBottomMargin));
}

- (void)orientationDidChange
{
    UIImage *frameImage = _frameView.image;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation)
    {
        case UIDeviceOrientationPortrait:
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                frameImage = [UIImage imageNamed:@"pipiPhoneFramePortrait3x2"];
            else
                frameImage = [UIImage imageNamed:@"pipiPadFramePortrait4x3"];
        }
            break;
        case UIDeviceOrientationPortraitUpsideDown:
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                frameImage = [UIImage imageNamed:@"pipiPhoneFramePortraitUpsideDown3x2"];
            else
                frameImage = [UIImage imageNamed:@"pipiPadFramePortraitUpsideDown4x3"];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                frameImage = [UIImage imageNamed:@"pipiPhoneFrameLandscapeLeft3x2"];
            else
                frameImage = [UIImage imageNamed:@"pipiPadFrameLandscapeLeft4x3"];
        }
            break;
        case UIDeviceOrientationLandscapeRight:
        {
            if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
                frameImage = [UIImage imageNamed:@"pipiPhoneFrameLandscapeRight3x2"];
            else
                frameImage = [UIImage imageNamed:@"pipiPadFrameLandscapeRight4x3"];
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake([self frameInsetFromDevice] * 2.0f,
                                              [self frameInsetFromDevice] * 2.0f, 
                                              [self frameInsetFromDevice] * 2.0f, 
                                              [self frameInsetFromDevice] * 2.0f);

    if ([frameImage respondsToSelector:@selector(resizableImageWithCapInsets:)])
        _frameView.image = [frameImage resizableImageWithCapInsets:capInsets];
    else
        _frameView.image = [frameImage stretchableImageWithLeftCapWidth:capInsets.left
                                                           topCapHeight:capInsets.top];

    _frameView.frame = CGRectMake(-[self frameInsetFromDevice],
                                  -[self frameInsetFromDevice],
                                  _frameView.bounds.size.width,
                                  _frameView.bounds.size.height);
    
    [self moveToClosestCornerAnimated:YES];
}

#pragma mark - Class Overrides

- (CALayer *)layer
{
    return _displayView.layer;
}

- (void)addSubview:(UIView *)view
{
    [_displayView addSubview:view];
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    [self moveToClosestCornerAnimated:YES];
//}
//
//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//    [self moveToClosestCornerAnimated:YES];
//}
//
//- (void)setCenter:(CGPoint)center
//{
//    
//}
//
//- (void)setAutoresizingMask:(UIViewAutoresizing)autoresizingMask
//{
//    
//}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self moveToBottomRightAnimated:NO];
    [self orientationDidChange];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    [self moveToBottomRightAnimated:NO];
    [self orientationDidChange];
}

#pragma mark - Property Methods

//- (void)setBorderInsets:(UIEdgeInsets)borderInsets
//{
//    _borderInsets = borderInsets;
//    [self moveToClosestCornerAnimated:NO];
//}

@end
