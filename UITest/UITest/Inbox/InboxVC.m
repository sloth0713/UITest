//
//  InboxVC.m
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import "InboxVC.h"
#import "AnimationVC.h"


@implementation InboxVC

- (instancetype)init
{
    if (self=[super init]) {
        AnimationVC *avc = [[AnimationVC alloc] init];
        avc.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        avc.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:avc.view];
        [self addChildViewController:avc];
    }
    return self;
}

@end
