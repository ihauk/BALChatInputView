//
//  BALInputShortcutTextContainerView.h
//  InputBar
//
//  Created by zhuhao on 16/7/3.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALShortcutTextListView.h"

@interface BALInputShortcutTextContainerView : UIView

@property(nonatomic,strong) BALShortcutTextListView *textListView;

- (void)setShortcutTextArray:(NSArray*)array;

@end
