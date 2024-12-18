//
//  TestTouchView.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "TestTouchView.h"

@interface TestTouchView ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation TestTouchView

- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name
{
    if (self=[super initWithFrame:frame]){
        self.name = name;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        label.text = name;
        [self addSubview:label];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.tapGesture.delegate = self;
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"gestureRecognizerShouldBegin Recognizer %@",self.name);
    //如果view和其父view的gestureRecognizerShouldBegin均为YES，最终tap回调会调用到最上层的子view的那个
    return YES;
}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    NSLog(@"tapGesture Recognizer %@",self.name);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //先父veiw，再子view，如果子view同级，会按照addSubView的顺序
    NSLog(@"进入%@_View---hitTest withEvent ---", self.name);
    UIView * view = [super hitTest:point withEvent:event];
    NSLog(@"离开%@_View--- hitTest withEvent ---hitTestView:%@", self.name,view);
    return view;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    NSLog(@"%@_view--- pointInside start withEvent ---", self.name);
    BOOL isInside = [super pointInside:point withEvent:event];
    NSLog(@"%@_view--- pointInside end withEvent --- isInside:%d", self.name,isInside);
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
