//
//  CustomPagingControllerAnimation.m
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#import "CustomPagingControllerAnimation.h"
#import <objc/runtime.h>

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
        [UIScrollView swizzled];
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
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.scrollView setContentOffset:CGPointMake(self.endContentOffset.x, self.endContentOffset.y+300)];
//    });
//    用animateWithDuration实现指定时长的scrollView 的ContentOffset缓慢变化的动画
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.endContentOffset.x, self.endContentOffset.y-0.26) animated:NO];
        //iOS 17 0.25不行，0.26可以
        //iOS 18 0.16不行，0.167可以
        self.scrollView.isCustomPaging = YES;
    }completion:^(BOOL finished) {
        if (finished) {
            self.displayLinkTimer.paused = YES;
            self.displayLinkTimer = nil;
            self.scrollView.isCustomPaging = NO;
            
            //业务代码
//            [self.scrollView setContentOffset:CGPointMake(self.endContentOffset.x, self.endContentOffset.y-300)];
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

@implementation UIScrollView (paging)

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

+ (void)swizzled
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(setContentOffset:) swizzledSelectorPop:@selector(paging_setContentOffset:)];
    });
}

- (void)paging_setContentOffset:(CGPoint)contentOffset
{
    
    if (self.isCustomPaging){
        NSLog(@"error can't set");
        return;
    }
    
    [self paging_setContentOffset:contentOffset];
}

- (void)setIsCustomPaging:(BOOL)isCustomPaging {
    objc_setAssociatedObject(self, @selector(isCustomPaging), @(isCustomPaging), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isCustomPaging {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

@end
