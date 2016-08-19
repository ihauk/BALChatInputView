//
//  GmacsPublicServiceMenuGroup.h
//  GmacsIMLib
//
//  Created by zhuhao on 16/1/19.
//  Copyright © 2016年 58Ganji. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * 公众服务账号菜单组类
 */
@interface GmacsPublicServiceMenuGroup : NSObject

/**
 * 菜单组名称
 */
@property(nonatomic, strong) NSString *title;


/**
 * 菜单条目
 */
@property(nonatomic, strong) NSArray *menuItems;

/**
 *  根据JSON 字典创建公众服务账号菜单组对象
 *
 *  @param jsonDic 存储菜单组属性的字典
 *
 *  @return 公众服务账号菜单组对象
 */
+ (instancetype)menuGroupFromJsonDic:(NSDictionary *)jsonDic;
@end
