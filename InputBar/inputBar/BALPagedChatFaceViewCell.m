//
//  BALPagedChatFaceViewCell.m
//  InputBar
//
//  Created by zhuhao on 16/7/15.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALPagedChatFaceViewCell.h"
#import "BALUtility.h"
#import "BALChatInputDefine.h"

static NSString *CELL_ID = @"Emoji_Reused_CELL_ID";
NSString *kInputEmotionDidTouchedNotification = @"kInputEmotionDidTouchedNotification_BAL";

@interface BALPagedChatFaceViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,strong) NSArray<BALInputEmotionModel*> *emotionArray;
@property(nonatomic,strong) BALInputEmotionLayout* layout;
@end

@implementation BALPagedChatFaceViewCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self addSubview:self.collectionView];
//    }
//    return self;
//}


-(void)setEmotionArray:(NSArray<BALInputEmotionModel *> *)emotionArray withLayout:(BALInputEmotionLayout*)layout{
    _emotionArray = emotionArray;
    _layout = layout;
    
    
//    NSArray* subVs = self.contentView.subviews;
//    [subVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[UIButton class]]) {
//            [obj removeFromSuperview];
//        }
//    }];
//    NSInteger row = layout.rows;
//    NSInteger colume = layout.columes;
//    int i;
////    int originX = 0;
////    int originY = 0;
//    CGFloat originX          = (layout.cellWidth - layout.imageWidth) / 2  + BALInput_EmojiLeftMargin;
//    CGFloat startX = originX;
//    CGFloat originY          = BALInput_EmojiTopMargin;
//    CGFloat startY = originY;
//    for (i = 0; i < row; i++) {
//        int j;
//        for (j = 0; j < colume; j++) {
//            NSInteger index = i*colume+j;
//            if (index >= emotionArray.count) {
//                return;
//            }
//            BALInputEmotionModel *theEmotion = [emotionArray objectAtIndex:index];
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, layout.imageWidth, layout.imageHeight)];
//            btn.tag = index;
//            startX += layout.cellWidth;
//            [btn setImage:[BALUtility emotionImageWithContentOfFile:theEmotion.fileName] forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(emotionDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
//            
////            [btn setBackgroundColor:[UIColor grayColor]];
//            [self.contentView addSubview:btn];
//        }
//        startY += layout.cellHeight+originY;
//        startX = originX;
//    }
    
    if (!self.collectionView.superview) {
        [self addSubview:self.collectionView];
    }
    [self resetCollectionViewLayout];
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewControllerDelegate
//
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emotionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    BALInputEmotionModel *theEmotion = [_emotionArray objectAtIndex:indexPath.row];
    
    BALEmojiItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    [cell setImage:[BALUtility emotionImageWithContentOfFile:theEmotion.fileName]];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BALInputEmotionModel *theEmotion = [_emotionArray objectAtIndex:indexPath.row];
    [self emotionDidTouchedAction:theEmotion];
}

#pragma mark -
#pragma mark - Action 

- (void)emotionDidTouchedAction:(BALInputEmotionModel*)emotionModel {
    
//    NSLog(@"%@",model.showName);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputEmotionDidTouchedNotification object:emotionModel];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemWidth = (self.frame.size.width- BALInput_EmojiTopMargin*2 - _layout.imageWidth *8)/9;
        layout.itemSize = CGSizeMake(_layout.imageWidth, _layout.imageHeight);
        layout.minimumInteritemSpacing = itemWidth;
        layout.minimumLineSpacing =6 ;
        [layout setSectionInset:UIEdgeInsetsMake(BALInput_EmojiTopMargin, BALInput_EmojiLeftMargin, BALInput_EmojiTopMargin, BALInput_EmojiLeftMargin)];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = BALInput_ChatToolBarBKColor;
        [_collectionView registerClass:[BALEmojiItemCell class] forCellWithReuseIdentifier:CELL_ID];
    }
    
    return _collectionView;
}

- (void)resetCollectionViewLayout{
    
    int columeCount =  _layout.columes;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    CGFloat itemWidth = (self.frame.size.width- BALInput_EmojiTopMargin*2 - _layout.cellWidth *columeCount)/(columeCount+1);
    layout.itemSize = CGSizeMake(_layout.cellWidth, _layout.cellHeight);
    layout.minimumInteritemSpacing = itemWidth;
    
}

@end


/**
 *  <#Description#>
 */
@implementation BALEmojiItemCell

- (void)setImage:(UIImage *)image {
    [self.emojiBtn setImage:image forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.emojiBtn.center = self.contentView.center;
}

-(UIButton *)emojiBtn {
    if (!_emojiBtn) {
        int space = 5;
        _emojiBtn =  [[UIButton alloc] initWithFrame:self.bounds];
        _emojiBtn.userInteractionEnabled = NO;
//        self.backgroundColor = [UIColor orangeColor];
//        [_emojiBtn addTarget:self action:@selector(emotionDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _emojiBtn.center = self.center;
        [self.contentView addSubview:_emojiBtn];
    }
    
    return _emojiBtn;
}

@end
