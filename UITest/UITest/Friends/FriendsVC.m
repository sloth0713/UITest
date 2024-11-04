//
//  FriendsVC.m
//  UITest
//
//  Created by ByteDance on 2024/10/31.
//

#import "FriendsVC.h"
#import "TestTouchView.h"

@interface FriendsVC () <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITapGestureRecognizer *tabGestureRecognizer;

@end

@implementation FriendsVC

- (void)viewDidLoad
{
    TestTouchView *viewA = [[TestTouchView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-100) name:@"viewA"];
    viewA.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:viewA];
    
    TestTouchView *viewB = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 300, 200) name:@"viewB"];
    viewB.backgroundColor = [UIColor blueColor];
    [viewA addSubview:viewB];
    
    [viewA addSubview:self.textField];
    
    TestTouchView *viewC = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 400, 300, 300) name:@"viewC"];
    viewC.backgroundColor = [UIColor grayColor];
    [viewA addSubview:viewC];
    
    TestTouchView *viewD = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 200, 80) name:@"viewD"];
    viewD.backgroundColor = [UIColor redColor];
    [viewC addSubview:viewD];
    
    TestTouchView *viewE = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 150, 200, 80) name:@"viewE"];
    viewE.backgroundColor = [UIColor greenColor];
    [viewC addSubview:viewE];

//    TestTouchView *viewF = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 50, 200, 80) name:@"viewF"];
//    viewF.backgroundColor = [UIColor redColor];
//    [viewB addSubview:viewF];
//    
//    TestTouchView *viewG = [[TestTouchView alloc] initWithFrame:CGRectMake(50, 150, 200, 80) name:@"viewG"];
//    viewG.backgroundColor = [UIColor greenColor];
//    [viewB addSubview:viewG];

}

- (void)viewDidAppear:(BOOL)animated
{
    [self.textField becomeFirstResponder];
}

- (UITextField *)textField
{
    if (!_textField){
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 300, 300, 80)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        
        self.tabGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        self.tabGestureRecognizer.delegate = self;
        [self.view addGestureRecognizer:self.tabGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
    }
    return _textField;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField 
{

}

- (void)keyboardWillShow:(NSNotification *)notification 
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSLog(@"keyboardWillShow notification : %@",userInfo);
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - tabGestureRecognizer
- (void)hideKeyboard:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
}

@end
