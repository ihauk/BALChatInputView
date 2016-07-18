//
//  BALPagedChatFaceViewCell.m
//  InputBar
//
//  Created by zhuhao on 16/7/15.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALPagedChatFaceViewCell.h"
#import "BALUtility.h"
#import "BALChatInputDefine.h"

NSString *kInputEmotionDidTouchedNotification = @"kInputEmotionDidTouchedNotification_BAL";

@interface BALPagedChatFaceViewCell ()
@property(nonatomic,strong) NSArray<BALInputEmotionModel*> *emotionArray;
@end

@implementation BALPagedChatFaceViewCell


-(void)setEmotionArray:(NSArray<BALInputEmotionModel *> *)emotionArray withLayout:(BALInputEmotionLayout*)layout{
    _emotionArray = emotionArray;
    
    NSArray* subVs = self.contentView.subviews;
    [subVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    NSInteger row = layout.rows;
    NSInteger colume = layout.columes;
    int i;
//    int originX = 0;
//    int originY = 0;
    CGFloat originX          = (layout.cellWidth - layout.imageWidth) / 2  + BALInput_EmojiLeftMargin;
    CGFloat startX = originX;
    CGFloat originY          = BALInput_EmojiTopMargin;
    CGFloat startY = originY;
    for (i = 0; i < row; i++) {
        int j;
        for (j = 0; j < colume; j++) {
            NSInteger index = i*colume+j;
            if (index >= emotionArray.count) {
                return;
            }
            BALInputEmotionModel *theEmotion = [emotionArray objectAtIndex:index];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, layout.imageWidth, layout.imageHeight)];
            btn.tag = index;
            startX += layout.cellWidth;
            [btn setImage:[BALUtility emotionImageWithContentOfFile:theEmotion.fileName] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(emotionDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
            
//            [btn setBackgroundColor:[UIColor grayColor]];
            [self.contentView addSubview:btn];
        }
        startY += layout.cellHeight+originY;
        startX = originX;
    }
    
}

#pragma mark -
#pragma mark - Action 

- (void)emotionDidTouchedAction:(UIButton*)sender {
    
    BALInputEmotionModel*model = _emotionArray[sender.tag];
//    NSLog(@"%@",model.showName);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputEmotionDidTouchedNotification object:model];
}


@end
