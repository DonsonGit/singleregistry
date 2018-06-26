//
//  GTVoiceRecordingHelper.h
//  GTreat
//
//  Created by yangji on 2017/8/12.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GTVoiceRecordingHelper : NSObject

#define MAX_RECORDING_TIME 180

@property(nonatomic, strong) AVAudioPlayer *player;
@property(nonatomic, assign) BOOL isRecorded;

+ (instancetype)sharedInstance;

-(void)beginRecording;
-(void)cancelRecording;
-(void)endRecording;

-(void)saveVoiceToFile:(NSData *)voiceData;

-(void)playRecording;
-(void)stopPlayRecording;
-(void)removeRecording;

-(double )voiceVolume;
-(CGFloat)voiceAverageVolume;
-(double)voiceDuration;

-(NSURL*)voiceFilePath;
-(void)setVoiceFilePath:(NSURL *)path;

-(NSData *)voiceData;

@end
