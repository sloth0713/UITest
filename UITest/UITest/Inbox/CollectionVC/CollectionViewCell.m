//
//  CollectionViewCell.m
//  UITest
//
//  Created by ByteDance on 2024/12/3.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

@end
