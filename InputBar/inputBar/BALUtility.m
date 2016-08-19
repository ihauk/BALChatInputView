//
//  BALUtility.m
//  InputBar
//
//  Created by zhuhao on 16/7/2.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import "BALUtility.h"

@implementation BALUtility

+ (UIImage *)chatInputImageWithNamed:(NSString *)name {
    
    return [[self class] imageNamed:name ofBundle:@"Input.bundle"];
}

+(UIImage*)emotionImageWithContentOfFile:(NSString*)imagePath {
    UIImage *image = nil;
    image = [[UIImage alloc]initWithContentsOfFile:imagePath];
    
    return image;
}

+(UIImage*)pluginImageWithNamed:(NSString*)name {
    UIImage *image = nil;
    NSString *bundlePath = [[self class] inputBundlePath];
    NSString *pluginPath = [bundlePath stringByAppendingPathComponent:@"Plugin"];
    NSString *imagePath = [pluginPath stringByAppendingPathComponent:name];
    
    image = [UIImage imageWithContentsOfFile:imagePath];
    
    return image;
}


+(UIImage*)imageNamed:(NSString*)name ofBundle:(NSString*)bundleName {
    
    UIImage *image = nil;
    NSString *image_name = [NSString stringWithFormat:@"%@.png",name];
    NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:bundleName];
    NSString *image_path = [bundlePath stringByAppendingPathComponent:image_name];
    
    image = [[UIImage alloc]initWithContentsOfFile:image_path];
    
    return image;
}

+ (NSString *)inputBundlePath {
    NSString *resourcePath = [[NSBundle mainBundle]resourcePath];
    NSString *bundlePath = [resourcePath stringByAppendingPathComponent:@"Input.bundle"];
    
    return bundlePath;
}




@end
