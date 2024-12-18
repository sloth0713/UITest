//
//  TestTouchView.h
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import <UIKit/UIKit.h>


@interface TestTouchView : UIView <UIGestureRecognizerDelegate>

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name;

@end

