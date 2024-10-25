//
//  FeedSlidingViewController.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/15.
//

#import "FeedSlidingViewController.h"
#import "FeedSlidingScrollView.h"
#import "../Transition/TransitionManager.h"
#import "./Profile/OtherProfileViewController.h"
#import "Feed2ProfileTransition.h"
#import "FeedSlidingViewController+Transition.h"

@interface FeedSlidingViewController ()
@property (nonatomic, strong) FeedSlidingScrollView *scrolleView;

@property (nonatomic, strong) FeedTableViewController *tableVC;
@property (nonatomic, strong) FeedTableViewController *tableVC2;
@property (nonatomic, strong) FeedTableViewController *tableVC3;
@property (nonatomic, strong) NSArray <FeedTableViewController *> *tableVCs;
@property (nonatomic, assign) scrollDirection direction;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@end

@implementation FeedSlidingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.scrolleView = [[FeedSlidingScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrolleView.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height);
    self.scrolleView.pagingEnabled = YES;
    self.scrolleView.delegate = self;
    [self.view addSubview:self.scrolleView];
    
    self.tableVC = [[FeedTableViewController alloc] initWithName:@"tableVC"];
    [self addChildViewController:self.tableVC];
    self.tableVC.view.frame = CGRectMake(0, 0, self.scrolleView.frame.size.width, self.scrolleView.frame.size.height);
    [self.scrolleView addSubview:self.tableVC.view];
    
    self.tableVC2 = [[FeedTableViewController alloc] initWithName:@"tableVC2"];
    [self addChildViewController:self.tableVC2];
    self.tableVC2.view.frame = CGRectMake(self.scrolleView.frame.size.width, 0, self.scrolleView.frame.size.width, self.scrolleView.frame.size.height);
    [self.scrolleView addSubview:self.tableVC2.view];
    
    self.tableVC3 = [[FeedTableViewController alloc] initWithName:@"tableVC3"];
    self.tableVC3.isLastVC = YES;
    [self addChildViewController:self.tableVC];
    self.tableVC3.view.frame = CGRectMake(self.scrolleView.frame.size.width*2, 0, self.scrolleView.frame.size.width, self.scrolleView.frame.size.height);
    
    self.tableVCs = @[self.tableVC,self.tableVC2,self.tableVC3];
    
    [self.scrolleView addSubview:self.tableVC3.view];
    
    [self addPanGesture];
}
//static BOOL hasPush = NO;
- (void)addPanGesture
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    //tableVC3左滑pushvc
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    //即使gestureRecognizerShouldBegin为YES也不一定会走到这里，有可能子ScrollView也返回YES，子view把这个手势拦截了
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded
        || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        if (self.direction==scrollDirectionLeft){
            [self transition2Profile];
        }
    }
}

- (void)transition2Profile
{
 
    self.navigationController.delegate = self;
    [self.navigationController pushViewController:[[OtherProfileViewController alloc] init] animated:YES];
    NSLog(@"pushViewController OtherProfileViewController");
    
}
//[self.navigationController pushViewController:[[OtherProfileViewController alloc] init] animated:YES];

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (self.currentTableView.isLastVC){
        scrollDirection drection = [TransitionManager directionForPan:gestureRecognizer view:self.view];
        if (drection==scrollDirectionLeft){
            self.direction = drection;
            return YES;
        }else{
            self.direction = scrollDirectionNone;
            return NO;
        }
    }
    self.direction = scrollDirectionNone;
    return NO;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollViewWidth = scrollView.bounds.size.width;
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = (NSInteger)(contentOffsetX / scrollViewWidth);
    self.currentTableView = [self.tableVCs objectAtIndex:currentIndex];
    if (self.currentTableView.isLastVC){
        self.scrolleView.isInLastVC = YES;
    }else{
        self.scrolleView.isInLastVC = NO;
    }
//    NSLog(@"Current Index is: %ld", currentIndex);
//    NSLog(@"currentTableView is: %@", self.currentTableView.name);
    
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
//    CGFloat offsetX = targetContentOffset->x;
//    CGFloat pageWidth = self.scrolleView.frame.size.width;
//    NSInteger currentPage = roundf(offsetX / pageWidth);
//
//    targetContentOffset->x = currentPage * pageWidth; // 修改 targetContentOffset 实现自定义滚动位置
//}

@end
