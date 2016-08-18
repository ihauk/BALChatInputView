//
//  VoiceCaptureView.m
//  iOS-IMKit
//
//  Created by xugang on 7/4/14.
//  Copyright (c) 2014 Heq.Shinoda. All rights reserved.
//

#import "GmacsVoiceCaptureControl.h"
//#import "GmacsKitCommonDefine.h"
#import "GmacsVoiceRecorder.h"
#import <AVFoundation/AVFoundation.h>
#import "BALUtility.h"

@interface GmacsVoiceCaptureControl () <GmacsVoiceRecorderDelegate>
{
    NSTimer *__timer;
    float seconds;
}



@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIImageView *microPhoneView;
@property (nonatomic,strong) UILabel *escapeTimeLabel;
@property (nonatomic,strong) UILabel *TextLabel;
@property (nonatomic,strong) GmacsVoiceRecorder *myRecorder;
@property (nonatomic,assign) BOOL isCalled;
@property (nonatomic,strong) UIView *recordCancelView;
@property (nonatomic, strong) NSData *wavAudioData;


@end
@implementation GmacsVoiceCaptureControl

- (instancetype)initWithFrame:(CGRect)frame
{
    
    //frame = CGRectMake(frame.origin.x, frame.origin.y,160.0f, 160.0f);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        //self.userInteractionEnabled = YES;
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 160)];
        [self addSubview:self.contentView];
        
        [self.contentView setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2)];
        
        self.microPhoneView = [[UIImageView alloc]initWithFrame:CGRectMake(50.0f, 10.0f,60.0f, 60.0f)];
        self.escapeTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 75.0f, 160, 30)];
        self.TextLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 110, 150, 30)];
        
        [self.contentView addSubview:self.microPhoneView];
        [self.contentView addSubview:self.escapeTimeLabel];
        [self.contentView addSubview:self.TextLabel];
        
        [self.escapeTimeLabel setBackgroundColor:[UIColor clearColor]];
        [self.escapeTimeLabel setTextColor:[UIColor whiteColor]];
        [self.escapeTimeLabel setTextAlignment:NSTextAlignmentCenter];
        [self.TextLabel setBackgroundColor:[UIColor clearColor]];
        [self.TextLabel setTextColor:[UIColor whiteColor]];
        [self.TextLabel setTextAlignment:NSTextAlignmentCenter];
        [self.TextLabel setFont:[UIFont systemFontOfSize:13.5f]];
        
        [self setEscapeTime:60];
        self.escapeTimeLabel.hidden = YES;
        
        [self.TextLabel setText:@"slide_up_to_cancel_title"];
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量0"];
        [self.microPhoneView setImage:image];
        
        self.contentView.backgroundColor= [UIColor blackColor];
        [self.contentView setAlpha:0.7f];
        
        self.contentView.layer.cornerRadius = 4;
        self.contentView.layer.masksToBounds = YES;
        
        
        _myRecorder = [GmacsVoiceRecorder defaultVoiceRecorder];
        seconds = 0;
        _isCalled =NO;
        
        
        
        [self createCancelView];
        self.recordCancelView.hidden = YES;
        
    }
    return self;
}

-(void) showCancelView
{
    self.recordCancelView.hidden = NO;
}

-(void)createCancelView
{
    self.recordCancelView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.recordCancelView setBackgroundColor:[UIColor blackColor]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50.0f, 10.0f,60.0f, 60.0f)];
    imageView.image=[BALUtility chatInputImageWithNamed:@"声音_取消录音"];
    //[UIImage imageNamed:@"声音_取消录音"];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 110, 150, 30)];
    
    [textLabel setText:@"release_to_send_title"];
    [textLabel setFont:[UIFont systemFontOfSize:13.5f]];
    [textLabel setBackgroundColor:[UIColor redColor]];
    [textLabel setTextColor:[UIColor whiteColor]];
    [textLabel setTextAlignment:NSTextAlignmentCenter];
    
    textLabel.layer.cornerRadius = 4;
    textLabel.layer.masksToBounds = YES;
    
    [_recordCancelView addSubview:imageView];
    [_recordCancelView addSubview:textLabel];
    
    [self.contentView addSubview:_recordCancelView];
    
    
}
-(void)setEscapeTime:(int)n{
    
    if (n>=50) {
        [self.escapeTimeLabel setText:[NSString stringWithFormat:@"%d",60-n]];
        self.escapeTimeLabel.hidden=NO;
    }else {
        self.escapeTimeLabel.hidden=YES;
    }
}
-(void)setVoiceVolume {
    
}

-(void)startRecord {
    
    //判断是否有麦克风权限
    __block BOOL bCanRecord = NO;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        
        AVAudioSession* audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                } else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"speakerAccessRight" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alertView show];
                    });

                }
            }];
        }
    }
    //如果没有权限则跳出方法
    if(!bCanRecord){

        return;
    }
    
    //显示UI
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];

    if (__timer) {
        [__timer invalidate];
        __timer = nil;
    }
    __timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(scheduleOperarion) userInfo:nil repeats:YES];
    [self.myRecorder startRecordWithObserver:self];
    [__timer fire];
}

-(void)cancelRecord {
    [self.myRecorder cancelRecord];
    [__timer invalidate];
    __timer = nil;
    [self removeFromSuperview];

}

-(NSData*)stopRecord {
    
    [__timer invalidate];
    __timer = nil;
    [self removeFromSuperview];
    __block NSData *_wavData = nil;
    __block NSTimeInterval ses = 0.0f;
    [self.myRecorder stopRecord:^(NSData *wavData, NSTimeInterval secs) {
        _wavData = wavData;
        ses  = secs;
    }];
    _duration = ses;
    _wavAudioData = _wavData;
    return _wavData;
}

- (void)GmacsVoiceAudioRecorderDidFinishRecording:(BOOL)success
{
    DebugLog(@"%s, _duration > %f, ceil(_duration) >%f", __FUNCTION__, _duration, ceil(_duration));
    if (ceil(_duration) >= 60.0f) {
        if([self.delegate respondsToSelector:@selector(GmacsVoiceCaptureControlTimeout:withDuration:withWavData:)])
        {
            CGFloat wav_duration = 60.0f;
            [self.delegate GmacsVoiceCaptureControlTimeout:success withDuration:wav_duration withWavData:_wavAudioData];
        }
    }
    
}
- (void)GmacsVoiceAudioRecorderEncodeErrorDidOccur:(NSError *)error
{
    DebugLog(@"%s", __FUNCTION__);
}


-(void)scheduleOperarion {
    seconds = seconds + 0.02;
    [self setEscapeTime:seconds];
    float volume = [_myRecorder updateMeters];
    //DebugLog(@"volume>>> %f", volume);
    if (volume > 0.1f && volume < 0.70f) {
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量0"];
        [self.microPhoneView setImage:image];
    }else if(volume >= 0.70f && volume < 0.75f){
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量1"];
        [self.microPhoneView setImage:image];
    }else if(volume >= 0.75f && volume < 0.80f){
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量2"];
        [self.microPhoneView setImage:image];
    }else if(volume >= 0.80f && volume < 0.90f){
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量3"];
        [self.microPhoneView setImage:image];
    }else if(volume >= 0.90f && volume <= 1.0f){
        UIImage *image =[BALUtility chatInputImageWithNamed:@"声音_音量4"];
        [self.microPhoneView setImage:image];
    }
    if (seconds > 60) {
        [self stopRecord];
        _isCalled = YES;
    }
}

@end
