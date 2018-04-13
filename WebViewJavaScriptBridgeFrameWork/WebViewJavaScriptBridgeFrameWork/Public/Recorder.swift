//
//  Recorder.swift
//  ReadBook
//
//  Created by JOE on 2017/8/13.
//  Copyright © 2017年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

//MARK: -
//MARK: 自定义 录音
//MARK: -

import UIKit
import AVFoundation

class Recorder: NSObject {

    //MARK: 单例
    static var shareInstance = Recorder()
    private override init() {}
    
    ///录音结束执行的闭包
    var finishRecordingClosure:((Double) -> Void)?
    
    ///index
    var index:Int = 0
    
    class func setupRecorder(index: Int) -> AVAudioRecorder {
        
        shareInstance.index = index //为index赋值
        let url = NSURL(fileURLWithPath: TmpPath.appendingPathComponent("\(index).pcm"))
        print(url)
        
        let settings = [AVSampleRateKey: NSNumber.init(floatLiteral: 11025.0), AVFormatIDKey: NSNumber.init(floatLiteral: Double(kAudioFormatLinearPCM)), AVNumberOfChannelsKey: NSNumber.init(floatLiteral: 2), AVEncoderAudioQualityKey: NSNumber.init(floatLiteral: Double(AVAudioQuality.high.rawValue)), AVLinearPCMBitDepthKey: NSNumber.init(value: 16), AVEncoderBitRateKey: NSNumber.init(value: 12800)]
        
        var recorder: AVAudioRecorder?
        
        do {
            recorder = try AVAudioRecorder(url: url as URL, settings: settings)
            recorder?.delegate = shareInstance
        } catch {
            print("Ups, could not create recorder: \(error)")
        }
        
        //在我们的音视频场景配置，指定其他声音被强制变小
        do {
            try AVAudioSession().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .duckOthers)
        } catch {
            print("Error setting category: \(error)")
        }
        
        return recorder!
    }
    
    //MARK: 开始录音
    class func startRecorder(recorder:AVAudioRecorder?) {
        recorder?.prepareToRecord()
        recorder?.isMeteringEnabled = true
        recorder?.record()
    }
    
    //MARK: 暂停录音
    class func pauseRecorder(recorder:AVAudioRecorder?) {
        recorder?.pause()
    }
    
    //MARK: 结束录音
    class func stopRecorder(recorder:AVAudioRecorder?) {
        recorder?.stop()
    }
    
    //MARKL: 获取录音文件的时长
    class func audioDuration(index: Int) -> Double {
        
        var musicDuration:Double = 0.0
        
        let music = Music.createModel(withMusicURL: URL(fileURLWithPath: TmpPath.appendingPathComponent("\(index).pcm")), withVoice_Time: nil, withAudio: nil)
        if AudioPlayer.share(model: music) {
            musicDuration = AudioPlayer.musicDuration()
        }
        return musicDuration
    }
}

//MARK: AVAudioRecorderDelegate
extension Recorder: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag == true {
            print("录音  完毕")
            AudioWrapper.default().sendEndRecord()
            
            //当我们的场景结束时，为了不影响其他场景播放声音变小
            do {
                try AVAudioSession().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            } catch {
                print("Error setting category: \(error)")
            }
        }
    }
}



