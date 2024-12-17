//
//  DetailTableViewController.m
//  UITest
//
//  Created by ByteDance on 2024/12/12.
//

#import "DetailTableViewController.h"
#import "../../../UITest/Responder.h"

@implementation DetailTableViewController

- (void)viewDidLoad
{
    self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    button.backgroundColor = [UIColor blackColor];
    [button setTitle:@"back" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Button clicked!");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
