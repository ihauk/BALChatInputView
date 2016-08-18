//
//  GmacsMultiTextBoardView.h
//  GmacsIMKit
//
//  Created by yinfurong on 15/12/1.
//  Copyright © 2015年 xugang. All rights reserved.
//

#ifndef __GmacsMultiTextBoardView
#define __GmacsMultiTextBoardView

#import <UIKit/UIKit.h>

@protocol BALShortcutTextListViewDelegate;

extern NSString *kInputShortcutTextDidTouchedNotification;

/**
 *  GmacsMultiTextBoardView,安居客经纪人 快捷文本发送视图
 */
@interface BALShortcutTextListView : UITableView<UITableViewDelegate,UITableViewDataSource>

/**
 *  代理
 */
@property (nonatomic, weak) id <BALShortcutTextListViewDelegate> shortcutDelegate;
/**
 *  数据源
 */
@property (nonatomic, strong) NSArray *shortcutTextArray;

@end

/**
 *  GmacsMultiTextBoardView 代理
 */
@protocol BALShortcutTextListViewDelegate <NSObject>

/**
 *  GmacsMultiTextBoardView 点击事件响应
 *
 *  @param pluginBoardView GmacsMultiTextBoardView 实例
 *  @param index           点击的索引
 *  @param text            被点击item 的 内容
 */
- (void)shortcutTextListView:(BALShortcutTextListView *)pluginBoardView didSelectAtIndex:(NSInteger)index text:(NSString*)text;

@end

#endif