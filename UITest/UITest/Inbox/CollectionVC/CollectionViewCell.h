//
//  CollectionViewCell.h
//  UITest
//
//  Created by ByteDance on 2024/12/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CollectionViewCellType) {
    CollectionViewCellType1 = 1,
    CollectionViewCellType2 = 2,
    CollectionViewCellType3 = 3,
};

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) CollectionViewCellType type;
@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
