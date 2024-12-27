//
//  AppOrderFiles.m
//  AppOrderFiles
//
//
//learn://https://juejin.cn/post/6844904170495934477
#import "AppOrderFiles.h"
#import <dlfcn.h>
#import <libkern/OSAtomicQueue.h>
#import <pthread.h>


/*
 编译期插桩，利用LLVM编译架构的other c flags参数实现插桩。他会在每个函数二进制末尾自动插桩。
 __sanitizer_cov_trace_pc_guard_init会统计所有被插桩的guard函数段。
 guard原来的值是0，我们给他赋值从1～n。
 只需要实现__sanitizer_cov_trace_pc_guard，就会在函数调用结束后自动调用该方法
 */

static OSQueueHead queue = OS_ATOMIC_QUEUE_INIT;

static BOOL collectFinished = NO;

typedef struct {
    void *pc;
    void *next;
} PCNode;

// The guards are [start, stop).
// This function will be called at least once per DSO and may be called
// more than once with the same values of start/stop.
// start -> sancov.module_ctor_trace_pc_guard () 每个符号都会调用一次，参数都是第一个符号（start）到最后一只符号的地址（stop）
// 所以可以设置条件使得只调用一次

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                         uint32_t *stop) {
    static uint32_t N;  // Counter for the guards.
    if (start == stop) {
        return;
    }// Initialize only once.
    if (*start) {
        return;
    }
    
//    for (uint32_t *x = start; x < stop; x++)
//        printf("xxx %d \n", *x);
    printf("INIT: %p %p\n", start, stop);
    //如果不赋值，那么Guard就是0
//    for (uint32_t *x = start; x < stop; x++)
//        *x = ++N;  // Guards should start from 1.
//    
//    printf("guards count %d",N);
}

// This callback is inserted by the compiler on every edge in the
// control flow (some optimizations apply).
// Typically, the compiler will emit the code like this:
//    if(*guard)
//      __sanitizer_cov_trace_pc_guard(guard);
// But for large functions it will emit a simple call:
//    __sanitizer_cov_trace_pc_guard(guard);
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
    if (collectFinished) {
        return;
    }
//    if (!*guard) {
//        return;
//    }
    // If you set *guard to 0 this code will not be called again for this edge.
    // Now you can get the PC and do whatever you want:
    //   store it somewhere or symbolize it and print right away.
    // The values of `*guard` are as you set them in
    // __sanitizer_cov_trace_pc_guard_init and so you can make them consecutive
    // and use them to dereference an array or a bit vector.
    *guard = 0;//防止重复进入同一个方法
    void *PC = __builtin_return_address(0);
    PCNode *node = malloc(sizeof(PCNode));
    *node = (PCNode){PC, NULL};
    OSAtomicEnqueue(&queue, node, offsetof(PCNode, next));
}

extern void AppOrderFiles(void(^completion)(NSString *orderFilePath)) {
    collectFinished = YES;
    __sync_synchronize();
    NSString *functionExclude = [NSString stringWithFormat:@"_%s", __FUNCTION__];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray <NSString *> *functions = [NSMutableArray array];
        while (YES) {
            PCNode *node = OSAtomicDequeue(&queue, offsetof(PCNode, next));
            if (node == NULL) {
                break;
            }
            Dl_info info = {0};
            dladdr(node->pc, &info);
            if (info.dli_sname) {
                NSString *name = @(info.dli_sname);
                BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
                NSString *symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
                [functions addObject:symbolName];
            }
        }
        if (functions.count == 0) {
            if (completion) {
                completion(nil);
            }
            return;
        }
        NSMutableArray<NSString *> *calls = [NSMutableArray arrayWithCapacity:functions.count];
        NSEnumerator *enumerator = [functions reverseObjectEnumerator];
        NSString *obj;
        while (obj = [enumerator nextObject]) {
            if (![calls containsObject:obj]) {
                [calls addObject:obj];
            }
        }
        [calls removeObject:functionExclude];
        NSString *result = [calls componentsJoinedByString:@"\n"];
        NSLog(@"Order:\n%@", result);
        NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"app.order"];
        NSData *fileContents = [result dataUsingEncoding:NSUTF8StringEncoding];
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:filePath
                                                               contents:fileContents
                                                             attributes:nil];
        if (completion) {
            completion(success ? filePath : nil);
        }
    });
}
