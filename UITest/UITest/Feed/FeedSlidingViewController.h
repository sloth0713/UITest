//
//  FeedSlidingViewController.h
//  GestureTest
//
//  Created by ByteDance on 2024/8/15.
//

#import "FeedTableViewController.h"
#import <UIKit/UIKit.h>

@interface FeedSlidingViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) FeedTableViewController *currentTableView;

@end
