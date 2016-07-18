//
//  BALInputEmotionCateScrollView.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputEmotionTabScrollView.h"
#import "BALUtility.h"
#import "BALChatInputDefine.h"

static const NSInteger senderWidth = 60;

@interface BALInputEmotionTabScrollView ()

@property(nonatomic,strong) UIScrollView *emotioncateScrollView;
@property(nonatomic,strong) UIButton *sendButton;
@property(nonatomic,strong) NSArray<BALInputEmotionCateModel*> *cateTabModelArray;
@property(nonatomic,strong) NSMutableArray<UIView*> *tabViewArray;

@end

@implementation BALInputEmotionTabScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    _emotioncateScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _emotioncateScrollView.backgroundColor = BALInput_EmotionCateTabBKCOLor;
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setBackgroundColor:BALInput_EmotionSendBtnBKCOLor];
    
    [self addSubview:_emotioncateScrollView];
    [self addSubview:_sendButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.frame;
    int height = rect.size.height;
    int width = rect.size.width;
    
    _emotioncateScrollView.frame = CGRectMake(0, 0, width-senderWidth, height);
    _sendButton.frame = CGRectMake(width-senderWidth, 0, senderWidth, height);
    
    [self setupEmotionCates:_cateTabModelArray];
}

-(void)setEmotionCates:(NSArray<BALInputEmotionCateModel *> *)cateArray {
    _cateTabModelArray = cateArray;
    
    int itemWidth = self.frame.size.height;
    
    if (itemWidth == 0 ) {
        return;
    }
    
    [self setupEmotionCates:cateArray];
    
}

- (void)setupEmotionCates:(NSArray<BALInputEmotionCateModel*>*)cateArray {
   
    int itemWidth = self.frame.size.height;
    int itemHeight = itemWidth;
    __block int originX = 0;
    _tabViewArray = [NSMutableArray array];
    [cateArray enumerateObjectsUsingBlock:^(BALInputEmotionCateModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(originX, 0, itemWidth, itemHeight)];
        [item setImage:[BALUtility emotionImageWithContentOfFile:obj.iconName] forState:UIControlStateNormal];
        [item setImage:[BALUtility emotionImageWithContentOfFile:obj.highlightIconName] forState:UIControlStateHighlighted];
        [item setImage:[BALUtility emotionImageWithContentOfFile:obj.highlightIconName] forState:UIControlStateSelected];
        [item addTarget:self action:@selector(didBottomTabItemTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_emotioncateScrollView addSubview:item];
        [_tabViewArray addObject:item];
        originX += itemWidth;
        
    }];
}

#pragma mark -
#pragma mark - action

- (void)didBottomTabItemTouchedAction:(UIButton*)sender {
    NSInteger selectedIndex = [_tabViewArray indexOfObject:sender];
    
    [self selectedCateTabAtIndex:selectedIndex];
    if (self.tabDelegate && [self.tabDelegate respondsToSelector:@selector(tabView:didSelectTabIndex:)]) {
        [self.tabDelegate tabView:self didSelectTabIndex:selectedIndex];
    }
}

- (void)selectedCateTabAtIndex:(NSInteger)index{
    int i ;
    for (i = 0; i < _tabViewArray.count; i++) {
        
        UIButton *btn = (UIButton*)_tabViewArray[i];
        btn.selected = i == index ;
    }
}

@end
