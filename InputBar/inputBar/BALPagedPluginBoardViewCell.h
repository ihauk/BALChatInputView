//
//  BALPagedPluginBoardViewCell.h
//  InputBar
//
//  Created by zhuhao on 16/7/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALInputPluginItemModel.h"
#import "BALPagedBaseViewCell.h"

extern NSString *kInputPluginDidTouchedNotification;

@interface BALPagedPluginBoardViewCell : BALPagedBaseViewCell

-(void)setPluginsArray:(NSArray<BALInputPluginItemModel *> *)emotionArray withLayout:(BALInputPluginLayout*)layout;

@end
