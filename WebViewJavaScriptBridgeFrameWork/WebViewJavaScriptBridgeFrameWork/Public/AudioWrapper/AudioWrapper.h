//
//  AudioWrapper.h
//  ConvertToMP3-Demo
//
//  Created by JOE on 2017/8/21.
//  Copyright © 2017年 JOE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "lame.h"

typedef void(^ConvertSuccessBlock)(void);

@interface AudioWrapper : NSObject

///创建单例
+ (instancetype)defaultAudioWrapper;

///是否停止录音
@property (nonatomic, assign) BOOL isStopRecord;

/// Convent Pcm ToMp3
- (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath callback:(void (^)(BOOL result))callback;

/// Use this FUNC convent to mp3 after record
+ (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath
                        mp3FilePath:(NSString *)mp3FilePath beginBlock:(void(^)(NSString *begin))beginBlock
                           callback:(void(^)(BOOL result))callback;

/**
 send end record signal
 */
- (void)sendEndRecord;

@end
