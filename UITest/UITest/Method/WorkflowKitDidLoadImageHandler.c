//
//  WorkflowKitDidLoadImageHandler.m
//  UITest
//
//  Created by ByteDance on 2025/5/14.
//
#include "WorkflowKitDidLoadImageHandler.h"
#include <dispatch/dispatch.h>
#include <dlfcn.h>
#include <stdio.h>

static WorkflowKitLoadClassHandler kPreLoadClassHandler = NULL;
void WorkflowKitSetPreLoadClassHandler(WorkflowKitLoadClassHandler handler)
{
    kPreLoadClassHandler = handler;
}

static WorkflowKitLoadClassHandler kPostLoadClassHandler = NULL;
void WorkflowKitSetPostLoadClassHandler(WorkflowKitLoadClassHandler handler)
{
    kPostLoadClassHandler = handler;
}

void WorkflowKitDidLoadHandler(const struct mach_header *mhp, intptr_t slide)  __attribute__((no_sanitize("address")))
{
    Dl_info info;
    if (dladdr(mhp, &info) == 0) {
        return;
    }
    printf("info.dli_fname : %s \n",info.dli_fname);
    if (strstr(info.dli_fname, "WorkflowKit") == NULL) {
        return;
    }
    if (kPreLoadClassHandler) {
        kPreLoadClassHandler();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (kPostLoadClassHandler) {
            kPostLoadClassHandler();
        }
    });
}
