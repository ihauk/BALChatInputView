//
//  VoiceCaptureView.h
//  iOS-IMKit
//
//  Created by xugang on 7/4/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#ifndef __GmacsVoiceCaptureControl
#define __GmacsVoiceCaptureControl

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GmacsVoiceRecorder.h"
#import "BALChatInputDefine.h"

@protocol GmacsVoiceCaptureControlDelegate <NSObject>

- (void)GmacsVoiceCaptureControlTimeout:(BOOL)timeout
                        withDuration:(double)duration
                         withWavData:(NSData *)data;

@end

/**
 * GmacsVoiceCaptureControl
 *  录制语音视图
 */
@interface GmacsVoiceCaptureControl : UIView

/**
 *  代理
 */
@property(nonatomic, weak) id<GmacsVoiceCaptureControlDelegate> delegate;

/**
 *  录制结束，返回的 语音数据
 */
@property(nonatomic, readonly, copy) NSData *stopRecord;

/**
 *  录制语音时长
 */
@property(nonatomic, readonly, assign) double duration;

/**
 *  设置倒计时时间
 *
 *  @param n 倒计时秒数
 */
- (void)setEscapeTime:(int)n;

/**
 *  开始录制语音
 */
- (void)startRecord;

/**
 *  取消录制
 */
- (void)cancelRecord;

/**
 *  show 取消录制的视图
 */
- (void)showCancelView;
@end

#endif