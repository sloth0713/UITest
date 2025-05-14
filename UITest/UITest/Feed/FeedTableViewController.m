//
//  FeedTableViewController.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/15.
//

#import "FeedTableViewController.h"
#import "../Transition/TransitionManager.h"
#import "./Profile/OtherProfileViewController.h"
#import "../../UITest/Responder.h"
#import "Paging/CustomPagingController.h"
#import "Paging/CustomPagingControllerAnimation.h"
#import "Paging/CustomPagingControllerProtocol.h"
#import "../../../UITest/UITest/UITest-Bridging-Header.h"

#define cellCount 200

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height
//#define viewHeight 100

@interface FeedTableViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *beginDraggingTime;
@property (nonatomic, strong) NSDate *endDraggingTime;
@property (nonatomic, strong) NSDate *scrollEndDraggingTime;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) id <CustomPagingControllerProtocol> customPagingController;

@end

@implementation FeedTableViewController

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self){
        self.name = name;
        self.enbaleCustomPaging = NO;
    }
    return self;
}
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
//    if (self.contentOffset.x == self.frame.size.width*2){
//        scrollDirection direction = [TransitionManager directionForPan:gestureRecognizer view:self];
//        if (direction == scrollDirectionLeft){
//            NSLog(@"left");
//            return NO;
//        }
//    }
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, viewHeight*cellCount);
    self.tableView.pagingEnabled = !self.enbaleCustomPaging;
    if (self.enbaleCustomPaging){
//        self.customPagingController = [[CustomPagingController alloc] initWithScrollView:self.tableView];
        self.customPagingController = [[CustomPagingControllerAnimation alloc] initWithScrollView:self.tableView];//这个有绿屏问题
        self.customPagingController.animationDuration = 1;
    }
    
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    //decelerationRate在tableView中是禁用的
//    self.tableView.decelerationRate = 0.0001;
    [self.view addSubview:self.tableView];
    
//    for (int i=0; i<1000; i++) {
//        [self addLayout];
//    }
}

- (void)addLayout
{
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    parentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:parentView];

    // 创建子视图1
    UIView *childView1 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    childView1.backgroundColor = [UIColor blueColor];
    childView1.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:childView1];

    // 创建子视图2
    UIView *childView2 = [[UIView alloc] initWithFrame:CGRectMake(50, 60, 80, 120)];
    childView2.backgroundColor = [UIColor redColor];
    childView2.translatesAutoresizingMaskIntoConstraints = NO;
    [parentView addSubview:childView2];

    // 设置子视图之间的复杂约束
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:childView1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    [parentView addConstraint:constraint1];

    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:childView1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:20];
    [parentView addConstraint:constraint2];

    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:childView2 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [parentView addConstraint:constraint3];

    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:childView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [parentView addConstraint:constraint4];
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Button clicked!");
    BOOL isAnimation = YES;
    
//    OtherProfileViewController *otvc = [[OtherProfileViewController alloc] init];
    SwiftOtherProfile *otvc = [[SwiftOtherProfile alloc] init];//需要BOOL customNavigationTransition = NO;
    [Responder.shareInstance.topVC.navigationController pushViewController:otvc animated:isAnimation];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row;
    if ([self.name isEqualToString:@"profile_tableVC"]) {
        NSLog(@"willDisplayCell %ld",row);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    long row = indexPath.row;
    if ([self.name isEqualToString:@"profile_tableVC"]) {
        NSLog(@"didEndDisplayingCell %ld",row);
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSArray *colorArray = @[[UIColor grayColor], [UIColor redColor], [UIColor blueColor]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    long row = indexPath.row%3;
    UIColor *color = colorArray[row];
    if (self.isLastVC){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:@"Profile" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
    }

    cell.contentView.backgroundColor = color;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld",self.name,indexPath.row];
    NSLog(@"cellForRowAtIndexPath %ld",indexPath.row);
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return viewHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRowAtIndexPath");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //setContentOffset会调用scrollViewDidScroll
    NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginDraggingTime = [NSDate date];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.enbaleCustomPaging){
        [self.customPagingController startAnimatingWithVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.endDraggingTime = [NSDate date];
    NSTimeInterval beginDragging_to_endDragging = [self.endDraggingTime timeIntervalSinceDate:self.beginDraggingTime];
    NSLog(@"beginDragging_to_endDragging %lf",beginDragging_to_endDragging);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    self.scrollEndDraggingTime = [NSDate date];
    
    NSTimeInterval endDragging_to_endScroll = [self.scrollEndDraggingTime timeIntervalSinceDate:self.endDraggingTime];
    NSTimeInterval beginDragging_to_endScroll = [self.scrollEndDraggingTime timeIntervalSinceDate:self.beginDraggingTime];
    NSLog(@"endDragging_to_endScroll %lf",endDragging_to_endScroll);
    NSLog(@"beginDragging_to_endScroll %lf",beginDragging_to_endScroll);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //这个回调不会调用
    self.scrollEndDraggingTime = [NSDate date];
    
    NSTimeInterval endDragging_to_endScroll = [self.scrollEndDraggingTime timeIntervalSinceDate:self.endDraggingTime];
    NSTimeInterval beginDragging_to_endScroll = [self.scrollEndDraggingTime timeIntervalSinceDate:self.beginDraggingTime];
    NSLog(@"endDragging_to_endScroll %lf",endDragging_to_endScroll);
    NSLog(@"beginDragging_to_endScroll %lf",beginDragging_to_endScroll);
}


@end
