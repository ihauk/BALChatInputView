//
//  ViewController.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "ViewController.h"
#import "BALChatInputView.h"
#import "BALInputEmotionCateModel.h"

@interface ViewController ()<BALChatInputViewDelegate>

@property(nonatomic,strong) BALChatInputView *chatInputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chatInputView = [[BALChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, CGRectGetMaxX(self.view.frame), 49) type:BALChatInputToolbarDefaultType];
    _chatInputView.delegate = self;
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

#pragma mark -
#pragma mark - delegate 

-(void)chatInputView:(BALChatInputView *)inputView didTriggerSendAction:(NSString *)senderText {
    NSLog(@"点击发送：%@",senderText);
}

-(void)chatInputView:(BALChatInputView *)inputView didSelectShortutText:(NSString *)shortcutTex {
    NSLog(@"快捷文本 - %@",shortcutTex);
    
}

- (void)chatInputView:(BALChatInputView *)inputView didSelectOpenPhotoAlbumPluginItem:(NSInteger)actionTag {
    NSLog(@"打开相册 %ld",(long)actionTag);
}

-(void)chatInputView:(BALChatInputView *)inputView didSelectOpenCameraPluginItem:(NSInteger)actionTag {
    NSLog(@"打开camera %ld",(long)actionTag);
}

-(void)chatInputView:(BALChatInputView *)inputView didSelectOpenLocationPluginItem:(NSInteger)actionTag {
    NSLog(@"打开位置 %ld",(long)actionTag);
}

-(void)chatInputView:(BALChatInputView *)inputView didSelectCustomPluginItem:(NSInteger)actionTag {
    NSLog(@"点击自定义 %ld",(long)actionTag);
}

- (void)chatInputView:(BALChatInputView *)inputView didSelectEmotionImage:(BALInputEmotionModel *)emotionImage {
    NSLog(@"emotion image ,%@",emotionImage.fileName);
}

- (void)chatInputView:(BALChatInputView *)inputView didEndRecordAudio:(NSData *)audioData {
    NSLog(@"语音完成");
}

- (void)chatInputView:(BALChatInputView *)inputView didCancleRecordAudio:(NSData *)audioData {
    NSLog(@"取消录音");
}

@end
