//
//  BALPagedChatFaceViewCell.h
//  InputBar
//
//  Created by zhuhao on 16/7/15.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALInputEmotionCateModel.h"
#import "BALPagedBaseViewCell.h"

extern NSString* kInputEmotionDidTouchedNotification;

@interface BALPagedChatFaceViewCell : BALPagedBaseViewCell

-(void)setEmotionArray:(NSArray<BALInputEmotionModel *> *)emotionArray withLayout:(BALInputEmotionLayout*)layout;

@end
