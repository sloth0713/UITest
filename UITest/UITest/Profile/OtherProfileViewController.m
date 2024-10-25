//
//  OtherProfileViewController.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import "OtherProfileViewController.h"
#import "../Feed/FeedTableViewController.h"


#define profileHeadHeight 300
@interface OtherProfileViewController ()

@property (nonatomic, strong) FeedTableViewController *tableVC;

@end

@implementation OtherProfileViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    
    self.tableVC = [[FeedTableViewController alloc] initWithName:@"tableVC"];
    [self addChildViewController:self.tableVC];
    self.tableVC.view.frame = CGRectMake(0, profileHeadHeight, self.view.frame.size.width, self.view.frame.size.height - profileHeadHeight);
    [self.view addSubview:self.tableVC.view];
}

@end
