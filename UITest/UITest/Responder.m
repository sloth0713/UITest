//
//  Responder.m
//  UITest
//
//  Created by ByteDance on 2024/11/5.
//

#import "Responder.h"

@implementation Responder

+ (instancetype)shareInstance
{
    static Responder *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Responder alloc] init];
    });
    return share;
}

@end
