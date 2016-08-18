//
//  ViewController.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "ViewController.h"
#import "BALChatInputView.h"

@interface ViewController ()

@property(nonatomic,strong) BALChatInputView *chatInputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chatInputView = [[BALChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, CGRectGetMaxX(self.view.frame), 49) type:BALChatInputToolbarDefaultType];
    
    [self.view addSubview:_chatInputView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
//    [self.view endEditing:YES];
    [_chatInputView layoutChatInputViewWithStatus:KChatInputViewDefaultStatus];
}


@end
