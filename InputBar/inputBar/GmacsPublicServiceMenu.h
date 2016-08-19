//
//  GmacsPublicServiceMenu.h
//  GmacsIMLib
//
//  Created by zhuhao on 16/1/19.
//  Copyright © 2016年 58Ganji. All rights reserved.
//

/* Menu -> MenuGroup -> MenuItem
 *                   -> MenuItem
 *
 *         MenuGroup -> MenuItem
 *                   -> MenuItem
 *                   -> MenuItem
 */
#import <Foundation/Foundation.h>
#import "GmacsPublicServiceMenuGroup.h"
#import "GmacsPublicServiceMenuItem.h"

/**
 *  公众服务账号菜单类
 */
@interface GmacsPublicServiceMenu : NSObject

/**
*  菜单名称
*/
@property(nonatomic, strong) NSString *title;

/**
 *  菜单组
 */
@property(nonatomic, strong) NSArray *menuGroups;


- (instancetype)initWithMenuDic:(NSDictionary*)dic;

@end
