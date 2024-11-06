//
//  Responder.h
//  UITest
//
//  Created by ByteDance on 2024/11/5.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Responder : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) UIViewController *topVC;

@end

