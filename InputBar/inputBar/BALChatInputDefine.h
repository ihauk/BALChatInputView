//
//  BALChatInputDefine.h
//  InputBar
//
//  Created by zhuhao on 16/6/21.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#ifndef BALChatInputDefine_h
#define BALChatInputDefine_h

#define isAboveIOS8            ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)

// 主题色

#define BALInput_ChatToolBarBKColor  RGBCOLOR(236,236,236)
#define BALInput_AllBoardBKColor  [UIColor whiteColor]
#define BALInput_EmotionCateTabBKCOLor  [UIColor whiteColor]
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


#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#ifdef DEBUG
#define DebugLog( s, ... ) NSLog( @"[%@:(%d)] %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif

#endif /* BALChatInputDefine_h */
