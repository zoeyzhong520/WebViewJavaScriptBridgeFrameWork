//
//  AudioPlayer.swift
//  ReadBook
//
//  Created by JOE on 2017/8/23.
//  Copyright © 2017年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {

    //单例
    static let shareInstance = AudioPlayer()
    private override init() {}
    
    private static var instance: AVAudioPlayer? = nil
    private static var activeMusic: Music? = nil
    private static var isRandomPlay = false
    
    ///播放结束闭包
    var finishPlayingClosure:(() -> Void)?
    
    static func share(model: Music) -> Bool {
        
        do {
            try instance = AVAudioPlayer(contentsOf: model.musicURL!)
            instance?.delegate = shareInstance
        } catch {
            print("error occured: \(error)")
            
            instance = nil
            return false
        }
        
        do {
            try AVAudioSession().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Error setting category: \(error)")
        }
        
        return true
    }
    
    /// 播放网络音频
    static func shareForNet(model: Music) -> Bool {
        
        do {
            try instance = AVAudioPlayer(data: NSData(contentsOf: model.musicURL!) as Data)
            instance?.delegate = shareInstance
        } catch {
            print("error occured: \(error)")
            
            instance = nil
            return false
        }
        
        do {
            try AVAudioSession().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            print("Error setting category: \(error)")
        }
        
        return true
    }
    
    /// 停止
    static func stop() {
        instance?.stop()
    }
    
    /// 播放
    static func play() {
        voice(num: 1.0)
        instance?.play()
    }
    
    /// 暂停
    static func pause() {
        instance?.pause()
    }
    
    /// 下一曲
    static func nextSong(num: Int) -> Bool {
        //var num = num
        //var musicArray: Array<Music>!
        
        return true
    }
    
    /// 上一曲
    static func prevSong(num: Int) -> Bool {
        return true
    }
    
    /// 声音控制
    static func voice(num: Float) {
        instance?.volume = num
    }
    
    /// 进度条相关
    static func progress() -> Double {
        return (instance?.currentTime)! / (instance?.duration)!
    }
    
    static func musicDuration() -> Double {
        return (instance?.duration)!
    }
    
    static func currentTime() -> Double {
        return (instance?.currentTime)!
    }
    
    /// 当前播放的音乐
    static func activeSong() -> Music? {
        return activeMusic
    }
    
    /// 是否在播放音乐
    static func isPlaying() -> Bool {
        return (instance?.isPlaying)!
    }
    
    /// 随机播放
    static func musicRandomPlay() -> Bool {
        if isRandomPlay == false {
            isRandomPlay = true
            return isRandomPlay
        }else{
            isRandomPlay = false
            return isRandomPlay
        }
    }
}

extension AudioPlayer: AVAudioPlayerDelegate {
    
    //MARK: AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        print("播放 完成")
        
        if finishPlayingClosure != nil {
            finishPlayingClosure!() //进行闭包回调
        }
    }
}



