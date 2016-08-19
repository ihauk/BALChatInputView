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
#import "GmacsVoiceCaptureControl.h"
#import "BALInputEmotionTabScrollView.h"


@interface BALChatInputView ()<UITextViewDelegate,GmacsVoiceCaptureControlDelegate>

@property(nonatomic,weak) id<BALChatToolBarConfig> inputConfig;
@property(nonatomic,assign) NSInteger inputBottomViewHeight;
@property(nonatomic,strong) NSDictionary *containerViewAndTypeMap;
@property(nonatomic,assign) CGFloat inputTextViewOlderHeight;
@property (nonatomic, strong) GmacsVoiceCaptureControl* voiceCaptureControl;
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
        
        _inputTextViewOlderHeight = [_inputConfig topToolbarInputViewHeight];
//        self.backgroundColor = [UIColor orangeColor];
//        self.inputToolBar.backgroundColor = [UIColor greenColor];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShortcutTextTouchedAction:) name:kInputShortcutTextDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEmotionSenderButtonTouchedAction:) name:kInputEmotionSendButtonDidTouchedNotification object:nil];
    
}

- (void)removeNotifications {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputEmotionDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputPluginDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputShortcutTextDidTouchedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kInputEmotionSendButtonDidTouchedNotification object:nil];
}

- (void)setupUIEvents {
    
    _inputToolBar.inputTextView.delegate = self;
    
    [_inputToolBar.voiceAndTextChangeBtn addTarget:self action:@selector(voiceAndTextChangeBtnTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.emotionButton addTarget:self action:@selector(emotionButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.moreButton addTarget:self action:@selector(moreButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_inputToolBar.shortCutTextBtn addTarget:self action:@selector(shortcutTextButtonTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchDown:)
            forControlEvents:UIControlEventTouchDown];
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchUpInside:)
            forControlEvents:UIControlEventTouchUpInside];
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchUpOutside:)
            forControlEvents:UIControlEventTouchUpOutside];
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchDragExit:)
            forControlEvents:UIControlEventTouchDragExit];
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchDragEnter:)
            forControlEvents:UIControlEventTouchDragEnter];
    [_inputToolBar.recordButton addTarget:self
                      action:@selector(voiceRecordButtonTouchCancel:)
            forControlEvents:UIControlEventTouchCancel];
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
        toFrame.origin.y -= _inputBottomViewHeight;
        if (toFrame.origin.y == [[UIScreen mainScreen] bounds].size.width) {
            [self willShowBottomHeight:0];
        }else{
            [self willShowBottomHeight:toFrame.size.width];
        }
    }else{
        toFrame.origin.y -= _inputBottomViewHeight;
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
#pragma mark - notification 表情，plugin 的点击,

- (void)didEmotionTouchedAction:(NSNotification*)notification {
    BALInputEmotionModel *model = notification.object;
    if (model.isEmoji) {
        
        [self.inputToolBar.inputTextView insertText:model.showName];
    }else {
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didSelectEmotionImage:)]) {
            [_delegate chatInputView:self didSelectEmotionImage:model];
        }
    }
    
}

- (void)didPluginTouchedAction:(NSNotification*)notification {
    BALInputPluginItemModel *model = notification.object;
    NSLog(@"---%@---%@",model.title,model.actionTag);
    NSInteger actionTag = model.actionTag.integerValue;
    NSInteger photoTag = [_inputConfig chatInputViewOpenPhotoAlbumActionTag];
    NSInteger cameraTag = [_inputConfig chatInputViewOpenCameraActionTag];
    NSInteger locationTag = [_inputConfig chatInputViewOpenLocationActionTag];
    
    if (actionTag == photoTag) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didSelectOpenPhotoAlbumPluginItem:)]) {
            [_delegate chatInputView:self didSelectOpenPhotoAlbumPluginItem:actionTag];
        }
    }else if (actionTag == cameraTag){
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didSelectOpenCameraPluginItem:)]) {
            [_delegate chatInputView:self didSelectOpenPhotoAlbumPluginItem:actionTag];
        }
    }else if (actionTag == locationTag) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didSelectOpenLocationPluginItem:)]) {
            [_delegate chatInputView:self didSelectOpenLocationPluginItem:actionTag];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didSelectCustomPluginItem:)]) {
            [_delegate chatInputView:self didSelectCustomPluginItem:actionTag];
        }
    }
}

- (void)didShortcutTextTouchedAction:(NSNotification*)notification {

    NSString *text = notification.object;

    if (self.delegate && [self.delegate respondsToSelector:@selector(chatInputView:didSelectShortutText:)]) {
        [self.delegate chatInputView:self didSelectShortutText:text];
    }
}

- (void)didKeyboardReturnKeyTouchedAction:(UITextView*)textView text:(NSString*)text {
    NSLog(@"---%@----",text);
    
    
    NSString *_formatString =
    [text stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceCharacterSet]];
    if (0 == [_formatString length]) {
        
        UIAlertView *notAllowSendSpace = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:@"whiteSpaceMessage"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
        [notAllowSendSpace show];
    } else {
        [self.delegate chatInputView:self didTriggerSendAction:[text copy]  ];
    }
    
    _inputToolBar.inputTextView.text = @"";
    [_inputToolBar.inputTextView layoutIfNeeded];
     [self inputTextViewToHeight:[self getTextViewContentH:_inputToolBar.inputTextView]];
}

- (void)didEmotionSenderButtonTouchedAction:(NSNotification*)nofitication {
    NSString *text = _inputToolBar.inputTextView.text;
    
    [self didKeyboardReturnKeyTouchedAction:_inputToolBar.inputTextView text:text];
}

#pragma mark -
#pragma mark - Voice

- (void)voiceRecordButtonTouchDown:(UIButton *)sender {
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender event:UIControlEventTouchDown];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchDown];
    NSLog(@"voiceRecordButtonTouchDown");
}
- (void)voiceRecordButtonTouchUpInside:(UIButton *)sender {
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender
//                                     event:UIControlEventTouchUpInside];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchUpInside];
    NSLog(@"voiceRecordButtonTouchUpInside");
}

- (void)voiceRecordButtonTouchCancel:(UIButton *)sender {
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender event:UIControlEventTouchCancel];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchCancel];
    NSLog(@"voiceRecordButtonTouchCancel");
}
- (void)voiceRecordButtonTouchDragExit:(UIButton *)sender {
    
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender
//                                     event:UIControlEventTouchDragExit];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchDragExit];
    NSLog(@"voiceRecordButtonTouchDragExit");
}
- (void)voiceRecordButtonTouchDragEnter:(UIButton *)sender {
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender
//                                     event:UIControlEventTouchDragEnter];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchDragEnter];
    NSLog(@"voiceRecordButtonTouchDragEnter");
}
- (void)voiceRecordButtonTouchUpOutside:(UIButton *)sender {
//    if ([self.delegate
//         respondsToSelector:@selector(didTouchRecordButon:event:)]) {
//        [self.delegate didTouchRecordButon:sender
//                                     event:UIControlEventTouchUpOutside];
//    }
    [self didTouchRecordButon:sender event:UIControlEventTouchUpOutside];
    NSLog(@"voiceRecordButtonTouchUpOutside");
}


- (void)didTouchRecordButon:(UIButton*)sender event:(UIControlEvents)event
{
    switch (event) {
        case UIControlEventTouchDown: {
            [self onBeginRecordEvent];
        } break;
        case UIControlEventTouchUpInside: {
            [self onEndRecordEvent];
        } break;
        case UIControlEventTouchDragExit: {
            [self dragExitRecordEvent];
        } break;
        case UIControlEventTouchUpOutside: {
            [self onCancelRecordEvent];
        } break;
        default:
            break;
    }
}


//语音消息开始录音
- (void)onBeginRecordEvent
{
    //TODO: 统一 UIScreen 数据
    CGFloat width =  [UIScreen mainScreen].bounds.size.width;
    CGFloat height =  [UIScreen mainScreen].bounds.size.height;
    
    self.voiceCaptureControl = [[GmacsVoiceCaptureControl alloc] initWithFrame:CGRectMake(0, 20, width, height)];
    self.voiceCaptureControl.delegate = self;
    [self.voiceCaptureControl startRecord];
}

//语音消息录音结束
- (void)onEndRecordEvent
{
    NSData* recordData = [self.voiceCaptureControl stopRecord];
    if (self.voiceCaptureControl.duration >= 1.0f && nil != recordData) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didEndRecordAudio:)]) {
            [_delegate chatInputView:self didEndRecordAudio:recordData];
        }
    }
}

//滑出显示
- (void)dragExitRecordEvent
{
    [self.voiceCaptureControl showCancelView];
}
- (void)onCancelRecordEvent
{
    [self.voiceCaptureControl cancelRecord];
    
    if (_delegate && [_delegate respondsToSelector:@selector(chatInputView:didCancleRecordAudio:)]) {
        [_delegate chatInputView:self didCancleRecordAudio:nil];
    }
}


#pragma mark -
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.inputStatus = KChatInputViewTextStatus;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.inputStatus = KChatInputViewDefaultStatus;
}

-(void)textViewDidChange:(UITextView *)textView {
    
    [self inputTextViewToHeight:[self getTextViewContentH:textView]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        NSString *_needToSendText = textView.text;
        [self didKeyboardReturnKeyTouchedAction:textView text:_needToSendText];

        return NO;
    }
    
    return YES;

}

#pragma mark -
#pragma mark - Action 



- (void)voiceAndTextChangeBtnTouchedAction:(UIButton*)sender {
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
    
    [self updateInputChannelImage:self.inputStatus];
}

- (void)emotionButtonTouchedAction:(UIButton*)sender {
    
    if (self.inputStatus != KChatInputViewEmotionStatus) {
        self.inputStatus = KChatInputViewEmotionStatus;
        _inputBottomViewHeight = [self.inputConfig bottomInputViewHeight];
        [self bringSubviewToFront:_emotionContainerView];

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
    
    [self updateInputChannelImage:self.inputStatus];
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
    
    [self updateInputChannelImage:self.inputStatus];
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
    
    [self updateInputChannelImage:self.inputStatus];
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

- (void)updateInputChannelImage:(BALChatInputViewStatus)currentStatus {
  
    if (currentStatus == KChatInputViewRecordStatus) {
        [_inputToolBar.voiceAndTextChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_显示键盘按钮_正常"] forState:UIControlStateNormal];
    }
    
    else if (currentStatus == KChatInputViewTextStatus) {
        
        [_inputToolBar.voiceAndTextChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发声音按钮_正常"] forState:UIControlStateNormal];
    }
    
    else {
        [_inputToolBar.voiceAndTextChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发声音按钮_正常"] forState:UIControlStateNormal];
        NSArray *subViews = _inputToolBar.inputContainerView.subviews;
        NSInteger textIndex = [subViews indexOfObject:_inputToolBar.inputTextView];
        NSInteger recordIndex = [subViews indexOfObject:_inputToolBar.recordButton];

        if (textIndex < recordIndex) {
            [_inputToolBar.inputContainerView exchangeSubviewAtIndex:textIndex withSubviewAtIndex:recordIndex];
        }
    }
    
}


- (void)inputTextViewToHeight:(CGFloat)toHeight
{
    toHeight = MAX([_inputConfig topToolbarInputViewHeight], toHeight);
    toHeight = MIN([_inputConfig bottomInputViewHeight], toHeight);
    
    if (toHeight != _inputTextViewOlderHeight)
    {
        CGFloat changeHeight = toHeight - _inputTextViewOlderHeight;
        
//
        CGRect rect = self.frame;
        rect.size.height += changeHeight;
        rect.origin.y -= changeHeight;
        self.frame = rect;
        
        rect = self.inputToolBar.frame;
        rect.size.height += changeHeight;
        rect.origin.y = 0;
        [self updateInputTopViewFrame:rect];
        
        if (self.inputToolBar.inputTextView.text.length) {
            [self.inputToolBar.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputToolBar.inputTextView.contentSize.height - self.inputToolBar.inputTextView.frame.size.height)) animated:YES];
        }
        _inputTextViewOlderHeight = toHeight;
        
//        if (_inputDelegate && [_inputDelegate respondsToSelector:@selector(inputViewSizeToHeight:showInputView:)]) {
//            [_inputDelegate inputViewSizeToHeight:self.frame.size.height showInputView:YES];
//        }
    }
}

- (void)updateInputTopViewFrame:(CGRect)rect
{
    self.inputToolBar.frame             = rect;
    [self.inputToolBar layoutIfNeeded];
    
    _emotionContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    _moreContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    _shortcutTextContainerView.frame = CGRectMake(0, CGRectGetMaxY(_inputToolBar.frame), self.frame.size.width, [_inputConfig bottomInputViewHeight]);
    
//    self.moreContainer.nim_top     = self.toolBar.nim_bottom;
//    self.emoticonContainer.nim_top = self.toolBar.nim_bottom;
}

- (CGFloat)getTextViewContentH:(UITextView *)textView
{
    return isAboveIOS8 ? textView.contentSize.height : ceilf([textView sizeThatFits:textView.frame.size].height);
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

- (void)layoutChatInputViewWithStatus:(BALChatInputViewStatus )status {
    switch (status) {
        case KChatInputViewDefaultStatus:
            [self showChatInputViewWithDefaultStatus];
            break;
            
        default:
            break;
    }
}

- (void)configPublicServiceMenu:(GmacsPublicServiceMenu *)pubMenu {
    [_inputToolBar setPublicServiceMenus:pubMenu];
}

@end
