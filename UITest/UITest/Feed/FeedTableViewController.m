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

#define cellCount 20

#define viewWidth self.view.frame.size.width
#define viewHeight self.view.frame.size.height

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
        self.enbaleCustomPaging = YES;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*cellCount);
    self.tableView.pagingEnabled = !self.enbaleCustomPaging;
    if (self.enbaleCustomPaging){
//        self.customPagingController = [[CustomPagingController alloc] initWithScrollView:self.tableView];
        self.customPagingController = [[CustomPagingControllerAnimation alloc] initWithScrollView:self.tableView];
        self.customPagingController.animationDuration = 1;
    }
    
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //decelerationRate在tableView中是禁用的
    self.tableView.decelerationRate = 0.0001;
    [self.view addSubview:self.tableView];
}

- (void)buttonClicked:(UIButton *)sender {
    NSLog(@"Button clicked!");
    [Responder.shareInstance.topVC.navigationController pushViewController:[[OtherProfileViewController alloc] init] animated:YES];
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
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return cellCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.height;
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
