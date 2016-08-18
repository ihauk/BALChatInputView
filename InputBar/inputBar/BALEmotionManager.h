//
//  BALEmotionManager.h
//  InputBar
//
//  Created by zhuhao on 16/8/17.
//  Copyright © 2016年 zhuhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BALEmotionManager : NSObject

@property(nonatomic,strong) NSCache *emotionCache;

- (void)cacheEmoji:(NSString*)emojiKey emojiImage:(UIImage*)image;

@end
