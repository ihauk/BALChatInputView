/**
 * Copyright (c) 2014-2015, RongCloud.
 * All rights reserved.
 *
 * All the contents are the copyright of RongCloud Network Technology Co.Ltd.
 * Unless otherwise credited. http://rongcloud.cn
 *
 */

//  RCPublicServiceMenuGroup.m
//  Created by litao on 15/4/14.

#import "GmacsPublicServiceMenuGroup.h"
#import "GmacsPublicServiceMenuItem.h"

@implementation GmacsPublicServiceMenuGroup
+ (instancetype)menuGroupFromJsonDic:(NSDictionary *)jsonDic {
    GmacsPublicServiceMenuGroup *out = [GmacsPublicServiceMenuGroup new];
    out.title = jsonDic[@"title"];
    NSArray *menuItems = jsonDic[@"menu"];
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *menuItemJson in menuItems) {
        [temp addObject:[GmacsPublicServiceMenuItem menuItemFromJsonDic:menuItemJson]];
    }
    out.menuItems = [temp copy];
    return out;
}
@end
