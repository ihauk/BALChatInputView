//
//  GmacsPublicServiceMenuItem.m
//  GmacsIMLib
//
//  Created by zhuhao on 16/1/19.
//  Copyright © 2016年 58Ganji. All rights reserved.
//


#import "GmacsPublicServiceMenuItem.h"

@implementation GmacsPublicServiceMenuItem
+ (instancetype)menuItemFromJsonDic:(NSDictionary *)jsonDic {
    GmacsPublicServiceMenuItem *item = [GmacsPublicServiceMenuItem new];
    item.text = jsonDic[@"title"];
    item.url = jsonDic[@"url"];
    return item;
}
@end
