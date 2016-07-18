//
//  BALInputToolBar.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALChatInputToolBar.h"
#import "BALUtility.h"

@interface BALChatInputToolBar ()

@property(nonatomic,strong) NSArray *inputTypes;
@property(nonatomic,copy)  NSDictionary *viewAndTypeMap;
@property(nonatomic,assign) NSInteger inputItemWidth;
@property(nonatomic,assign) NSInteger leftRightSpace;

@end

@implementation BALChatInputToolBar

-(instancetype)initWithToolBarType:(BALChatInputToolbarType)type {
    self = [super init];
    if (self) {
        [self setupChatInputToolbarWithType:type];
        self.inputItemWidth = 32;
        self.leftRightSpace = 4;
    }
    
    return self;
}

- (void)setupChatInputToolbarWithType:(BALChatInputToolbarType)type {
    _currentType = type;
    
    if (BALChatInputToolbarDefaultType == type) {
        _typeChangeBtn = nil;
        _inputContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_inputContainerView];
    } else {
        _typeChangeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_typeChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"公众号_菜单"] forState:UIControlStateNormal];
        [_typeChangeBtn addTarget:self action:@selector(changeChatInputBarType:) forControlEvents:UIControlEventTouchUpInside];
        
        _inputContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_typeChangeBtn];
        [self addSubview:_inputContainerView];
        [self addSubview:_menuContainerView];
    }
    
    _shortCutTextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_shortCutTextBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发送常用语_正常"] forState:UIControlStateNormal];
//    _shortCutTextBtn.backgroundColor = [UIColor greenColor];
    
    _voiceAndTextChangeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_voiceAndTextChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发声音按钮_正常"] forState:UIControlStateNormal];
//    _voiceAndTextChangeBtn.backgroundColor = [UIColor redColor];
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_recordButton setBackgroundImage:[BALUtility chatInputImageWithNamed:@"声音_输入框_正常状态"] forState:UIControlStateNormal];
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    _recordButton.backgroundColor = [UIColor purpleColor];
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _inputTextView.layer.borderWidth = 1;
    _inputTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextView.layer.cornerRadius = 5;
    _inputTextView.layer.masksToBounds = YES;
//    _inputTextView.backgroundColor = [UIColor whiteColor];
    
    _emotionButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_emotionButton setImage:[BALUtility chatInputImageWithNamed:@"聊天_发表情按钮_正常"] forState:UIControlStateNormal];
//    _emotionButton.backgroundColor = [UIColor grayColor];
    
    _moreButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_moreButton setImage:[BALUtility chatInputImageWithNamed:@"聊天_发其他按钮_正常"] forState:UIControlStateNormal];
//    _moreButton.backgroundColor = [UIColor blackColor];
}

-(void)setCharInputBarItemTypes:(NSArray<NSNumber *> *)types {
    self.inputTypes = types;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIView *finalContainer = nil;
    if (BALChatInputToolbarDefaultType == _currentType) {
        _inputContainerView.frame = self.bounds;
        finalContainer = _inputContainerView;
    } else {
        _typeChangeBtn.frame = CGRectMake(_leftRightSpace, 2, _inputItemWidth, _inputItemWidth);
        CGPoint center = _typeChangeBtn.center;
        center.y = self.center.y;
        _typeChangeBtn.center = center;
        
        _menuContainerView.frame = CGRectMake(CGRectGetMaxX(_typeChangeBtn.frame), 0, self.frame.size.width - CGRectGetMaxX(_typeChangeBtn.frame), self.frame.size.height);
        _menuContainerView.backgroundColor = [UIColor greenColor];
        _inputContainerView.frame = _menuContainerView.frame;
        _inputContainerView.backgroundColor = [UIColor redColor];
        finalContainer = _menuContainerView;
    }

    
    int originX = (int)_leftRightSpace;
    NSInteger textItemWidth = [self getTextOrRecordInputItemWidth];
    NSInteger normalItemWidth = _inputItemWidth;
    for (NSNumber *item in self.inputTypes) {
        UIView *itemView = [self chatInputBarItemViewOfType:item.integerValue];
        
        if (item.integerValue == BALInputBarItemTypeTextOrVoice) {
            normalItemWidth = textItemWidth;
        }else{
            normalItemWidth = _inputItemWidth;
        }
        itemView.frame = CGRectMake(originX, 2, normalItemWidth, _inputItemWidth);
        
        CGPoint center = itemView.center;
        center.y = self.center.y;
        itemView.center = center;
        
        originX += CGRectGetWidth(itemView.frame)+_leftRightSpace;
    
        [_inputContainerView addSubview:itemView];
    }
    
    self.recordButton.frame = self.inputTextView.frame;

    [_inputContainerView insertSubview:_recordButton belowSubview:_inputTextView];
}

- (NSInteger)getTextOrRecordInputItemWidth {
    
    int toolBarWidth = self.frame.size.width;
    if (_currentType == BALChatInputToolbarPubType) {
        toolBarWidth = toolBarWidth - CGRectGetMaxX(_typeChangeBtn.frame);
    }
    
    NSArray *items =self.inputTypes;//[_config inputBarItemTypes];
    int itemCount =(int)items.count;
    int allSpaceWidth = (int) _leftRightSpace * (itemCount + 1);
    NSInteger textOrRecordWidth = toolBarWidth - allSpaceWidth - (itemCount-1)*_inputItemWidth;
    
    return textOrRecordWidth;
}

- (UIView *)chatInputBarItemViewOfType:(BALChatInputBarItemType)type{
    if (!_viewAndTypeMap) {
        _viewAndTypeMap = @{
                  @(BALInputBarItemTypeVoice) : self.voiceAndTextChangeBtn,
                  @(BALInputBarItemTypeTextOrVoice)  : self.inputTextView,
                  @(BALInputBarItemTypeEmoticon) : self.emotionButton,
                  @(BALInputBarItemTypeMore)     : self.moreButton,
                  @(BALInputBarItemTypeShortCutText):self.shortCutTextBtn
                  };
    }
    return _viewAndTypeMap[@(type)];
}

#pragma mark -
#pragma mark - Action

- (void)changeChatInputBarType:(UIButton*)sendr {

    NSArray *subViews = self.subviews;
    NSInteger inputIndex = [subViews indexOfObject:_inputContainerView];
    NSInteger menuIndex = [subViews indexOfObject:_menuContainerView];
    
    [self exchangeSubviewAtIndex:inputIndex withSubviewAtIndex:menuIndex];
}


@end
