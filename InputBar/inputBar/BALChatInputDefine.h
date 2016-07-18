//
//  BALChatInputDefine.h
//  InputBar
//
//  Created by zhuhao on 16/6/21.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#ifndef BALChatInputDefine_h
#define BALChatInputDefine_h

// 主题色

#define BALInput_AllBoardBKColor  [UIColor whiteColor]
#define BALInput_EmotionCateTabBKCOLor  [UIColor grayColor]
#define BALInput_EmotionSendBtnBKCOLor  [UIColor blueColor]





//emoji
#define BALInput_EmojiLeftMargin      8
#define BALInput_EmojiRightMargin     8
#define BALInput_EmojiTopMargin       8
#define BALInput_DeleteIconWidth      43.0
#define BALInput_DeleteIconHeight     43.0
#define BALInput_EmojCellHeight       46.0
#define BALInput_EmojImageHeight      43.0
#define BALInput_EmojImageWidth       43.0
#define BALInput_EmojRows             3

//贴图
#define BALInput_PicCellHeight        76.0
#define BALInput_PicImageHeight       70.f
#define BALInput_PicImageWidth        70.f
#define BALInput_PicRows              2


typedef NS_ENUM(NSUInteger, BALChatInputToolbarType) {
    /**
     *  默认类型
     */
    BALChatInputToolbarDefaultType,
    
    /**
     *  公众号类型
     */
    BALChatInputToolbarPubType
};

typedef NS_ENUM(NSInteger,BALChatInputBarItemType){
    BALInputBarItemTypeNone,
    BALInputBarItemTypeShortCutText,  // 快速文本
    BALInputBarItemTypeVoice,         //录音文本切换按钮
    BALInputBarItemTypeTextOrVoice, //文本输入框或录音按钮
    BALInputBarItemTypeEmoticon,      //表情贴图
    BALInputBarItemTypeMore,          //更多菜单
};

#endif /* BALChatInputDefine_h */
