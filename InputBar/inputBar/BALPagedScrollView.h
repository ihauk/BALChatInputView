//
//  BALScrollPagedView.h
//  InputBar
//
//  Created by zhuhao on 16/7/15.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BALInputEmotionCateModel.h"
#import "BALPagedChatFaceViewCell.h"
#import "BALPagedPluginBoardViewCell.h"
@class BALPagedScrollView;

typedef NS_ENUM(NSUInteger, BALPagedSupportType) {
    BALPagedSupportTypeEmotion,
    BALPagedSupportTypePlugin
};

@protocol BALPagedScrollViewDataSource <NSObject>
- (NSInteger)numberOfPages: (BALPagedScrollView *)pageView;
- (UIView *)pageView: (BALPagedScrollView *)pageView viewInPage: (NSInteger)index;
@end

@protocol BALPagedScrollViewDelegate <NSObject>
@optional
- (void)pageViewScrollEnd: (BALPagedScrollView *)pageView
             currentIndex: (NSInteger)index
               totolPages: (NSInteger)pages;

- (void)pageViewDidScroll: (BALPagedScrollView *)pageView;
- (BOOL)needScrollAnimation;
@end

@interface BALPagedScrollView : UIView

@property(nonatomic,strong) UICollectionView *scrollPagedView;
@property(nonatomic,strong) BALInputEmotionCateModel *emotionCateModel;
@property(nonatomic,strong) NSArray *pluginItems;
@property(nonatomic,weak)   id<BALPagedScrollViewDelegate>    pageViewDelegate;

- (instancetype)initWithSuportType:(BALPagedSupportType)supportType;

@end
