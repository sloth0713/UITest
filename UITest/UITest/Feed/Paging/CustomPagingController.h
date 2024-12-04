//
//  CustomPagingController.h
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPagingController : NSObject

@property (nonatomic, assign) NSTimeInterval animationDuration;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (CGPoint)targetContentOffsetWithScrollingVelocity:(CGPoint)velocity;
- (void)startAnimatingWithVelocity:(CGPoint)velocity targetContentOffset:(inout nonnull CGPoint *)targetContentOffset;

@end

NS_ASSUME_NONNULL_END
