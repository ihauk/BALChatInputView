//
//  BALClassManager.m
//  InputBar
//
//  Created by zhuhao on 16/7/2.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALClassManager.h"

@interface BALClassManager ()

@property(nonatomic,strong) NSMutableDictionary *classMapping; //<string,string>

@end

@implementation BALClassManager

+ (instancetype)sharedInstance {
    static BALClassManager *s_classManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_classManager = [[ BALClassManager alloc] init];
    });
    
    return s_classManager;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        _classMapping = [NSMutableDictionary dictionary];
    }
    
    return self;
}

#pragma mark -
#pragma mark - public method 

+ (void)registerClass:(Class)aclass forkey:(NSString *)key {
    
    [[self sharedInstance] registerClass:aclass forkey:key];
}

+ (void)registerClass:(Class)aclass forkey:(NSString *)key userInfo:(id)userInfo {
 
    [[self sharedInstance] registerClass:aclass forkey:key userInfo:userInfo];
}

+ (void)scanClassForKey:(NSString *)key fetchblock:(BALClassFetchBlock)block {
    
   NSString *classStr = [[self sharedInstance] getClassesForKey:key];
    if (block) {
        block(NSClassFromString(classStr),nil);
    }
}


#pragma mark -
#pragma mark - private 

- (void)registerClass:(Class)aclass forkey:(NSString *)key {
    
    if (!aclass || !key || key.length == 0) return;
    
    [_classMapping setObject:NSStringFromClass(aclass) forKey:key];
        
}

- (void)registerClass:(Class)aclass forkey:(NSString *)key userInfo:(id)userInfo {
    
}

- (NSString* )getClassesForKey:(NSString *)key
{
    if (key == nil) return nil;
    return [_classMapping objectForKey:key];
}



@end
