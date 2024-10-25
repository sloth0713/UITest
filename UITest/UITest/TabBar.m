//
//  TabBar.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "TabBar.h"
#import "Feed/FeedSlidingViewController.h"

@implementation TabBar

- (instancetype)init
{
    if (self = [super init]){
        FeedSlidingViewController *feedVC = [[FeedSlidingViewController alloc] init];
        feedVC.view.backgroundColor = [UIColor whiteColor];
        feedVC.tabBarItem.title = @"Feed";
        
        UIViewController *friendsVC = [[UIViewController alloc] init];
        friendsVC.view.backgroundColor = [UIColor whiteColor];
        friendsVC.tabBarItem.title = @"Friends";
        
        UIViewController *inboxVC = [[UIViewController alloc] init];
        inboxVC.view.backgroundColor = [UIColor whiteColor];
        inboxVC.tabBarItem.title = @"Inbox";
        
        UIViewController *profileVC = [[UIViewController alloc] init];
        profileVC.view.backgroundColor = [UIColor whiteColor];
        profileVC.tabBarItem.title = @"Profile";
        self.viewControllers = @[feedVC, friendsVC, inboxVC, profileVC];
    }
    return self;
}

@end
