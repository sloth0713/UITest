//
//  CustomPagingController.m
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#import "CustomPagingController.h"

@interface CustomPagingController ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, assign) CGPoint beginContentOffset;
@property (nonatomic, assign) CGPoint endContentOffset;

@property (nonatomic, assign) NSTimeInterval beginTime;
@property (nonatomic, strong) CADisplayLink *displayLinkTimer;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation CustomPagingController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    if (self=[super init]) {
        self.scrollView = scrollView;
    }
    return self;
}

- (CADisplayLink *)displayLinkTimer
{
    if (!_displayLinkTimer) {
        _displayLinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateScrollAnimation:)];
        [_displayLinkTimer addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        _displayLinkTimer.paused = YES;
    }
    return _displayLinkTimer;
}

- (void)startAnimatingWithVelocity:(CGPoint)velocity targetContentOffset:(inout nonnull CGPoint *)targetContentOffset
{
    self.beginContentOffset = self.scrollView.contentOffset;
    self.endContentOffset = [self targetContentOffsetWithScrollingVelocity:velocity];
    *targetContentOffset = self.scrollView.contentOffset;
    if (CGPointEqualToPoint(self.beginContentOffset, self.endContentOffset)) {
        [self cancelScrollAnimation];
    }
    [self startScrollAnimation];
}

- (void)startScrollAnimation {
    [self cancelScrollAnimation];
    self.animating = YES;

    self.beginTime = [NSDate timeIntervalSinceReferenceDate];
    self.displayLinkTimer.paused = NO;
}

- (void)updateScrollAnimation:(CADisplayLink *)timer {
    const NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    const NSTimeInterval elapsedTime = currentTime - self.beginTime;
    const CGFloat animationPosition = MIN(1, (elapsedTime / self.animationDuration));

    CGPoint targetContentOffset = CGPointMake(AnimationLinear(animationPosition, self.beginContentOffset.x, self.endContentOffset.x),
                                              AnimationLinear(animationPosition, self.beginContentOffset.y, self.endContentOffset.y));

    [self.scrollView setContentOffset:targetContentOffset animated:NO];
    
    if (animationPosition == 1) {
        [self cancelScrollAnimation];
    }
}

- (void)cancelScrollAnimation {
    self.displayLinkTimer.paused = YES;
    self.animating = NO;
}

- (CGPoint)targetContentOffsetWithScrollingVelocity:(CGPoint)velocity
{
    CGFloat targetOffsetX;
    CGFloat pageSizeX = self.scrollView.bounds.size.width;
    CGFloat boundedOffsetX = self.scrollView.contentSize.width-pageSizeX;
    if (velocity.x >= 0.3) {
        targetOffsetX = ceil(self.scrollView.contentOffset.x/pageSizeX) * pageSizeX;
    } else if (velocity.x <= - 0.3) {
        targetOffsetX = floor(self.scrollView.contentOffset.x/pageSizeX) * pageSizeX;
    } else {
        targetOffsetX = round(self.scrollView.contentOffset.x/pageSizeX) * pageSizeX;
    }
    targetOffsetX = MAX(0, targetOffsetX);
    targetOffsetX = MIN(boundedOffsetX, targetOffsetX);

    
    CGFloat targetOffsetY;
    CGFloat pageSizeY = self.scrollView.bounds.size.height;
    CGFloat boundedOffsetY = self.scrollView.contentSize.height-pageSizeY;
    if (velocity.y >= 0.3) {
        targetOffsetY = ceil(self.scrollView.contentOffset.y/pageSizeY) * pageSizeY;
    } else if (velocity.y <= - 0.3) {
        targetOffsetY = floor(self.scrollView.contentOffset.y/pageSizeY) * pageSizeY;
    } else {
        targetOffsetY = round(self.scrollView.contentOffset.y/pageSizeY) * pageSizeY;
    }
    targetOffsetY = MAX(0, targetOffsetY);
    targetOffsetY = MIN(boundedOffsetY, targetOffsetY);

    return CGPointMake(targetOffsetX, targetOffsetY);
}

CGFloat AnimationLinear(CGFloat t, CGFloat start, CGFloat end)
{
    if (t <= 0) return start;
    if (t >= 1) return end;
    return start + t * (end - start);
}

@end
