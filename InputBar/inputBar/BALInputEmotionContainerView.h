//
//  BALInputEmotionContainerView.h
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALPagedScrollView.h"
@class BALInputEmotionTabScrollView;


@interface BALInputEmotionContainerView : UIView

@property(nonatomic,strong) BALInputEmotionTabScrollView *cateTabView;
@property(nonatomic,strong) BALPagedScrollView *pagedScrollView;

@end
