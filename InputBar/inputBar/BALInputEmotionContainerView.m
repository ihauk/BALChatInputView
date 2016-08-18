//
//  BALInputEmotionContainerView.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputEmotionContainerView.h"
#import "BALInputEmotionTabScrollView.h"
#import "BALPagedScrollView.h"

static const NSInteger kBottomCateTabHeight = 40;

@interface BALInputEmotionContainerView ()<BALInputEmotionTabScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *emotionCateDS;

@end

@implementation BALInputEmotionContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark -
#pragma mark - init

- (void)initSubviews {
    
    _cateTabView = [[BALInputEmotionTabScrollView alloc] initWithFrame:CGRectZero];
    _cateTabView.tabDelegate = self;
    [self addSubview:_cateTabView];
    
    _pagedScrollView = [[BALPagedScrollView alloc] initWithSuportType:BALPagedSupportTypeEmotion];
    [self addSubview:_pagedScrollView];
    //[self loadEmotionConfig];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self loadEmotionConfig];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    int height = self.frame.size.height;
    int width = self.frame.size.width;
    
    _cateTabView.frame = CGRectMake(0, height-kBottomCateTabHeight, width, kBottomCateTabHeight);
    _pagedScrollView.frame = CGRectMake(0, 0, width, height-kBottomCateTabHeight);
}

#pragma mark -
#pragma mark - config

- (void)loadEmotionConfig{
    
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Input.bundle"];
    NSString *configPath = [bundlePath stringByAppendingPathComponent:@"ChatInput.plist"];
    NSDictionary *configDic = [[NSDictionary alloc]initWithContentsOfFile:configPath];
    NSArray *emojiDS = [configDic objectForKey:@"EmotionCateDS"];
    NSLog(@"%@",emojiDS);
    
    _emotionCateDS = [NSMutableArray array];
    
    [emojiDS enumerateObjectsUsingBlock:^(NSString*  _Nonnull relePath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *emotionPath = [[bundlePath stringByAppendingPathComponent:@"Emotion"]stringByAppendingPathComponent:relePath] ;
        NSString *filePath = [emotionPath stringByAppendingPathComponent:@"emotion.plist"];
        NSDictionary *emotionDic = [[NSArray alloc ]initWithContentsOfFile:filePath][0];
        NSAssert(emotionDic != nil, @"plist 配置的emotion与bundle的目录不一致");
        
        BALInputEmotionCateModel *cateModel = [[BALInputEmotionCateModel alloc] init];
        cateModel.cateName = emotionDic[@"info"][@"title"];
        cateModel.iconName = [emotionPath stringByAppendingPathComponent:emotionDic[@"info"][@"normal"] ];
        cateModel.highlightIconName = [emotionPath stringByAppendingPathComponent:emotionDic[@"info"][@"pressed"]];
        if (emotionDic[@"info"][@"isEmoji"]) {
            cateModel.layout = [[BALInputEmotionLayout alloc] initEmojiLayout:self.frame.size.width];
        } else {
            cateModel.layout = [[BALInputEmotionLayout alloc] initCharletLayout:self.frame.size.width];
        }
        cateModel.emotionsArray = [NSMutableArray array];
        
        [emotionDic[@"data"] enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BALInputEmotionModel *emotionModel = [[BALInputEmotionModel alloc] init];
            //emotionModel.emoticonID = obj[@"id"];
            emotionModel.fileName = [emotionPath stringByAppendingPathComponent:obj[@"file"]];
            emotionModel.showName = obj[@"tag"];
            emotionModel.isEmoji = emotionDic[@"info"][@"isEmoji"];
            [cateModel.emotionsArray addObject:emotionModel];
            
        }];
        [_emotionCateDS addObject:cateModel];
        
    }];
    
    [_cateTabView setEmotionCates:_emotionCateDS];
    
}

#pragma mark -
#pragma mark - BALInputEmotionTabScrollViewDelegate

-(void)tabView:(BALInputEmotionTabScrollView *)tabView didSelectTabIndex:(NSInteger)index {
    
    _pagedScrollView.emotionCateModel = _emotionCateDS[index];
}


@end
