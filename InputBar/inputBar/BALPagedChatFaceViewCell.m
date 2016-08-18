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


-(void)setEmotionArray:(NSArray<BALInputEmotionModel *> *)emotionArray withLayout:(BALInputEmotionLayout*)layout{
    _emotionArray = emotionArray;
    _layout = layout;
    
    
    NSArray* subVs = self.contentView.subviews;
    [subVs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj removeFromSuperview];
        }
    }];
    NSInteger row = layout.rows;
    NSInteger colume = layout.columes;
    int i;
//    int originX = 0;
//    int originY = 0;
    CGFloat originX          = (layout.cellWidth - layout.imageWidth) / 2  + BALInput_EmojiLeftMargin;
    CGFloat startX = originX;
    CGFloat originY          = BALInput_EmojiTopMargin;
    CGFloat startY = originY;
    for (i = 0; i < row; i++) {
        int j;
        for (j = 0; j < colume; j++) {
            NSInteger index = i*colume+j;
            if (index >= emotionArray.count) {
                return;
            }
            BALInputEmotionModel *theEmotion = [emotionArray objectAtIndex:index];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(startX, startY, layout.imageWidth, layout.imageHeight)];
            btn.tag = index;
            startX += layout.cellWidth;
            [btn setImage:[BALUtility emotionImageWithContentOfFile:theEmotion.fileName] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(emotionDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
            
//            [btn setBackgroundColor:[UIColor grayColor]];
            [self.contentView addSubview:btn];
        }
        startY += layout.cellHeight+originY;
        startX = originX;
    }
    
    
    //[self addSubview:self.collectionView];
}


#pragma mark - UICollectionViewControllerDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emotionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    BALInputEmotionModel *theEmotion = [_emotionArray objectAtIndex:indexPath.row];
    
    BALEmojiItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_ID forIndexPath:indexPath];
    
    [cell setImage:[BALUtility emotionImageWithContentOfFile:theEmotion.fileName]];
    
    
    return cell;
}


#pragma mark -
#pragma mark - Action 

- (void)emotionDidTouchedAction:(UIButton*)sender {
    
    BALInputEmotionModel*model = _emotionArray[sender.tag];
//    NSLog(@"%@",model.showName);
    [[NSNotificationCenter defaultCenter] postNotificationName:kInputEmotionDidTouchedNotification object:model];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        CGFloat itemWidth = self.frame.size.width - _layout.imageWidth *8;
        layout.itemSize = CGSizeMake(_layout.imageWidth, _layout.imageHeight);
        layout.minimumInteritemSpacing = 6;
        layout.minimumLineSpacing =6 ;
        [layout setSectionInset:UIEdgeInsetsMake(BALInput_EmojiTopMargin, BALInput_EmojiLeftMargin, BALInput_EmojiTopMargin, BALInput_EmojiLeftMargin)];
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[BALEmojiItemCell class] forCellWithReuseIdentifier:CELL_ID];
    }
    
    return _collectionView;
}
@end


/**
 *  <#Description#>
 */
@implementation BALEmojiItemCell

- (void)setImage:(UIImage *)image {
    [self.emojiBtn setImage:image forState:UIControlStateNormal];
}

-(UIButton *)emojiBtn {
    if (!_emojiBtn) {
        int space = 5;
        _emojiBtn =  [[UIButton alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor orangeColor];
        [_emojiBtn addTarget:self action:@selector(emotionDidTouchedAction:) forControlEvents:UIControlEventTouchUpInside];
        
        _emojiBtn.center = self.center;
        [self.contentView addSubview:_emojiBtn];
    }
    
    return _emojiBtn;
}

@end
