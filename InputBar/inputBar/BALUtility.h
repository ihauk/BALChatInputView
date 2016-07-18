//
//  BALUtility.h
//  InputBar
//
//  Created by zhuhao on 16/7/2.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@interface BALUtility : NSObject

+(UIImage*)chatInputImageWithNamed:(NSString*)name ;

+(UIImage*)emotionImageWithContentOfFile:(NSString*)imagePath ;

+(UIImage*)pluginImageWithNamed:(NSString*)name;

+(UIImage*)imageNamed:(NSString*)name ofBundle:(NSString*)bundleName;

+ (NSString *)inputBundlePath;

@end
