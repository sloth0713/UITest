//
//  FriendsVC.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "FriendsVC.h"
#import "TestTouchView.h"

@implementation FriendsVC

- (void)viewDidLoad
{
    TestTouchView *viewA = [[TestTouchView alloc] initWithFrame:self.view.frame name:@"viewA"];
    viewA.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:viewA];
    
    TestTouchView *viewB = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 300, 200) name:@"viewB"];
    viewB.backgroundColor = [UIColor blueColor];
    [viewA addSubview:viewB];
    
    TestTouchView *viewC = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 400, 300, 300) name:@"viewC"];
    viewC.backgroundColor = [UIColor grayColor];
    [viewA addSubview:viewC];
    
    TestTouchView *viewD = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 200, 80) name:@"viewD"];
    viewD.backgroundColor = [UIColor redColor];
    [viewC addSubview:viewD];
    
    TestTouchView *viewE = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 150, 200, 80) name:@"viewE"];
    viewE.backgroundColor = [UIColor greenColor];
    [viewC addSubview:viewE];

//    TestTouchView *viewF = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 200, 80) name:@"viewF"];
//    viewF.backgroundColor = [UIColor redColor];
//    [viewB addSubview:viewF];
//    
//    TestTouchView *viewG = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 150, 200, 80) name:@"viewG"];
//    viewG.backgroundColor = [UIColor greenColor];
//    [viewB addSubview:viewG];

}

@end
