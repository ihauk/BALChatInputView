//
//  BALPagedPluginBoardViewCell.m
//  InputBar
//
//  Created by zhuhao on 16/7/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALPagedPluginBoardViewCell.h"
#import "BALChatInputDefine.h"
#import "BALUtility.h"

 NSString *kInputPluginDidTouchedNotification = @"kInputPluginDidTouchedNotification_BAL";

@interface BALPagedPluginBoardViewCell ()
@property(nonatomic,strong) NSArray<BALInputPluginItemModel*> *pluginItemArray;
@end

@implementation BALPagedPluginBoardViewCell

- (void)setPluginsArray:(NSArray<BALInputPluginItemModel *> *)pluginArray withLayout:(BALInputPluginLayout *)layout {
    
    _pluginItemArray = pluginArray;
    
    NSArray* subVs = self.contentView.subviews;
    [subVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    
    NSInteger row = layout.pageRowCount;
    NSInteger colume = layout.pageColumnCount;
    int i;
    //    int originX = 0;
    //    int originY = 0;
    CGFloat originX          =  (self.frame.size.width - layout.itemWidth*4)/5;
    CGFloat startX = originX;
    CGFloat originY          = (self.frame.size.height - layout.itemHeight*2)/3;
    CGFloat startY = originY;
    for (i = 0; i < row; i++) {
        int j;
        for (j = 0; j < colume; j++) {
            NSInteger index = i*colume+j;
            if (index >= pluginArray.count) {
                return;
            }
            BALInputPluginItemModel *theEmotion = [pluginArray objectAtIndex:index];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, layout.itemWidth, layout.itemHeight)];
            btn.tag = index;
            startX += layout.itemWidth + originX;
            [btn setImage:theEmotion.image forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(pluginItemDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
            //            [btn setBackgroundColor:[UIColor grayColor]];
            [self.contentView addSubview:btn];
        }
        startY += layout.itemWidth+originY;
        startX = originX;
    }
}

#pragma mark -
#pragma mark - action 

- (void)pluginItemDidTouchedAction:(UIButton*)sender {
    
    BALInputPluginItemModel *model = _pluginItemArray[sender.tag];
//    NSLog(@"%@",model.title);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputPluginDidTouchedNotification object:model];
}


@end
