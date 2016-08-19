//
//  BALInputToolBar.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALChatInputToolBar.h"
#import "BALUtility.h"
#import "GmacsPopover.h"

#define Height_PubItem   40

@interface BALChatInputToolBar ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) GmacsPublicServiceMenu *pubMenu;
@property(nonatomic, strong) UITableView *itemsTableView;
@property(nonatomic, strong) GmacsPopover *popoverView;
@property(nonatomic, strong) NSMutableArray *menuDataSource;


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
        
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
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
        
        _popoverView = [GmacsPopover popover];
        _popoverView.maskType = DXPopoverMaskTypeNone;
        UITableView *blueView = [[UITableView alloc] init];
        blueView.frame = CGRectMake(0, 0, 200, 200);
        blueView.dataSource = self;
        blueView.delegate = self;
        blueView.rowHeight = Height_PubItem;
        if ([blueView respondsToSelector:@selector(setSeparatorInset:)]) {
            [blueView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([blueView respondsToSelector:@selector(setLayoutMargins:)]) {
            [blueView setLayoutMargins:UIEdgeInsetsZero];
        }
        self.itemsTableView = blueView;
        _menuDataSource = [NSMutableArray array];
    }
    
    _shortCutTextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_shortCutTextBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发送常用语_正常"] forState:UIControlStateNormal];
//    _shortCutTextBtn.backgroundColor = [UIColor greenColor];
    
    _voiceAndTextChangeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_voiceAndTextChangeBtn setImage:[BALUtility chatInputImageWithNamed:@"聊天_发声音按钮_正常"] forState:UIControlStateNormal];
//    _voiceAndTextChangeBtn.backgroundColor = [UIColor redColor];
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_recordButton setBackgroundImage:[BALUtility chatInputImageWithNamed:@"声音_输入框_正常状态"] forState:UIControlStateNormal];
    [_recordButton setBackgroundImage:[BALUtility chatInputImageWithNamed:@"声音_输入框_按下状态@2x"] forState:UIControlStateHighlighted];
    [_recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    _recordButton.backgroundColor = [UIColor purpleColor];
    
    _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    _inputTextView.layer.borderWidth = 1;
    _inputTextView.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextView.layer.cornerRadius = 5;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.font = [UIFont systemFontOfSize:15];
    [_inputTextView setExclusiveTouch:YES];
    _inputTextView.enablesReturnKeyAutomatically = YES;
    _inputTextView.returnKeyType = UIReturnKeySend;
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
        _menuContainerView.backgroundColor = BALInput_ChatToolBarBKColor;
        _inputContainerView.frame = _menuContainerView.frame;
        _inputContainerView.backgroundColor = BALInput_ChatToolBarBKColor;
        finalContainer = _menuContainerView;
    }

    
    int originX = (int)_leftRightSpace;
    NSInteger textItemWidth = [self getTextOrRecordInputItemWidth];
    NSInteger normalItemWidth = _inputItemWidth;
    for (NSNumber *item in self.inputTypes) {
        UIView *itemView = [self chatInputBarItemViewOfType:item.integerValue];
        
        if (item.integerValue == BALInputBarItemTypeTextOrVoice) {
            normalItemWidth = textItemWidth;
            itemView.frame = CGRectMake(originX, 2, normalItemWidth, self.frame.size.height - 4*_leftRightSpace);
        }else{
            normalItemWidth = _inputItemWidth;
            itemView.frame = CGRectMake(originX, 2, normalItemWidth, _inputItemWidth);
        }
        
        
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

- (void)setPublicServiceMenus:(GmacsPublicServiceMenu *)pubMenu {
    [self layoutIfNeeded];
    
    for (UIView *subView in [self.menuContainerView subviews]) {
        [subView removeFromSuperview];
    }
    _pubMenu = pubMenu;
    
    CGRect round = self.menuContainerView.bounds;
    CGFloat itemWidth = round.size.width / pubMenu.menuGroups.count;
    CGFloat itemHeight = round.size.height;
    
    for (int i = 0; i < pubMenu.menuGroups.count; i++) {
        UIButton *lable = [[UIButton alloc]
                           initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, itemHeight)];
        GmacsPublicServiceMenuGroup *menuGroup = pubMenu.menuGroups[i];
        [lable setTitle:menuGroup.title forState:UIControlStateNormal];
//        [lable setBackgroundImage:[BALUtility chatInputImageWithNamed:@"声音_输入框_正常状态"]
//                         forState:UIControlStateNormal];
        lable.backgroundColor = [UIColor greenColor];
        lable.titleLabel.font = [UIFont systemFontOfSize:14];
        lable.tag = i;
        lable.layer.borderWidth = 0.5;
        lable.layer.borderColor = [UIColor grayColor].CGColor;
        [lable setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [lable addTarget:self action:@selector(onMenuPushed:) forControlEvents:UIControlEventTouchUpInside];
        lable.backgroundColor = BALInput_ChatToolBarBKColor;
        [self.menuContainerView addSubview:lable];
    }
}

#pragma mark -
#pragma mark - Action

- (void)onMenuPushed:(id)sender {
    UIView *touchedView = sender;
    int tag = (int)touchedView.tag;
    GmacsPublicServiceMenuGroup *group = self.pubMenu.menuGroups[tag];
    
    
    [self.menuDataSource removeAllObjects];
    
    CGFloat itemWidth = 100;
    for (GmacsPublicServiceMenuItem *item in group.menuItems) {
        
        [_menuDataSource addObject:item];
        
        
        CGFloat tmp = [item.text boundingRectWithSize:CGSizeMake(280, Height_PubItem)
                                              options:NSStringDrawingTruncatesLastVisibleLine |
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width +30;
        itemWidth = MAX(tmp, itemWidth);
        
    }
    
    if (_menuDataSource.count) {
        
        CGRect frame = _itemsTableView.frame;
        frame.size.width = itemWidth;
        frame.size.height = Height_PubItem * _menuDataSource.count;
        _itemsTableView.frame = frame;
        
        CGRect controlBarFrame = self.superview.frame;
        CGRect itemFrame = touchedView.frame;
        CGPoint showPoint = CGPointMake(CGRectGetMidX(itemFrame)+CGRectGetMinX(self.menuContainerView.frame), CGRectGetMinY(controlBarFrame));
        [_itemsTableView reloadData];
//        [self.superview.superview addSubview:_itemsTableView];
        [self.popoverView showAtPoint:showPoint popoverPostion:DXPopoverPositionUp withContentView:self.itemsTableView inView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
    } else {
        DebugLog(@"touch menu %d", tag);
    }
}

- (void)changeChatInputBarType:(UIButton*)sendr {

    NSArray *subViews = self.subviews;
    NSInteger inputIndex = [subViews indexOfObject:_inputContainerView];
    NSInteger menuIndex = [subViews indexOfObject:_menuContainerView];
    
    [self exchangeSubviewAtIndex:inputIndex withSubviewAtIndex:menuIndex];
}

#pragma mark -
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.textLabel.text = ((GmacsPublicServiceMenuItem*)self.menuDataSource[indexPath.row]).text;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GmacsPublicServiceMenuItem *selectItem = _menuDataSource[indexPath.row];
    
    [self.popoverView dismiss];
    
    if (!selectItem.url) {
        return;
    }
    
//    GmacsPublicServiceWebViewController *webviewController = [[GmacsPublicServiceWebViewController alloc] init];
//    webviewController.url = selectItem.url;
//    
//    UIViewController *rootVC = [[UIApplication sharedApplication] delegate].window.rootViewController;
//    
//    if ([rootVC isKindOfClass:[UINavigationController class]]) {
//        UINavigationController* navigationController = (UINavigationController *)rootVC;
//        
//        [navigationController pushViewController:webviewController animated:YES];
//    } else if([rootVC isKindOfClass:[UITabBarController class]]){
//        UITabBarController *tabbarVC = (UITabBarController *)rootVC;
//        UINavigationController* navigationController = [tabbarVC.viewControllers objectAtIndex:tabbarVC.selectedIndex];
//        
//        [navigationController pushViewController:webviewController animated:YES];
//    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
}



@end
