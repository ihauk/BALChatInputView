//
//  BALChatInputView.m
//  InputBar
//
//  Created by zhuhao on 16/6/21.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALChatInputView.h"
#import "BALInputEmotionContainerView.h"
#import "BALInputMorePluginContainerView.h"
#import "BALClassManager.h"
#import "BALUtility.h"
#import "BALInputShortcutTextContainerView.h"
#import "BALInputEmotionCateModel.h"


@interface BALChatInputView ()<UITextViewDelegate>

@property(nonatomic,weak) id<BALChatToolBarConfig> inputConfig;
@property(nonatomic,assign) NSInteger inputBottomViewHeight;
@property(nonatomic,strong) NSDictionary *containerViewAndTypeMap;

//@property(nonatomic,strong) NSMutableArray *emotionCateDS;

@end

@implementation BALChatInputView

-(instancetype)initWithFrame:(CGRect)frame
                        type:(BALChatInputToolbarType)type {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(231, 231, 231);
        self.inputStatus = KChatInputViewDefaultStatus;
//        self.emotionCateDS = [NSMutableArray array];
        
        [self setupChatInputViewWithType:type ];
        [self findChatInputToolBarConfig];
//        [self loadEmotionConfig];
        [self registerNotifications];
        [self setupUIEvents];
        

    }
    
    return self;
}

-(void)dealloc {
    
    [self removeNotifications];
}

#pragma mark -
#pragma mark - init

- (void)setupChatInputViewWithType:(BALChatInputToolbarType)type {
    
    _inputBottomViewHeight = 0;
    
    // toobar
    _inputToolBar = [[BALChatInputToolBar alloc] initWithToolBarType:type];
    _inputToolBar.frame = self.bounds;
    [self addSubview:_inputToolBar];
    
    _emotionContainerView = [[BALInputEmotionContainerView alloc]init];
    [self addSubview:_emotionContainerView];
    
    _moreContainerView = [[BALInputMorePluginContainerView alloc] init];
    [self addSubview:_moreContainerView];
 
    _shortcutTextContainerView = [[BALInputShortcutTextContainerView alloc] init];
    [self addSubview:_shortcutTextContainerView];
}

- (void)setChatInputConfig:(id<BALChatToolBarConfig>)config {
    self.inputConfig = config;
    [_inputToolBar setCharInputBarItemTypes:[_inputConfig inputBarItemTypes]];
}


- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEmotionTouchedAction:) name:kInputEmotionDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPluginTouchedAction:) name:kInputPluginDidTouchedNotification object:nil];
    
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputEmotionDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputPluginDidTouchedNotification object:nil];
}

- (void)setupUIEvents {
    
    _inputToolBar.inputTextView.delegate = self;
    
    [_inputToolBar.voiceAndTextChangeBtn addTarget:self action:@selector(voiceAndTextBtnTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.emotionButton addTarget:self action:@selector(emotionButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.moreButton addTarget:self action:@selector(moreButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.shortCutTextBtn addTarget:self action:@selector(shortcutTextButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _emotionContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    _moreContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    _shortcutTextContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    
    _emotionContainerView.backgroundColor = [UIColor orangeColor];
    _moreContainerView.backgroundColor = [UIColor purpleColor];
    _shortcutTextContainerView.backgroundColor = [UIColor greenColor];
    
}

- (void)keyboardWillChangeFrame:(NSNotification*)notification{
    
    if (!self.window) {
        return;//如果当前vc不是堆栈的top vc，则不需要监听
    }
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame   = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = (UIViewAnimationCurve)[userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    void(^animations)() = ^{
        [self willShowKeyboardFromFrame:beginFrame toFrame:endFrame];
    };
    [UIView animateWithDuration:duration delay:0.0f options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState) animations:animations completion:nil];
}

- (void)willShowKeyboardFromFrame:(CGRect)beginFrame toFrame:(CGRect)toFrame
{
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    BOOL ios7 = ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8.0);
    //IOS7的横屏UIDevice的宽高不会发生改变，需要手动去调整
    if (ios7 && (orientation == UIDeviceOrientationLandscapeLeft
                 || orientation == UIDeviceOrientationLandscapeRight)) {
        toFrame.origin.y -= 0;
        if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.width) {
            [self willShowBottomHeight:0];
        }else{
            [self willShowBottomHeight:toFrame.size.width];
        }
    }else{
        toFrame.origin.y -= 0;
        if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.height) {
            [self willShowBottomHeight:0];
        }else{
            [self willShowBottomHeight:toFrame.size.height];
        }
    }
}


- (void)willShowBottomHeight:(CGFloat)bottomHeight
{
    CGRect fromFrame = self.frame;
    CGFloat toHeight = self.inputToolBar.frame.size.height + bottomHeight;
    CGRect toFrame = CGRectMake(fromFrame.origin.x, fromFrame.origin.y + (fromFrame.size.height - toHeight), fromFrame.size.width, toHeight);
    
    if(bottomHeight == 0 && self.frame.size.height == self.inputToolBar.frame.size.height)
    {
        return;
    }
    self.frame = toFrame;
    
//    if (bottomHeight == 0) {
//        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(hideInputView)]) {
//            [self.inputDelegate hideInputView];
//        }
//    } else
//    {
//        if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(showInputView)]) {
//            [self.inputDelegate showInputView];
//        }
//    }
//    if (self.inputDelegate && [self.inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
//        [self.inputDelegate inputViewSizeToHeight:toHeight showInputView:!(bottomHeight==0)];
//    }
}

#pragma mark -
#pragma mark - notification 表情，plugin 的点击

- (void)didEmotionTouchedAction:(NSNotification*)notification {
    BALInputEmotionModel *model = notification.object;
    NSLog(@"---%@",model.showName);
}

- (void)didPluginTouchedAction:(NSNotification*)notification {
    BALInputPluginItemModel *model = notification.object;
    NSLog(@"---%@",model.title);
}


#pragma mark -
#pragma mark - Action 

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.inputStatus = KChatInputViewTextStatus;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.inputStatus = KChatInputViewDefaultStatus;
}

- (void)voiceAndTextBtnTouchedAction:(UIButton*)sender {
    NSArray *subViews = _inputToolBar.inputContainerView.subviews;
    NSInteger textIndex = [subViews indexOfObject:_inputToolBar.inputTextView];
    NSInteger recordIndex = [subViews indexOfObject:_inputToolBar.recordButton];
    
    [_inputToolBar.inputContainerView exchangeSubviewAtIndex:textIndex withSubviewAtIndex:recordIndex];
    
    if(self.inputStatus != KChatInputViewRecordStatus){
        
        [self showChatInputViewWithDefaultStatus];
        self.inputStatus = KChatInputViewRecordStatus;
    }else{
        self.inputStatus = KChatInputViewTextStatus;
        [_inputToolBar.inputTextView becomeFirstResponder];
        
    }
}

- (void)emotionButtonTouchedAction:(UIButton*)sender {
    
    if (self.inputStatus != KChatInputViewEmotionStatus) {
        self.inputStatus = KChatInputViewEmotionStatus;
        _inputBottomViewHeight = [self.inputConfig bottomInputViewHeight];
        [self bringSubviewToFront:_emotionContainerView];
//        [_moreContainerView setHidden:YES];
//        [_emotionContainerView setHidden:NO];
        [self showContainerViewWithInputStatus:self.inputStatus];
        if ([self.inputToolBar.inputTextView isFirstResponder]) {
            [self.inputToolBar.inputTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self willShowBottomHeight:_inputBottomViewHeight];
        }];
    }else
    {
        [self showChatInputViewWithDefaultStatus];
    }
}

- (void)moreButtonTouchedAction:(UIButton*)sender {
    
    if (self.inputStatus != KChatInputViewMorePluginStatus) {
        self.inputStatus = KChatInputViewMorePluginStatus;
        _inputBottomViewHeight = [self.inputConfig bottomInputViewHeight];
        [self bringSubviewToFront:_moreContainerView];
//        [_moreContainerView setHidden:NO];
//        [_emotionContainerView setHidden:YES];
        [self showContainerViewWithInputStatus:self.inputStatus];
        if ([self.inputToolBar.inputTextView isFirstResponder]) {
            [self.inputToolBar.inputTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self willShowBottomHeight:_inputBottomViewHeight];
        }];
    }else
    {
        [self showChatInputViewWithDefaultStatus];
    }
}

- (void)shortcutTextButtonTouchedAction:(UIButton*)sender {
    
    if (self.inputStatus != KChatInputViewShortcutTextStatus) {
        self.inputStatus = KChatInputViewShortcutTextStatus;
        _inputBottomViewHeight = [self.inputConfig bottomInputViewHeight];
        
        [self bringSubviewToFront:_shortcutTextContainerView];
        [self showContainerViewWithInputStatus:self.inputStatus];
        
        if ([self.inputToolBar.inputTextView isFirstResponder]) {
            [self.inputToolBar.inputTextView resignFirstResponder];
        }
        [UIView animateWithDuration:0.25 animations:^{
            [self willShowBottomHeight:_inputBottomViewHeight];
        }];
    }else
    {
        [self showChatInputViewWithDefaultStatus];
    }
}

- (void)showChatInputViewWithDefaultStatus {
    _inputBottomViewHeight = 0;
    _inputStatus = KChatInputViewDefaultStatus;
    if (_inputToolBar.inputTextView.isFirstResponder) {
        [_inputToolBar.inputTextView resignFirstResponder];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self willShowBottomHeight:_inputBottomViewHeight];
    }];
}


#pragma mark -
#pragma mark - config

- (void)findChatInputToolBarConfig {
    
    static id  config;
    [BALClassManager scanClassForKey:kBALChatToolBarConfig fetchblock:^(__unsafe_unretained Class aclass, id userInfo) {
        
        config = [[aclass alloc]init];
        NSString *errorMsg = [NSString stringWithFormat:@"注册的 %@ 类 没有实现 BALChatToolBarConfig 协议",NSStringFromClass(aclass)];
        NSAssert([config conformsToProtocol:@protocol(BALChatToolBarConfig)],errorMsg);
        
        [self setChatInputConfig:config];
        
    }];
}


- (void)showContainerViewWithInputStatus:(BALChatInputViewStatus)type {

    [self.containerViewAndTypeMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIView *containerView = obj;
        NSNumber *showType = key;
        if (showType.intValue == type) {
            containerView.hidden = NO;
        }else{
            containerView.hidden = YES;
        }
    }];
    
}

-(NSDictionary *)containerViewAndTypeMap {
    if (!_containerViewAndTypeMap) {
        _containerViewAndTypeMap = @{
                                     @(KChatInputViewEmotionStatus) : self.emotionContainerView,
                                     @(KChatInputViewMorePluginStatus)     : self.moreContainerView,
                                     @(KChatInputViewShortcutTextStatus):self.shortcutTextContainerView
                                     };
    }
    
    return _containerViewAndTypeMap;
}

@end
