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
    //只能return转发给一个对象
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
 这样可以将所有消息转发给NSObject的init方法，然后返回空值，防止崩溃
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
 }
 
 - (void)forwardInvocation: (NSInvocation *)invodcation

    void *nullValue = nil;
    [invocation setReturnValue:&nullValue];
 }

 */


/*
 在forwardInvocation:消息发送前，runtime系统会向对象发送methodSignatureForSelector:消息，并取到返回的方法签名用于生成NSInvocation对象。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    //可以invokeWithTarget转发给多个对象
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
    
    [self dynamicAddMethod];
}

void dynamicMethodIMP(id self, SEL _cmd) {
    NSLog(@"Dynamically added method has been called");
}

- (void)dynamicAddMethod
{
    Class clazz = [MethodTestForward class];

    // 添加方法
    SEL dynamicMethodSelector = @selector(dynamicMethod);
    IMP dynamicMethodImplementation = (IMP)dynamicMethodIMP;
    const char *types = "v@:"; // 方法签名，void返回值 ，@表示id类型参数，:表示selector参数
    class_addMethod(clazz, dynamicMethodSelector, dynamicMethodImplementation, types);

    // 调用动态添加的方法
    id myObject = [[clazz alloc] init];
    [myObject performSelector:dynamicMethodSelector];
}

@end
