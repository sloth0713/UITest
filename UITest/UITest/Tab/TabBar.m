//
//  TabBar.m
//  UITest
//
//  Created by ByteDance on 2024/10/25.
//

#import "TabBar.h"
#import "../Feed/FeedSlidingViewController.h"
#import "../Friends/FriendsVC.h"
#import "../Inbox/InboxVC.h"
#import "../Responder.h"

@implementation TabBar

- (instancetype)init
{
    if (self = [super init]){
        FeedSlidingViewController *feedVC = [[FeedSlidingViewController alloc] init];
        feedVC.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *feedNavVC = [[UINavigationController alloc] initWithRootViewController:feedVC];
        Responder.shareInstance.topVC = feedVC;
        feedNavVC.tabBarItem.title = @"Feed";
        
        FriendsVC *friendsVC = [[FriendsVC alloc] init];
        friendsVC.view.backgroundColor = [UIColor whiteColor];
        friendsVC.tabBarItem.title = @"Friends";
        
        InboxVC *inboxVC = [[InboxVC alloc] init];//加到tabbar中的vc的view会自动和tabbar的frame一致
        inboxVC.view.backgroundColor = [UIColor whiteColor];
        inboxVC.tabBarItem.title = @"Inbox";
        
        UIViewController *profileVC = [[UIViewController alloc] init];
        profileVC.view.backgroundColor = [UIColor whiteColor];
        profileVC.tabBarItem.title = @"Profile";
        
        [self setTabAppearance];
        
        self.viewControllers = @[feedNavVC, friendsVC, inboxVC, profileVC];
    }
    return self;
}

- (void)setTabAppearance
{
    UIFont *font = [UIFont systemFontOfSize:16.0];
    NSDictionary *attributesNormal = @{
        NSFontAttributeName:font,
        NSForegroundColorAttributeName:[UIColor yellowColor]
    };
    
    NSDictionary *attributesSelected = @{
        NSFontAttributeName:font,
        NSForegroundColorAttributeName:[UIColor redColor]
    };

    [[UITabBarItem appearance] setTitleTextAttributes:attributesNormal forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:attributesSelected forState:UIControlStateSelected];
    
}

@end
