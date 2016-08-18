//
//  GmacsVoiceRecorder.h
//  GmacsIMKit
//
//  Created by xugang on 15/1/22.
//  Copyright (c) 2015 58Ganji. All rights reserved.
//

#ifndef __GmacsVoiceRecorder
#define __GmacsVoiceRecorder

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BALChatInputDefine.h"

@protocol GmacsVoiceRecorderDelegate;

/**
 *  语音录制器
 */
@interface GmacsVoiceRecorder : NSObject

/**
 *  单例
 */
+(GmacsVoiceRecorder*) defaultVoiceRecorder;

/**
 *  开始录音
 *
 *  @param observer 观察者
 *
 *  @return 是否成功开始
 */
-(BOOL)startRecordWithObserver:(id<GmacsVoiceRecorderDelegate>)observer;

/**
 *  取消录制
 */
-(BOOL)cancelRecord;

/**
 *  停止录制
 *
 *  @param compeletion callback
 */
-(void)stopRecord:(void(^)(NSData* wavData, NSTimeInterval secs))compeletion;

-(CGFloat)updateMeters;

@end

/**
 *  GmacsVoiceRecorder delegate
 */
@protocol GmacsVoiceRecorderDelegate <NSObject>

/**
 *  完成录制
 */
- (void)GmacsVoiceAudioRecorderDidFinishRecording:(BOOL)success;

/**
 *  发生错误
 */
- (void)GmacsVoiceAudioRecorderEncodeErrorDidOccur:(NSError *)error;

@end

#endif