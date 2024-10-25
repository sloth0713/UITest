//
//  FeedTableViewController.m
//  GestureTest
//
//  Created by ByteDance on 2024/8/15.
//

#import "FeedTableViewController.h"
#import "../Transition/TransitionManager.h"

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

@end

@implementation FeedTableViewController

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self){
        self.name = name;
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
    self.tableView.pagingEnabled = YES;
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //decelerationRate在tableView中是禁用的
    self.tableView.decelerationRate = 0.0001;
    [self.view addSubview:self.tableView];
    
//    if (self.isLastVC){
//        [self leftPanSwitchVC];
//    }

}


- (void)leftPanSwitchVC
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:self.view];
//        scrollDirection drection = [TransitionManager getDirection:translation];
//        
//        if (drection==scrollDirectionLeft){
//        }
        
        [gestureRecognizer setTranslation:CGPointZero inView:self.view];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    
    NSArray *colorArray = @[[UIColor grayColor], [UIColor redColor], [UIColor blueColor]];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    long row = indexPath.row%3;
    UIColor *color = colorArray[row];

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
    NSLog(@"fdsaf");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.beginDraggingTime = [NSDate date];
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
