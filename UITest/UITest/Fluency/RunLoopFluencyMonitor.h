//
//  RunLoopFluencyMonitor.h
//  UITest
//
//  Created by ByteDance on 2024/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RunLoopFluencyMonitor : NSObject

+ (instancetype)shareMonitor;

@end

NS_ASSUME_NONNULL_END
