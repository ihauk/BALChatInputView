//
//  BALClassManager.h
//  InputBar
//
//  Created by zhuhao on 16/7/2.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BALClassFetchBlock)(Class aclass, id userInfo);

@interface BALClassManager : NSObject

//+ (instancetype)sharedInstance;

+ (void)registerClass:(Class)aclass forkey:(NSString *)key;

//+ (void)registerClass:(Class)aclass forkey:(NSString *)key userInfo:(id)userInfo;

+ (void)scanClassForKey:(NSString *)key fetchblock:(BALClassFetchBlock)block;

@end
