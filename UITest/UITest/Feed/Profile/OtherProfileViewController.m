//
//  OtherProfileViewController.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/16.
//

#import "OtherProfileViewController.h"
#import "../FeedTableViewController.h"
#import "../../Transition/TransitionManager.h"
#import "../FullScreenPopTransition.h"
#import "ProfileMaskView.h"


#define profileHeadHeight 300
@interface OtherProfileViewController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) FeedTableViewController *tableVC;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) scrollDirection direction;

@property (nonatomic, strong) ProfileMaskView *maskView;

@end

@implementation OtherProfileViewController

- (instancetype)init
{
    if (self = [super init]){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = CGRectMake(0, 0, self.navigationController.view.frame.size.width, self.navigationController.view.frame.size.height);
    
    self.tableVC = [[FeedTableViewController alloc] initWithName:@"tableVC"];
    [self addChildViewController:self.tableVC];
    self.tableVC.view.frame = CGRectMake(0, profileHeadHeight, self.view.frame.size.width, self.view.frame.size.height - profileHeadHeight);
    
    self.maskView = [[ProfileMaskView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.maskView];
//    [self.view addSubview:self.tableVC.view];
    [self addPanGesture];
}

- (void)addPanGesture
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded
        || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        if (self.direction==scrollDirectionRight){
            [self transition2Feed];
        }
    }
}

- (void)transition2Feed
{
//    self.navigationController.delegate = self;
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"pushViewController OtherProfileViewController");
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{

    scrollDirection drection = [TransitionManager directionForPan:gestureRecognizer view:self.view];
    if (drection==scrollDirectionRight){
        self.direction = drection;
        return YES;
    }else{
        self.direction = scrollDirectionNone;
        return NO;
    }
    
}

#pragma mark - UINavigationControllerDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC  API_AVAILABLE(ios(7.0))
{
    return [[FullScreenPopTransition alloc] init];
}


#pragma mark - VC life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
//    [NSThread sleepForTimeInterval:5];
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews
{
    //在viewDidLayoutSubviews之前转场动画已经执行了，这里sleep很久之后实际动画才开始。也就是说core animation动画开始之前需要view的所有生命周期都执行完成
//    [NSThread sleepForTimeInterval:5];
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
}
@end
