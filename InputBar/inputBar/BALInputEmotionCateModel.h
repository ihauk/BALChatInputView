//
//  BALInputEmotionCateModel.h
//  InputBar
//
//  Created by zhuhao on 16/7/14.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BALInputEmotionLayout : NSObject

@property (nonatomic, assign) NSInteger rows;               //行数
@property (nonatomic, assign) NSInteger columes;            //列数
@property (nonatomic, assign) NSInteger itemCountInPage;    //每页显示几项
@property (nonatomic, assign) CGFloat   cellWidth;          //单个单元格宽
@property (nonatomic, assign) CGFloat   cellHeight;         //单个单元格高
@property (nonatomic, assign) CGFloat   imageWidth;         //显示图片的宽
@property (nonatomic, assign) CGFloat   imageHeight;        //显示图片的高
@property (nonatomic, assign) BOOL      emoji;

- (id)initEmojiLayout:(CGFloat)width;
- (id)initCharletLayout:(CGFloat)width ;

@end


/**
 *  一个表情
 */
@interface BALInputEmotionModel : NSObject

@property (nonatomic,strong)    NSString    *emoticonID;
@property (nonatomic,strong)    NSString    *showName;
@property (nonatomic,strong)    NSString    *fileName;

+ (BALInputEmotionModel*)deleteEmotionModel;

@end

/**
 * 一个表情分类
 */
@interface BALInputEmotionCateModel : NSObject

@property(nonatomic,strong) NSString *cateName;
@property(nonatomic,strong) NSString *iconName;
@property(nonatomic,strong) NSString *highlightIconName;
@property(nonatomic,strong) NSMutableArray<BALInputEmotionModel*> *emotionsArray;
@property(nonatomic,strong) BALInputEmotionLayout *layout;

@end

