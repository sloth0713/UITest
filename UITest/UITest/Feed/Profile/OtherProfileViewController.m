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


#define profileHeadHeight 300
@interface OtherProfileViewController () <UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) FeedTableViewController *tableVC;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) scrollDirection direction;

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
    [self.view addSubview:self.tableVC.view];
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

@end
