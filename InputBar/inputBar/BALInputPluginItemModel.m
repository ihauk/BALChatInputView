//
//  BALInputPluginItemModel.m
//  InputBar
//
//  Created by zhuhao on 16/7/16.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALInputPluginItemModel.h"
#import "BALUtility.h"

@interface BALInputPluginItemModel ()

@end

@implementation BALInputPluginItemModel

+ (BALInputPluginItemModel*) itemWithImage:(UIImage*)image highlightImage:(UIImage*)highlightImage title:(NSString*)title{
    
    BALInputPluginItemModel *item = [[BALInputPluginItemModel alloc] init];
    item.image = image;
    item.highlightImage = highlightImage;
    item.title = title;
    
    return item;
}

+ (BALInputPluginItemModel *)itemWithDic:(NSDictionary *)configDic {
    
    BALInputPluginItemModel *item = [[BALInputPluginItemModel alloc] init];
    item.image = [BALUtility pluginImageWithNamed:configDic[@"normalImage"]];
    item.highlightImage = [BALUtility pluginImageWithNamed:configDic[@"highlightImage"]];
    item.title = configDic[@"title"];
    item.actionTag = configDic[@"actionTag"];
    
    return item;
}

@end

@implementation BALInputPluginLayout

+(BALInputPluginLayout *)defaultPluginLayout{
    BALInputPluginLayout *layout = [[BALInputPluginLayout alloc] init];
    layout.maxItemCountInPage = 8;
    layout.itemWidth = 74;
    layout.itemHeight = 85;
    layout.pageRowCount = 2;
    layout.pageColumnCount = 4;
    layout.buttonBegintLeftX = 11;
    
    return layout;
}

@end
