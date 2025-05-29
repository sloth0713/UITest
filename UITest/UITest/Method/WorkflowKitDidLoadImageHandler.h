//
//  WorkflowKitDidLoadImageHandler.h
//  UITest
//
//  Created by ByteDance on 2025/5/14.
//

#include <mach-o/dyld.h>

typedef void (*WorkflowKitLoadClassHandler)(void);

#ifdef __cplusplus
extern "C" {
#endif
extern void WorkflowKitSetPreLoadClassHandler(WorkflowKitLoadClassHandler _Nonnull handler);

extern void WorkflowKitSetPostLoadClassHandler(WorkflowKitLoadClassHandler _Nonnull handler);

extern void WorkflowKitDidLoadHandler(const struct mach_header * _Nonnull mhp, intptr_t slide)  __attribute__((no_sanitize("address")));
#ifdef __cplusplus
}
#endif
