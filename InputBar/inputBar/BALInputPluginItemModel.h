//
//  BALInputPluginItemModel.h
//  InputBar
//
//  Created by zhuhao on 16/7/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BALInputPluginItemModel : NSObject

@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIImage *highlightImage;
@property(nonatomic,strong) NSString *title;

+ (BALInputPluginItemModel*) itemWithImage:(UIImage*)image highlightImage:(UIImage*)highlightImage title:(NSString*)title;

+ (BALInputPluginItemModel*) itemWithDic:(NSDictionary*)configDic;

@end

@interface BALInputPluginLayout : NSObject

@property(nonatomic,assign) NSInteger maxItemCountInPage;
@property(nonatomic,assign) NSInteger itemWidth;
@property(nonatomic,assign) NSInteger itemHeight;
@property(nonatomic,assign) NSInteger pageRowCount;
@property(nonatomic,assign) NSInteger pageColumnCount;
@property(nonatomic,assign) NSInteger buttonBegintLeftX;

+ (BALInputPluginLayout*) defaultPluginLayout;

@end
