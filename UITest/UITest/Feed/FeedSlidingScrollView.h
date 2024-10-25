//
//  FeedSlidingScrollView.h
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedSlidingScrollView : UIScrollView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, assign) BOOL isInLastVC;
@end


