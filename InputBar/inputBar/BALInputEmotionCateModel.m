//
//  BALInputEmotionCateModel.m
//  InputBar
//
//  Created by zhuhao on 16/7/14.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputEmotionCateModel.h"
#import "BALChatInputDefine.h"
#import "BALUtility.h"

@implementation BALInputEmotionModel

+ (BALInputEmotionModel *)deleteEmotionModel {
    BALInputEmotionModel *model = [[BALInputEmotionModel alloc] init];
    model.showName = @"删除";
    model.fileName = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Input.bundle"] stringByAppendingPathComponent:@"emoji_del_normal.png"];
    
    return model;
}

@end

@implementation BALInputEmotionCateModel

@end

@implementation BALInputEmotionLayout

- (id)initEmojiLayout:(CGFloat)width
{
    self = [super init];
    if (self)
    {
        _rows            = BALInput_EmojRows;
        _columes         = ((width - BALInput_EmojiLeftMargin - BALInput_EmojiRightMargin) / BALInput_EmojImageWidth);
        _itemCountInPage = _rows * _columes -1;
        _cellWidth       = (width - BALInput_EmojiLeftMargin - BALInput_EmojiRightMargin) / _columes;
        _cellHeight      = BALInput_EmojCellHeight;
        _imageWidth      = BALInput_EmojImageWidth;
        _imageHeight     = BALInput_EmojImageHeight;
        _emoji           = YES;
    }
    return self;
}

- (id)initCharletLayout:(CGFloat)width {
    self = [super init];
    if (self)
    {
        _rows            = BALInput_PicRows;
        _columes         = ((width - BALInput_EmojiLeftMargin - BALInput_EmojiRightMargin) / BALInput_PicImageWidth);
        _itemCountInPage = _rows * _columes;
        _cellWidth       = (width - BALInput_EmojiLeftMargin - BALInput_EmojiRightMargin) / _columes;
        _cellHeight      = BALInput_PicCellHeight;
        _imageWidth      = BALInput_PicImageWidth;
        _imageHeight     = BALInput_PicImageHeight;
        _emoji           = NO;
    }
    return self;
}

@end
