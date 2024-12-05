//
//  CustomPagingControllerAnimation.h
//  UITest
//
//  Created by ByteDance on 2024/12/4.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CustomPagingControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomPagingControllerAnimation  : NSObject <CustomPagingControllerProtocol>

@end

@interface UIScrollView (paging)
@property (nonatomic, assign)BOOL isCustomPaging;
+ (void)swizzled;
@end

NS_ASSUME_NONNULL_END
