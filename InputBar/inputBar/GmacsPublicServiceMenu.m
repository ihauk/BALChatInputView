//
//  GmacsPublicServiceMenu.m
//  GmacsIMLib
//
//  Created by zhuhao on 16/1/19.
//  Copyright © 2016年 58Ganji. All rights reserved.
//

#import "GmacsPublicServiceMenu.h"

@implementation GmacsPublicServiceMenu

- (instancetype)initWithMenuDic:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        
        [self decodeWithDic:dic];
    }
    return self;
}

- (void)decodeWithDic:(NSDictionary *)menuDic {
    
    if (!menuDic) {
        return;
    }

    NSMutableArray *out = [NSMutableArray new];
    if (menuDic) {
        NSArray *menuJsonArray = menuDic[@"menu"];
        for (NSDictionary *groupJson in menuJsonArray) {
            [out addObject:[GmacsPublicServiceMenuGroup menuGroupFromJsonDic:groupJson]];
        }
    }
    self.menuGroups = [out copy];
}
@end
