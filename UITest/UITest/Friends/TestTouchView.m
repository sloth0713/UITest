//
//  TestTouchView.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "TestTouchView.h"

@interface TestTouchView ()

@property (nonatomic, strong) NSString *name;

@end

@implementation TestTouchView

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name
{
    if (self=[super initWithFrame:frame]){
        self.name = name;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = name;
        [self addSubview:label];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //如果同级，会按照addSubView的顺序
    NSLog(@"进入%@_View---hitTest withEvent ---", self.name);
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开%@_View--- hitTest withEvent ---hitTestView:%@", self.name,view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    NSLog(@"%@_view--- pointInside withEvent ---", self.name);
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"%@_view--- pointInside withEvent --- isInside:%d", self.name,isInside);
    return isInside;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@_touchesBegan", self.name);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%@_touchesMoved", self.name);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%@_touchesEnded", self.name);
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@_touchesCancelled", self.name);
    [super touchesCancelled:touches withEvent:event];
}

@end
