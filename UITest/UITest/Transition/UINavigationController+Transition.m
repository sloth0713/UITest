//
//  UINavigationController+Transition.m
//  GestureTest
//
//  Created by ByteDance on 2024/10/18.
//

#import "UINavigationController+Transition.h"
#import "DefaultTransitionDelegate.h"
#import <objc/runtime.h>
#import <objc/message.h>


void _SWIZZLE_WITH_IMP(Class cls, SEL oldSEL, IMP newIMP, const char *encoding, IMP *outOldIMP)
{
    Method oldMethod = class_getInstanceMethod(cls, oldSEL);
    if (!oldMethod) return;

    if (outOldIMP != NULL) {
        *outOldIMP = method_getImplementation(oldMethod);
    }

    if (!encoding) encoding = method_getTypeEncoding(class_getInstanceMethod(cls, oldSEL));

    if (!class_addMethod(cls, oldSEL, newIMP, method_getTypeEncoding(oldMethod))) {
        method_setImplementation(oldMethod, newIMP);
    }

}

void getArgumentType(Method originalMethod)
{
    if (originalMethod) {
        unsigned int numberOfArguments = method_getNumberOfArguments(originalMethod);
        
        // 第一个两个参数分别为 "self" 和 "_cmd"，因此从第三个参数开始获取方法的参数类型
        for (unsigned int i = 2; i < numberOfArguments; i++) {
            char argType[256];
            method_getArgumentType(originalMethod, i, argType, 256);
            
            NSLog(@"Argument %u type: %s", i - 1, argType);
        }
    } else {
        NSLog(@"Method not found!");
    }
}

@implementation UINavigationController (Transition)

+(void)hookDelegate
{
    BOOL customNavigationTransition = YES;
    if (!customNavigationTransition) return;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self hookMethod:@selector(setDelegate:) swizzledSelectorPop:@selector(transition_setDelegate:)];
        
        [self hookMethod:@selector(pushViewController:animated:) swizzledSelectorPop:@selector(transition_pushViewController:animated:)];
        
        [self hookMethod:@selector(popViewControllerAnimated:) swizzledSelectorPop:@selector(transition_popViewControllerAnimated:)];
        
        [self keyBoardSMH];
    });
}

+ (void)keyBoardSMH
{
//    [self hookPerformOperations];//有crash
    [self hookUIView];//无法hook，没有这个方法
    [self hookAnimationStyle];
}

void logAllMethodsOfClass(Class class) {
    unsigned int count;
    Method *methods = class_copyMethodList(class, &count);
    
    for (unsigned int i = 0; i < count; i++) {
        Method method = methods[i];
        
        SEL methodName = method_getName(method);
        const char *methodNameString = sel_getName(methodName);
        
        NSLog(@"Method111: %s", methodNameString);
    }
    
    free(methods);
}

+ (void)hookUIView
{
    
    logAllMethodsOfClass([UIView class]);

    if ([[UIView class] respondsToSelector:sel_getUid("_setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:")]){
        NSLog(@"success respondsToSelector");
    }else{
        NSLog(@"can't respondsToSelector");//没有这个方法，可能是运行时生成的
    }
    
    Method originM = class_getClassMethod([UIView class], sel_getUid("_setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:"));
    
    if (originM) {
        getArgumentType(originM);
        
    } else {
        NSLog(@"Original method not found.");
    }
    
    Method swizzlingM = class_getClassMethod([UIView class], @selector(hook_setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:));
    BOOL success = class_addMethod([UIView class], @selector(hook_setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:), method_getImplementation(originM), method_getTypeEncoding(originM));
    if (success) {
        method_exchangeImplementations (originM, swizzlingM);
    }
}


+ (void)hook_setupAnimationWithDuration:(NSTimeInterval)duration
                                  delay:(NSTimeInterval)delay
                                   view:(UIView *)view
                                options:(UIViewAnimationOptions)options
                                factory:(id)factory
                             animations:(id)animations
                                  start:(id)start
                animationStateGenerator:(id)generator
                             completion:(id)completion {
    
    NSLog(@"Hooked _setupAnimationWithDuration method");
    
    //    return [self hook_setupAnimationWithDuration:duration delay:delay view:view options:options factory:factory animations:animations start:start animationStateGenerator:generator completion:completion];
    
    // You can add your custom implementation here or call the original method if needed
}


void hook_performOperationsWithAnimationStyle(id self, SEL _cmd, id operations, id animationStyle) {
    NSLog(@"Hooked Method: Performing operations with animation style: %d", animationStyle);
    
    // Call original implementation
    SEL originalSelector = sel_registerName("performOperations:withAnimationStyle:");
    //AnimationStyle是一个<<UIInputViewAnimationStyle: 0x3007c03c0>; animated = NO; duration =  0; force = NO>没有意义。而且这个hook会堆栈溢出
    ((void (*)(id, SEL, id, int))objc_msgSend)(self, originalSelector, operations, animationStyle);
}

+ (void)hookPerformOperations
{
    Class UIInputWindowControllerClass = NSClassFromString(@"UIInputWindowController");
    SEL originalSelector = sel_registerName("performOperations:withAnimationStyle:");
    
    _SWIZZLE_WITH_IMP(UIInputWindowControllerClass, originalSelector, (IMP)hook_performOperationsWithAnimationStyle, "v@:@i", NULL);
    
}

+ (void)hookAnimationStyle
{
    Class UIInputViewAnimationStyleClass = NSClassFromString(@"UIInputViewAnimationStyle");
    SEL originalSelector = sel_registerName("launchAnimation:afterStarted:completion:forHost:fromCurrentPosition:");
    Method originalMethod = class_getInstanceMethod(UIInputViewAnimationStyleClass, originalSelector);
    
    const char *typeEncoding = method_getTypeEncoding(originalMethod);
    
    if (originalMethod) {
        
        IMP originalImp = method_getImplementation(originalMethod);
        
        // 定义一个新的方法实现
        void (^newImp)(id, id, id, id, id, BOOL) = ^(id self, id launchAnimation, id afterStarted, id completion, id forHost, BOOL fromCurrentPosition) {
//            NSLog(@"Hooked Method: Performing operations with animation style");
   
            if ([[UIView class] respondsToSelector:sel_getUid("_setupAnimationWithDuration:delay:view:options:factory:animations:start:animationStateGenerator:completion:")]){
                NSLog(@"success respondsToSelector");
            }else{
                NSLog(@"can't respondsToSelector");//没有这个方法，可能是运行时生成的
            }
            
            [self setValue:@(0.01) forKey:@"duration"];
            // 调用原始方法
            ((void(*)(id, SEL, id, id, id, id, BOOL))originalImp)(self, originalSelector, launchAnimation, afterStarted, completion, forHost, fromCurrentPosition);
        };
        
        // 替换原始方法的实现
        class_replaceMethod(UIInputViewAnimationStyleClass, originalSelector, imp_implementationWithBlock(newImp), method_getTypeEncoding(originalMethod));
        
        
    } else {
        NSLog(@"Original method not found.");
    }
}

+ (void)hookMethod:(SEL)originalSelector swizzledSelectorPop:(SEL)swizzledSelector
{
    Method originalMethodPop = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethodPop = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethodPop, swizzledMethodPop);
}

- (void)transition_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    [self transition_setDelegate:delegate];
}

//[UINavigationController initWithRootViewController:]会自动调用到pushViewController
- (void)transition_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.delegate){
        
        TransitionContext *context  = [[TransitionContext alloc] init];
        self.transition_navigationProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
        self.delegate = self.transition_navigationProxyDelegate;
    }
    self.transition_navigationProxyDelegate.context.type = TransitionTypePush;
    [self transition_pushViewController:viewController animated:animated];
}

- (UIViewController *)transition_popViewControllerAnimated:(BOOL)animated
{
    if (!self.delegate){
        TransitionContext *context  = [[TransitionContext alloc] init];
        self.transition_navigationProxyDelegate = [[DefaultTransitionDelegate alloc] initWithContext:context];
        self.delegate = self.transition_navigationProxyDelegate;
    }
    self.transition_navigationProxyDelegate.context.type = TransitionTypePop;
    return [self transition_popViewControllerAnimated:animated];
}

//- (id<UINavigationControllerDelegate>)transition_delegate
//{
//    NSLog(@"fdas");
//    if (!self.delegate){
//        self.delegate = [[DefaultTransitionDelegate alloc] init];
//        [self transition_setDelegate:[[DefaultTransitionDelegate alloc] init]];
//    }
//    return [self transition_delegate];
////    [self transition_setDelegate:delegate];
//}

- (void)setTransition_navigationProxyDelegate:(DefaultTransitionDelegate *)transition_navigationProxyDelegate
{
    //分类不能新增属性，所以这样添加
    objc_setAssociatedObject(self, @selector(transition_navigationProxyDelegate), transition_navigationProxyDelegate, OBJC_ASSOCIATION_RETAIN);
}

- (DefaultTransitionDelegate *)transition_navigationProxyDelegate
{
    return objc_getAssociatedObject(self, _cmd);
}


@end
