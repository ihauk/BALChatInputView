//
//  BALInputMorePluginContainerVIew.m
//  InputBar
//
//  Created by zhuhao on 16/6/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputMorePluginContainerView.h"
#import "BALInputPluginItemModel.h"

@interface BALInputMorePluginContainerView ()

@property(nonatomic,strong) NSMutableArray *pluginItems;

@end

@implementation BALInputMorePluginContainerView

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
    
    _pagedScrollView = [[BALPagedScrollView alloc] initWithSuportType:BALPagedSupportTypePlugin];
    [self addSubview:_pagedScrollView];
    [self loadPluginItems];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    int height = self.frame.size.height;
    int width = self.frame.size.width;
    
    _pagedScrollView.frame = CGRectMake(0, 0, width, height);
}

#pragma mark -
#pragma mark - DS

- (void)loadPluginItems {
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"Input.bundle"];
    NSString *configPath = [bundlePath stringByAppendingPathComponent:@"ChatInput.plist"];
    NSDictionary *configDic = [[NSDictionary alloc]initWithContentsOfFile:configPath];
    NSArray *dicArr = [configDic objectForKey:@"PluginItemDS"];
    _pluginItems = [NSMutableArray array];
    [dicArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BALInputPluginItemModel *tModel = [BALInputPluginItemModel itemWithDic:obj];
        [_pluginItems addObject:tModel];
    }];
    
    [_pagedScrollView setPluginItems:_pluginItems];
    
}

@end
