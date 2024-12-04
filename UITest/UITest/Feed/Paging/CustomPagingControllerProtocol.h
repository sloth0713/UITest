//
//  CustomPagingControllerProtocol.h
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#ifndef CustomPagingControllerProtocol_h
#define CustomPagingControllerProtocol_h


#endif /* CustomPagingControllerProtocol_h */

@protocol CustomPagingControllerProtocol <NSObject>

@property (nonatomic, assign) NSTimeInterval animationDuration;

- (nonnull instancetype)initWithScrollView:(nonnull UIScrollView *)scrollView;
- (CGPoint)targetContentOffsetWithScrollingVelocity:(CGPoint)velocity;
- (void)startAnimatingWithVelocity:(CGPoint)velocity targetContentOffset:(inout nonnull CGPoint *)targetContentOffset;

@end
