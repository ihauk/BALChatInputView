//
//  BALInputShortcutTextContainerView.m
//  InputBar
//
//  Created by zhuhao on 16/7/3.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputShortcutTextContainerView.h"

@interface BALInputShortcutTextContainerView ()<BALShortcutTextListViewDelegate>

@end

@implementation BALInputShortcutTextContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        
        [self initSubviews];
    }
    
    return self;
}

- (void)initSubviews {
    _textListView = [[BALShortcutTextListView alloc] initWithFrame:CGRectZero];
    _textListView.shortcutDelegate = self;
    [self addSubview:_textListView];
    
    [self setShortcutTextArray:[self getShortcutTextDataSource]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textListView.frame = self.bounds;
}

-(void)setShortcutTextArray:(NSArray *)array {
    [_textListView setShortcutTextArray:array];
}

/**
 *  从配置文件 加载 快捷用语
 */
- (NSArray*)getShortcutTextDataSource {
    
    NSString *path = [[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Input.bundle"] stringByAppendingPathComponent:@"ChatInput.plist"];
    NSDictionary *configDic = [[NSDictionary alloc]initWithContentsOfFile:path];
    NSArray *textDS = [configDic objectForKey:@"ShortcutTextDS"];
    
    return textDS;
}

#pragma mark -
#pragma mark - BALShortcutTextListViewDelegate

- (void)shortcutTextListView:(BALShortcutTextListView *)pluginBoardView didSelectAtIndex:(NSInteger)index text:(NSString *)text {
    NSLog(@"shortcut text :%@",text);
}

@end
