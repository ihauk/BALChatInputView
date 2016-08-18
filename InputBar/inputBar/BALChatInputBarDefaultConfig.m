//
//  BALChatInputBarDefaultConfig.m
//  InputBar
//
//  Created by zhuhao on 16/7/2.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALChatInputBarDefaultConfig.h"
#import "BALClassManager.h"

@implementation BALChatInputBarDefaultConfig

+(void)load {
    [super load];
    
    [BALClassManager registerClass:self forkey:kBALChatToolBarConfig];
}

- (NSArray<NSNumber *> *)inputBarItemTypes {
    
    return @[@(BALInputBarItemTypeShortCutText),@(BALInputBarItemTypeVoice),@(BALInputBarItemTypeTextOrVoice),@(BALInputBarItemTypeEmoticon),@(BALInputBarItemTypeMore)];
}

- (CGFloat)bottomInputViewHeight {
    
    return 216.0;
}

- (CGFloat)topToolbarInputViewHeight{
    
    return 46.0;
}

@end
