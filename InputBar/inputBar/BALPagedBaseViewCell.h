//
//  BALPagedBaseViewCell.h
//  InputBar
//
//  Created by zhuhao on 16/7/18.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALInputEmotionCateModel.h"
#import "BALInputPluginItemModel.h"

@class BALPagedBaseViewCell;

@protocol BALPagedViewCellDelegate <NSObject>

- (void)pagedViewCell:(BALPagedBaseViewCell*)viewCell didSelectedOnEmotion:(BALInputEmotionModel*)emotionModel;


- (void)pagedViewCell:(BALPagedBaseViewCell*)viewCell didSelectedOnPluginItem:(BALInputPluginItemModel*)pluginModel;

@end

@interface BALPagedBaseViewCell : UICollectionViewCell

//@property(nonatomic,weak) id<BALPagedViewCellDelegate> delegate;

@end
