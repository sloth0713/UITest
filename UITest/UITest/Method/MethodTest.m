//
//  MethodTest.m
//  UITest
//
//  Created by ByteDance on 2024/12/20.
//

#import "MethodTest.h"

@implementation MethodTest

#pragma mark - 消息替换
- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if(aSelector == @selector(runMethod)){
//        return [[MethodTestReplace alloc] init];
//    }
    return nil;
}

#pragma mark - 消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    //方法签名，表示方法需要两个参数。第一个参数是一个对象类型，第二个参数是一个选择器（常见用于方法的动态调用）
    NSMethodSignature *method = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    return method;
}

/*
 在forwardInvocation:消息发送前，runtime系统会向对象发送methodSignatureForSelector:消息，并取到返回的方法签名用于生成NSInvocation对象。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"NSObject+CrashLogHandle---在类:%@中 未实现该方法:%@",NSStringFromClass([anInvocation.target class]),NSStringFromSelector(anInvocation.selector));
    MethodTestForward *replace = [[MethodTestForward alloc] init];
    if ([replace respondsToSelector:anInvocation.selector]){
        [anInvocation invokeWithTarget:replace];
    }else {
        [self doesNotRecognizeSelector:anInvocation.selector];
    }
    
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSLog(@"DO nothing");
}


@end

@implementation MethodTestReplace

- (void)runMethod
{
    NSLog(@"MethodTestReplace runMethod");
}

@end

@implementation MethodTestForward

- (void)runMethod
{
    NSLog(@"MethodTestForward runMethod");
}

@end
