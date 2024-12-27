//
//  DisplayLinkFluencyMonitor.m
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import "DisplayLinkFluencyMonitor.h"
#import <QuartzCore/QuartzCore.h>

@interface DisplayLinkFluencyMonitor ()

@property (nonatomic,strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTimeStamp;
@property (nonatomic,assign) int count;
@property (nonatomic,assign) CFRunLoopObserverRef runLoopObserver;
@property (nonatomic,assign) CFRunLoopActivity runLoopActivity;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation DisplayLinkFluencyMonitor

+(instancetype)shareMonitor
{
    static DisplayLinkFluencyMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[DisplayLinkFluencyMonitor alloc] init];
        [monitor start];
    });
    return monitor;
}

- (void)start
{
    self.lastTimeStamp = [[NSDate now] timeIntervalSince1970]*1000;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//        NSRunLoopCommonModes = NSDefaultRunLoopMode+UITrackingRunLoopMode
    
    self.timer  = [[NSTimer alloc] initWithFireDate:[NSDate now] interval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {

        NSLog(@"Start long running task");
//        for (int i = 0; i < 100000000; i++) {
//            // 长时间循环操作模拟耗时
//        }
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"End long running task");
        
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];

}



- (void)handleDisplayLink:(CADisplayLink *)displayLink
{
    CFRunLoopRef runLoop = CFRunLoopGetMain();
    CFStringRef currentMode = CFRunLoopCopyCurrentMode(runLoop);
    
//    if (currentMode != nil) {
        NSString *currentModeString = (NSString *)CFBridgingRelease(currentMode);
        NSLog(@"currentModeString %@",currentModeString);
//    }
    
    NSTimeInterval lastTimeStamp = self.lastTimeStamp;
    NSTimeInterval now = [[NSDate now] timeIntervalSince1970]*1000;
    self.lastTimeStamp = now;
    
    NSTimeInterval interval = now - lastTimeStamp;
    if (interval > 17 *3){ //直接丢三帧
        [self findLag:@"lag3" duration:interval];
        self.count = 0;
        return;
    }else{
//        NSLog(@"normal single display link duartion : %lf", interval);
    }
    
    
    
    if (now - lastTimeStamp > 17){ //丢一帧
        self.count++;
        
        NSLog(@"lag single display link duartion : %lf", interval);
        
        if (self.count >= 3){//连续三次丢一帧
            [self findLag:@"add lag 3" duration:0];
            self.count = 0;
        }
        
        return;
    }
    
    self.count = 0;
}

- (void)findLag:(NSString *)reason duration:(NSTimeInterval)duration
{
    NSLog(@"findLag reason: %@ duration: %lf", reason,duration);
}


//- (void)checkRunLoopMode {
//    CFRunLoopRef runLoop = CFRunLoopGetMain();
//    CFStringRef currentMode = CFRunLoopCopyCurrentMode(runLoop);
//    
//    if (currentMode != nil) {
//        NSString *currentModeString = (NSString *)CFBridgingRelease(currentMode);
//        
//        if ([currentModeString isEqualToString:UITrackingRunLoopMode]) {
//            NSLog(@"当前 RunLoop 进入了 UITrackingRunLoopMode 模式");
//            // 在进入 UITrackingRunLoopMode 时执行你想要的操作
//        } else {
//            NSLog(@"当前 RunLoop 进入了其他模式: %@", currentModeString);
//        }
//    }
//}

@end
