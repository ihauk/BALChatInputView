//
//  BALInputToolBar.h
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALChatInputDefine.h"
#import "BALChatToolBarConfig.h"



@interface BALChatInputToolBar : UIView

// 切换defaule type 与 pub type
@property(nonatomic,strong) UIButton *typeChangeBtn;

@property(nonatomic,strong) UIView *inputContainerView;
@property(nonatomic,strong) UIView *menuContainerView;

@property(nonatomic,strong) UIButton *shortCutTextBtn;
// 录音与文本输入 切换按钮
@property(nonatomic,strong) UIButton *voiceAndTextChangeBtn;
@property(nonatomic,strong) UIButton *emotionButton;
@property(nonatomic,strong) UIButton *moreButton;
@property(nonatomic,strong) UITextView *inputTextView;
@property(nonatomic,strong) UIButton *recordButton;

@property(nonatomic,assign) BALChatInputToolbarType currentType;

@property(nonatomic,weak) id<BALChatToolBarConfig> config;

- (instancetype)initWithToolBarType:(BALChatInputToolbarType)type ;
- (void)setupChatInputToolbarWithType:(BALChatInputToolbarType)type ;

- (void)setCharInputBarItemTypes:(NSArray<NSNumber *> *)types;
@end
