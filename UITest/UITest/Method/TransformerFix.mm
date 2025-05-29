//
//  TransformerFix.c
//  UITest
//
//  Created by ByteDance on 2025/5/14.
//

#include "TransformerFix.h"


//#import <Mantle/MTLModel.h>
//#import <Mantle/NSValueTransformer+MTLPredefinedTransformerAdditions.h>
#include <mach-o/dyld.h>
#include <unordered_map>
#include <unordered_set>
#include <iostream>
#include <objc/runtime.h>
#include "WorkflowKitDidLoadImageHandler.h"

static const std::unordered_set<SEL> g_selectors = {
    @selector(mtl_validatingTransformerForClass:),
    @selector(mtl_valueMappingTransformerWithDictionary:),
    @selector(mtl_valueMappingTransformerWithDictionary:defaultValue:reverseDefaultValue:)
};
static std::unordered_map<SEL, IMP> g_realImpsMap;
static void WorkflowKitPreLoadClass(void)
{
    for (const auto& selector : g_selectors) {
        g_realImpsMap[selector] = method_getImplementation(class_getClassMethod(NSValueTransformer.class, selector));
    }
}

static void WorkflowKitPostLoadClass(void)
{
    unsigned int count = 0;
    Method *methods = class_copyMethodList(object_getClass(NSValueTransformer.class), &count);
    for (NSInteger i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if (g_selectors.find(selector) == g_selectors.end()) {
            continue;
        }
        auto it = g_realImpsMap.find(selector);
        if (it != g_realImpsMap.end()) {
            IMP realImp = it->second;
            IMP imp = method_getImplementation(method);
            if (imp != realImp) {
                method_setImplementation(method, realImp);
            }
        }
    }
    free(methods);
}

@implementation TransformerFix

+ (void)fix
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WorkflowKitSetPreLoadClassHandler(WorkflowKitPreLoadClass);
        WorkflowKitSetPostLoadClassHandler(WorkflowKitPostLoadClass);
        _dyld_register_func_for_add_image(WorkflowKitDidLoadHandler);
    });
}

@end
