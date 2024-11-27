//
//  InboxVC.m
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import "InboxVC.h"
#import "AnimationVC.h"
#import "CollectionVC/CollectionVC.h"


@implementation InboxVC

- (instancetype)init
{
    if (self=[super init]) {
        [self addChildCollectionVC];
    }
    return self;
}

- (void)addChildCollectionVC
{
    CollectionVC *collectionVC = [[CollectionVC alloc] init];
    collectionVC.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height-200);
    [self.view addSubview:collectionVC.view];
    [self addChildViewController:collectionVC];
}

- (void)addChildAnimationVC
{
    AnimationVC *avc = [[AnimationVC alloc] init];
    avc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    avc.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:avc.view];
    [self addChildViewController:avc];
}

@end
