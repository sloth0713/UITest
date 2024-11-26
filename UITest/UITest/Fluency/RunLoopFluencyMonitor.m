//
//  RunLoopFluencyMonitor.m
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import "RunLoopFluencyMonitor.h"

@interface RunLoopFluencyMonitor ()

@property (nonatomic,strong) dispatch_semaphore_t dispatchSemaphore;
@property (nonatomic,assign) CFRunLoopObserverRef runLoopObserver;
@property (nonatomic,assign) CFRunLoopActivity runLoopActivity;
@property (nonatomic,assign) int timeoutCount;


@end

@implementation RunLoopFluencyMonitor

+ (instancetype)shareMonitor
{
    static RunLoopFluencyMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[RunLoopFluencyMonitor alloc] init];
        [monitor beginMonitor];
    });
    return monitor;
}

- (void)beginMonitor {
    
    if (self.runLoopObserver) {
        return;
    }
    self.dispatchSemaphore = dispatch_semaphore_create(0);
    //创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    self.runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.runLoopObserver, kCFRunLoopCommonModes);
    
    //创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (YES) {
            //dispatch_semaphore_wait如果超时（返回任意数字），或者有信号发出（返回0），就执行，否则不执行
            long semaphoreWait = dispatch_semaphore_wait(self.dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20*NSEC_PER_MSEC));
            //如果能在20ms内转换runLoopActivity就没问题，如果不行，而且runLoopActivity为kCFRunLoopBeforeSources或者kCFRunLoopAfterWaiting，就认为卡顿
            if (semaphoreWait != 0) {
                /*
                 如果连续三个超时都是kCFRunLoopBeforeSources或kCFRunLoopAfterWaiting，认为卡顿。
                 如果状态切换了或者没超时就timeoutCount置为0
                 */
                if (!self.runLoopObserver) {
                    self.timeoutCount = 0;
                    self.dispatchSemaphore = 0;
                    self.runLoopActivity = 0;
                    return;
                }
//                NSLog(@"runloop activity time out");
//                stringFromActivity(self.runLoopActivity);
                //两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                
                // 正常是kCFRunLoopBeforeWaiting，线程停止就是kCFRunLoopBeforeSources
                if (self.runLoopActivity == kCFRunLoopBeforeSources || self.runLoopActivity == kCFRunLoopAfterWaiting) {
                    //出现三次出结果
                    if (++self.timeoutCount < 3) {
                        continue;
                    }
                    NSLog(@"monitor trigger");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        [self log];
                    });
                } //这里不需要考虑连续三次刚好不同的runloop kCFRunLoopBeforeSources的case，因为runloop activity是按照顺序来的，如果其他activity超时会不走continue设0，如果不超时会semaphoreWait为0，也还是会设置为0
            }else{
                NSLog(@"not time out");
            }
            self.timeoutCount = 0;
        }
    });
    
}

#pragma mark - Private
static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    RunLoopFluencyMonitor *lagMonitor = [RunLoopFluencyMonitor shareMonitor];
    lagMonitor.runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor.dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
    stringFromActivity(activity);
}

- (void)log
{
    NSLog(@"lag happen, detail below: ");
}

static void stringFromActivity(CFRunLoopActivity activity)
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *formattedDate = [dateFormatter stringFromDate:currentDate];
    
    if (activity == 0){
        NSLog(@"runLoopObserverCallBack activity kCFRunLoopEntry time : %@",formattedDate);
    }else if (activity == kCFRunLoopBeforeTimers){
        NSLog(@"runLoopObserverCallBack activity kCFRunLoopBeforeTimers time : %@",formattedDate);
    }else if (activity == kCFRunLoopBeforeSources){
        NSLog( @"runLoopObserverCallBack activity kCFRunLoopBeforeSources time : %@",formattedDate);
    }else if (activity == kCFRunLoopBeforeWaiting){
        NSLog( @"runLoopObserverCallBack activity kCFRunLoopBeforeWaiting time : %@",formattedDate);
    }else if (activity == kCFRunLoopAfterWaiting){
        NSLog( @"runLoopObserverCallBack activity kCFRunLoopAfterWaiting time : %@",formattedDate);
    }else if (activity == kCFRunLoopExit){
        NSLog( @"runLoopObserverCallBack activity kCFRunLoopExit time : %@",formattedDate);
    }else if (activity == kCFRunLoopAllActivities){
        NSLog( @"runLoopObserverCallBack activity kCFRunLoopAllActivities time : %@",formattedDate);
    }else{
        NSLog( @"runLoopObserverCallBack activity unknown %lu",activity);
    }
    
}

@end
