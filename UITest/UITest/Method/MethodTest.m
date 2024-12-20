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
    /*
     方法签名
     v是返回类型，可改
     @是self类型，固定
     :是cmd类型，固定
     @是第一个参数的类型，可改
     */
    NSMethodSignature *method = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    return method;
//    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
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

- (void)runMethod:(NSString *)param
{
    NSLog(@"MethodTestReplace runMethod param : %@",param);
}

@end

@implementation MethodTestForward

- (void)runMethod:(NSString *)param
{
    NSLog(@"MethodTestForward runMethod param : %@",param);
}

@end
