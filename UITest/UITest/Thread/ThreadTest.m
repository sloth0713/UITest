//
//  ThreadTest.m
//  UITest
//
//  Created by ByteDance on 2024/12/3.
//

#import "ThreadTest.h"

#import <mach/mach.h>

@implementation ThreadTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self test];
    }
    return self;
}

- (void)test
{
    print_thread_priority();
    dispatch_queue_t queue = dispatch_get_current_queue();
    dispatch_qos_class_t qosClass = dispatch_queue_get_qos_class(queue, NULL);
    //UI 线程优先级+1，UI线程就是主线程的意思
    NSLog(@"stringFromQoSClass : %@", [self stringFromQoSClass:qosClass]);

    NSLog(@"ee");
}

- (NSString *)stringFromQoSClass:(dispatch_qos_class_t)qosClass {
    switch (qosClass) {
        case QOS_CLASS_USER_INTERACTIVE:
            return @"User Interactive";
        case QOS_CLASS_USER_INITIATED:
            return @"User Initiated";
        case QOS_CLASS_DEFAULT:
            return @"Default";
        case QOS_CLASS_UTILITY:
            return @"Utility";
        case QOS_CLASS_BACKGROUND:
            return @"Background";
        case QOS_CLASS_UNSPECIFIED:
            return @"Unspecified";
        default:
            return @"Unknown";
    }
}



void print_thread_priority(void) {
    thread_t cur_thread = mach_thread_self();
    mach_port_deallocate(mach_task_self(), cur_thread);
    mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
    thread_info_data_t thinfo;
    kern_return_t kr = thread_info(cur_thread, THREAD_EXTENDED_INFO, (thread_info_t)thinfo, &thread_info_count);
    if (kr != KERN_SUCCESS) {
        return;
    }
    thread_extended_info_t extend_info = (thread_extended_info_t)thinfo;
    printf("pth_curpri: %d\n", extend_info->pth_curpri);
}



@end
