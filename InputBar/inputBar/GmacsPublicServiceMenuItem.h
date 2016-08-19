//
//  GmacsPublicServiceMenuItem.h
//  GmacsIMLib
//
//  Created by zhuhao on 16/1/19.
//  Copyright © 2016年 58Ganji. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * 公众服务账号菜单元条目类
 */
@interface GmacsPublicServiceMenuItem : NSObject

/**
 * 菜单标题
 */
@property(nonatomic, strong) NSString *text;
/**
 * 菜单链接
 */
@property(nonatomic, strong) NSString *url;

/**
 * 根据JSON 字典创建菜单项实体
 * @param  jsonDic   存储菜单项属性的字典
 * @return 返回对象实例
 */
+ (instancetype)menuItemFromJsonDic:(NSDictionary *)jsonDic;
@end
