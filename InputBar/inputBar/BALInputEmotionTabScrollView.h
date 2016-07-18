//
//  BALInputEmotionCateScrollView.h
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALInputEmotionCateModel.h"

@class BALInputEmotionTabScrollView;

@protocol BALInputEmotionTabScrollViewDelegate <NSObject>

- (void)tabView:(BALInputEmotionTabScrollView *)tabView didSelectTabIndex:(NSInteger) index;

@end

@interface BALInputEmotionTabScrollView : UIView

@property(nonatomic,weak) id<BALInputEmotionTabScrollViewDelegate> tabDelegate;

-(void)setEmotionCates:(NSArray<BALInputEmotionCateModel*>*)cateArray;

@end
