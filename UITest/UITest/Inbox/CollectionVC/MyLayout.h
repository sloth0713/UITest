//
//  MyLayout.h
//  UITest
//
//  Created by ByteDance on 2024/11/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyLayout : UICollectionViewFlowLayout

@property(nonatomic,assign)int itemCount;
@property(nonatomic,assign)CGFloat width;

@end

NS_ASSUME_NONNULL_END
