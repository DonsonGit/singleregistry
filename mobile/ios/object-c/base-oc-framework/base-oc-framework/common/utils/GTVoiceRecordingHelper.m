//
//  GTVoiceRecordingHelper.m
//  GTreat
//
//  Created by yangji on 2017/8/12.
//  Copyright © 2017年 Luyee. All rights reserved.
//

#import "GTVoiceRecordingHelper.h"

@interface GTVoiceRecordingHelper() <AVAudioRecorderDelegate> {

}
@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) AVAudioSession *session;
@property(nonatomic, strong) NSString *fullPath;
@property(nonatomic, strong) NSURL *filePath;

@end

@implementation GTVoiceRecordingHelper

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)beginRecording{
    NSLog(@"开始录音");
    
    if ([self.player isPlaying]){
        [self.player stop];
    }
    
    self.isRecorded = NO;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if (session == nil) {
        NSLog(@"创建Session失败：%@", [sessionError description]);
    }else{
        [session setActive:YES error:nil];
    }
    self.session = session;
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _fullPath = [path stringByAppendingString:@"/TempRecord.wav"];
    self.filePath = [NSURL fileURLWithPath:_fullPath];
    
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:AVAudioQualityHigh], AVEncoderAudioQualityKey,
                                   nil
                                   ];
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.filePath settings:recordSetting error:nil];
    if (_recorder) {
        _recorder.meteringEnabled = YES;
        _recorder.delegate = self;
        [_recorder prepareToRecord];
        [_recorder record];
        
    }
    
}

-(void)saveVoiceToFile:(NSData *)voiceData{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if ([manager fileExistsAtPath:_fullPath]) {
        [manager removeItemAtPath:_fullPath error:&error];
    }
    [voiceData writeToURL:self.filePath atomically:YES];
    self.isRecorded = YES;
}

-(void)cancelRecording{
    NSLog(@"取消录音");
    self.isRecorded = NO;
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
}

-(void)endRecording{
    NSLog(@"结束录音");
    if ([self.recorder isRecording]) {
        [self.recorder stop];
    }
    self.isRecorded = YES;
    
//    NSFileManager *manager = [NSFileManager defaultManager];
//    if ([manager fileExistsAtPath:_fullPath]) {
//        
//    }
}

-(void)playRecording{
    NSLog(@"开始播放录音");
    [self.recorder stop];
    if ([self.player isPlaying]) {
        return;
    }
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.filePath error:nil];
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
}

-(void)stopPlayRecording{
    NSLog(@"结束播放录音");
    [self.player stop];
}

-(void)removeRecording{
    NSLog(@"删除录音");
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:_fullPath]) {
        [manager removeItemAtPath:_fullPath error:nil];
        self.filePath = nil;
        self.isRecorded = NO;
        _fullPath = nil;
        self.player = nil;
    }else{
        self.filePath = nil;
        self.isRecorded = NO;
        _fullPath = nil;
        self.player = nil;
        self.isRecorded = NO;
    }
}

-(double )voiceVolume{
    [self.recorder updateMeters];
    double volume = pow(10, 0.05 * [self.recorder peakPowerForChannel:0]);
    return volume;
}

-(CGFloat)voiceAverageVolume{
    [self.recorder updateMeters];
    return [self.recorder averagePowerForChannel:0];
}

-(double)voiceDuration{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:self.filePath options:nil];
    CMTime voiceDuration = asset.duration;
    return CMTimeGetSeconds(voiceDuration);
}

-(NSURL*)voiceFilePath{
    return _filePath;
}

-(void)setVoiceFilePath:(NSURL *)path{
    _filePath = path;
}

-(NSData *)voiceData{
    if (![[NSFileManager defaultManager] fileExistsAtPath:_fullPath]) {
        return nil;
    }
    return [NSData dataWithContentsOfFile:_fullPath];
}

@end
