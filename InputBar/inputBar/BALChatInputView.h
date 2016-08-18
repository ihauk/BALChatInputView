//
//  BALChatInputView.h
//  InputBar
//
//  Created by zhuhao on 16/6/21.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALChatInputToolBar.h"
#import "BALChatToolBarConfig.h"

@class BALChatInputView;
@class BALInputEmotionContainerView;
@class BALInputMorePluginContainerView;
@class BALInputShortcutTextContainerView;
@class BALInputEmotionModel;
@class BALInputPluginItemModel;


//typedef NS_ENUM(NSUInteger, BALChatInputToolbarStyle) {
//    /**
//     *  默认类型：有语音，文字，emotion，plugin
//     */
//    BALChatInputToolbarDefaultStyle,
//    
//    
//};


/**
 *  输入框状态
 */
typedef NS_ENUM(NSInteger, BALChatInputViewStatus) {
    /**
     *  默认状态，不展开
     */
    KChatInputViewDefaultStatus = 0,
    /**
     *  键盘
     */
    KChatInputViewTextStatus,
    /**
     *  扩张（加号）
     */
    KChatInputViewMorePluginStatus,
    /**
     *  表情
     */
    KChatInputViewEmotionStatus,
    /**
     *  语音
     */
    KChatInputViewRecordStatus,
    /**
     *  快捷文本
     */
    KChatInputViewShortcutTextStatus
};

// ///////////////////////////////////////////////////////////////////////////
// ///////////////////////////////////////////////////////////////////////////

@protocol BALChatInputViewDelegate <NSObject>

- (void)chatInputView:(BALChatInputView*)inputView didTriggerSendAction:(NSString*)senderText;

- (void)chatInputView:(BALChatInputView*)inputView didSelectEmotionImage:(BALInputEmotionModel*)emotionImage;

- (void)chatInputView:(BALChatInputView*)inputView didSelectPluginItem:(BALInputPluginItemModel*)pluginItem;

- (void)chatInputView:(BALChatInputView*)inputView didSelectShortutText:(NSString*)shortcutText;

@end


/**
 *  聊天输入框 对外 使用视图
 */
@interface BALChatInputView : UIView

@property(nonatomic,assign) BALChatInputViewStatus inputStatus;
@property(nonatomic,strong) BALChatInputToolBar *inputToolBar;
@property(nonatomic,strong) BALInputEmotionContainerView *emotionContainerView;
@property(nonatomic,strong) BALInputMorePluginContainerView *moreContainerView;
@property(nonatomic,strong) BALInputShortcutTextContainerView *shortcutTextContainerView;
@property(nonatomic,weak) id<BALChatInputViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                         type:(BALChatInputToolbarType)type;

- (void)setChatInputConfig:(id<BALChatToolBarConfig>)config;

- (void)layoutChatInputViewWithStatus:(BALChatInputViewStatus)status;

@end
