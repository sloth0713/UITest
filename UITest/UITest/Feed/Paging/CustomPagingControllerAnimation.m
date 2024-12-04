//
//  CustomPagingControllerAnimation.m
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#import "CustomPagingControllerAnimation.h"

@interface CustomPagingControllerAnimation ()
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, assign) CGPoint beginContentOffset;
@property (nonatomic, assign) CGPoint endContentOffset;

@property (nonatomic, strong) CADisplayLink *displayLinkTimer;


@end

@implementation CustomPagingControllerAnimation

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
    [self startCoreScrollAnimation];

}
- (void)startCoreScrollAnimation {
    self.displayLinkTimer.paused = NO;
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.scrollView setContentOffset:self.endContentOffset];
    }completion:^(BOOL finished) {
        if (finished) {
            self.displayLinkTimer.paused = YES;
            self.displayLinkTimer = nil;
        }
    }
    ];
}

- (void)updateScrollAnimation:(CADisplayLink *)timer
{
//    NSLog(@"updateScrollAnimation");
    [self.scrollView.delegate scrollViewDidScroll:self.scrollView];
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
@synthesize animationDuration;

@end
