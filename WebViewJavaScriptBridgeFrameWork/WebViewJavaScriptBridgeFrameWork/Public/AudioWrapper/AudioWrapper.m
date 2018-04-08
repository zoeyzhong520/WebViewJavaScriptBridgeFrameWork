//
//  AudioWrapper.m
//  ConvertToMP3-Demo
//
//  Created by JOE on 2017/8/21.
//  Copyright © 2017年 JOE. All rights reserved.
//

#import "AudioWrapper.h"

@implementation AudioWrapper

///创建单例
+ (instancetype)defaultAudioWrapper {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Convent Pcm ToMp3
- (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath callback:(void (^)(BOOL result))callback {
    
    NSLog(@"convert begin!!");
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        weakSelf.isStopRecord = NO;
        
        @try{
            
            int read, write;
            
            FILE*pcm =fopen([cafFilePath cStringUsingEncoding:NSASCIIStringEncoding],"rb");
            
            FILE*mp3 =fopen([mp3FilePath cStringUsingEncoding:NSASCIIStringEncoding],"wb");
            
            const int PCM_SIZE = 8192;
            
            const int MP3_SIZE = 8192;
            
            short int pcm_buffer[PCM_SIZE * 2];
            
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            
            //lame_set_num_channels(lame,2);//设置1为单通道，默认为2双通道
            
            lame_set_in_samplerate(lame, 11025.0);//11025.0
            
            lame_set_VBR(lame, vbr_default);
            
            lame_set_brate(lame,32);
            
            lame_set_mode(lame,3);
            
            lame_set_quality(lame,2);
            
            lame_init_params(lame);
            
            long curpos;
            
            BOOL isSkipPCMHeader = NO;
            
            do{
                
                curpos = ftell(pcm);
                
                long startPos = ftell(pcm);
                
                fseek(pcm, 0,SEEK_END);
                
                long endPos =ftell(pcm);
                
                long length = endPos - startPos;
                
                fseek(pcm, curpos,SEEK_SET);
                
                if(length > PCM_SIZE * 2 *sizeof(short int)) {
                    
                    if(!isSkipPCMHeader) {
                        
                        //Uump audio file header, If you do not skip file header
                        
                        //you will heard some noise at the beginning!!!
                        
                        fseek(pcm, 4 * 1024,SEEK_SET);
                        
                        isSkipPCMHeader =YES;
                        NSLog(@"skip pcm file header !!!!!!!!!!");
                    }
                    
                    read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
                    
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                    
                    fwrite(mp3_buffer, write, 1, mp3);
                    NSLog(@"read %d bytes", write);
                }
                
                else{
                    
                    [NSThread sleepForTimeInterval:0.05];
                    NSLog(@"sleep");
                }
                
            }while(!weakSelf.isStopRecord);
            
            read = (int)fread(pcm_buffer, 2 *sizeof(short int), PCM_SIZE, pcm);
            
            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            NSLog(@"read %d bytes and flush to mp3 file", write);
            lame_mp3_tags_fid(lame, mp3);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        
        @catch(NSException *exception) {
            NSLog(@"%@", [exception description]);
            if (callback) {
                callback(NO);
            }
        }
        
        @finally{
            NSLog(@"convert mp3 finish!!!");
            if (callback) {
                callback(YES);
            }
        }
    });
}

/**
 send end record signal
 */
- (void)sendEndRecord {
    self.isStopRecord = YES;
}


#pragma mark - ----------------------------------

// 这是录完再转码的方法, 如果录音时间比较长的话,会要等待几秒...
// Use this FUNC convent to mp3 after record

+ (void)conventToMp3WithCafFilePath:(NSString *)cafFilePath mp3FilePath:(NSString *)mp3FilePath beginBlock:(void (^)(NSString *))beginBlock callback:(void (^)(BOOL))callback
{
    if (beginBlock) {
        beginBlock(@"convert begin!!!");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        //fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        
        lame_set_num_channels(lame,2);//设置1为单通道，默认为2双通道
        
        lame_set_in_samplerate(lame, 11025.0);//11025.0
        
        //lame_set_VBR(lame, vbr_default);
        
        lame_set_brate(lame,32);
        
        lame_set_mode(lame,3);
        
        lame_set_quality(lame,2);
        
        lame_init_params(lame);
        
        do {
            
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_mp3_tags_fid(lame, mp3);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        if (callback) {
            callback(NO);
        }
    }
    @finally {
        NSLog(@"-----\n  MP3生成成功: %@   -----  \n", mp3FilePath);
        if (callback) {
            callback(YES);
        }
    }
}

@end




