//
//  BALScrollPagedView.m
//  InputBar
//
//  Created by zhuhao on 16/7/15.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALPagedScrollView.h"
#import "BALPagedChatFaceViewCell.h"
#import "BALPagedPluginBoardViewCell.h"


static NSString *PageEmotionViewIdentifier = @"BAL_PageViewIdentifier_Emotion";
static NSString *PagePluginBoardViewIdentifier = @"BAL_PageViewIdentifier_PluginBoard";

@interface BALPagedScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BALPagedViewCellDelegate>

@property(nonatomic,assign) BALPagedSupportType supportType;
@property(nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BALPagedScrollView

- (instancetype)initWithSuportType:(BALPagedSupportType)supportType {
    self = [super init];
    if (self) {
        _supportType = supportType;
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    [self addSubview:self.scrollPagedView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollPagedView.frame = self.bounds;
    ((UICollectionViewFlowLayout*)self.scrollPagedView.collectionViewLayout).itemSize = self.bounds.size;
}

#pragma mark -
#pragma mark - nitification




#pragma mark -
#pragma mark - getter view 

- (UICollectionView *)scrollPagedView{
    if (!_scrollPagedView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.frame.size;
        [layout setMinimumInteritemSpacing:0];
        [layout setMinimumLineSpacing:0];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        _scrollPagedView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _scrollPagedView.backgroundColor = [UIColor whiteColor];
        _scrollPagedView.pagingEnabled = YES;
        _scrollPagedView.delegate = self;
        _scrollPagedView.dataSource = self;
        [_scrollPagedView registerClass:[BALPagedChatFaceViewCell class] forCellWithReuseIdentifier:PageEmotionViewIdentifier];
        [_scrollPagedView registerClass:[BALPagedPluginBoardViewCell class] forCellWithReuseIdentifier:PagePluginBoardViewIdentifier];
        [self addSubview:_scrollPagedView];
    }
    return _scrollPagedView;
}

- (void)setEmotionCateModel:(BALInputEmotionCateModel *)emotionCateModel {
    _emotionCateModel = emotionCateModel;
    
    NSInteger totalEmotions = emotionCateModel.emotionsArray.count;
    NSInteger pagedEmotions = emotionCateModel.layout.itemCountInPage;
    NSInteger page = totalEmotions % pagedEmotions == 0 ?
                                                        totalEmotions / pagedEmotions :
                                                        totalEmotions / pagedEmotions + 1;
    _dataSource = [NSMutableArray arrayWithCapacity:page];
    
    int i;
    for (i = 0; i < page; i++) {
        NSInteger origin = i * pagedEmotions;
        NSInteger len = pagedEmotions;
        if (origin+len >= totalEmotions) {
            len = totalEmotions - origin;
        }
        
        NSRange range = NSMakeRange(origin, len);
        NSLog(@"----- %lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
        NSMutableArray *tmpDs = [[emotionCateModel.emotionsArray subarrayWithRange:range] mutableCopy];
        if (_emotionCateModel.layout.emoji) {
            
            [tmpDs addObject:[BALInputEmotionModel deleteEmotionModel]];
        }
        [_dataSource addObject:tmpDs];
    }
    
    [_scrollPagedView reloadData];
    
}

- (void)setPluginItems:(NSArray *)pluginItems{
    _pluginItems = pluginItems;
    BALInputPluginLayout *layout = [BALInputPluginLayout defaultPluginLayout];
    
    NSInteger totalEmotions = _pluginItems.count;
    NSInteger pagedEmotions = layout.maxItemCountInPage;
    NSInteger page = totalEmotions % pagedEmotions == 0 ?
                                                        totalEmotions / pagedEmotions :
                                                        totalEmotions / pagedEmotions + 1;
    _dataSource = [NSMutableArray arrayWithCapacity:page];
    
    int i;
    for (i = 0; i < page; i++) {
        NSInteger origin = i * pagedEmotions;
        NSInteger len = pagedEmotions;
        if (origin+len >= totalEmotions) {
            len = totalEmotions - origin;
        }
        
        NSRange range = NSMakeRange(origin, len);
        NSLog(@"----- %lu,%lu",(unsigned long)range.location,(unsigned long)range.length);
        NSMutableArray *tmpDs = [[_pluginItems subarrayWithRange:range] mutableCopy];
//        [tmpDs addObject:[BALInputEmotionModel deleteEmotionModel]];
        [_dataSource addObject:tmpDs];
    }
    [_scrollPagedView reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_supportType == BALPagedSupportTypeEmotion) {
       
        BALPagedChatFaceViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PageEmotionViewIdentifier forIndexPath:indexPath];
//        cell.delegate = self;
        
        [cell setEmotionArray:_dataSource[indexPath.row] withLayout:_emotionCateModel.layout];
        
        return cell;
    }
    
    if (_supportType == BALPagedSupportTypePlugin) {
        
        BALPagedPluginBoardViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PagePluginBoardViewIdentifier forIndexPath:indexPath];
//        cell.delegate = self;
        
        [cell setPluginsArray:_dataSource[indexPath.row] withLayout:[BALInputPluginLayout defaultPluginLayout]];
        
        return cell;
    }
    
    return nil;
   
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
//    
//    return CGSizeZero;
//}

#pragma mark -
#pragma mark - BALPagedViewCellDelegate

- (void)pagedViewCell:(BALPagedBaseViewCell *)viewCell didSelectedOnEmotion:(BALInputEmotionModel *)emotionModel {
    
}

- (void)pagedViewCell:(BALPagedBaseViewCell *)viewCell didSelectedOnPluginItem:(BALInputPluginItemModel *)pluginModel {
    
}



@end
