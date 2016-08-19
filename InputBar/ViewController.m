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
#import "GmacsPublicServiceMenu.h"

@interface ViewController ()<BALChatInputViewDelegate>

@property(nonatomic,strong) BALChatInputView *chatInputView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _chatInputView = [[BALChatInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, CGRectGetMaxX(self.view.frame), 49) type:BALChatInputToolbarPubType];
    _chatInputView.delegate = self;
    [self.view addSubview:_chatInputView];
    GmacsPublicServiceMenu *pubMenu = [[GmacsPublicServiceMenu alloc] initWithMenuDic:[self getPubMenus]];
    [_chatInputView configPublicServiceMenu:pubMenu];
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
#pragma mark - pubmenu

-(NSDictionary *)getPubMenus {
    NSString *path = [[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Input.bundle"] stringByAppendingPathComponent:@"ChatInput.plist"];
    NSDictionary *configDic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSDictionary *pubmenus = [configDic objectForKey:@"PubMenus"];
    
    return pubmenus;
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

#pragma mark -
#pragma mark - 旋转

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"willRotateToInterfaceOrientation");
    int width = 0;
    int orignY =0;
    switch (toInterfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            width = CGRectGetMaxX(self.view.frame);
            orignY = self.view.bounds.size.height-49;
        }
            break;
            
        default:
        {
            width = CGRectGetMaxY(self.view.frame);
            orignY = self.view.bounds.size.width-49;
        }
            break;
    }
    
    _chatInputView.frame = CGRectMake(0, orignY, width, 49);
}

//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    NSLog(@"viewWillTransitionToSize");
//}



@end
