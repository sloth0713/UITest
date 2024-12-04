//
//  FeedTableViewController.h
//  GestureTest
//
//  Created by ByteDance on 2024/8/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FeedTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
- (instancetype)initWithName:(NSString *)name;
@property (nonatomic, assign) BOOL isLastVC;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign) BOOL enbaleCustomPaging;

@end

