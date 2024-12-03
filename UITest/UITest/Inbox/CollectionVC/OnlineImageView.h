//
//  OnlineImageView.h
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnlineImageView : UIView

+ (instancetype)shareManager;
- (void)loadImages:(int)count width:(float)width;
- (NSArray <UIImage *> *)getImageArray;
//@property(nonatomic,strong)NSMutableArray <UIImage *> * dataArray;
@end

NS_ASSUME_NONNULL_END
