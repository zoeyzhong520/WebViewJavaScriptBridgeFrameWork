//
//  Music.swift
//  ReadBook
//
//  Created by JOE on 2017/8/23.
//  Copyright © 2017年 Hongyear Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

import UIKit

class Music: NSObject {

    var musicURL: URL?
    var voice_time:String?
    var audio:String?
    
    class func createModel(withMusicURL musicURL: URL?, withVoice_Time voice_time: String?, withAudio audio: String?) -> Music {
        
        let model = Music()
        
        model.musicURL = musicURL
        model.voice_time = voice_time
        model.audio = audio
        
        return model
    }
}



