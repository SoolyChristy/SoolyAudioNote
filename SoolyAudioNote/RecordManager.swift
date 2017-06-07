//
//  RecordManager.swift
//  SoolyAudioNote
//
//  Created by SoolyChristina on 2017/6/6.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit
import AVFoundation

class RecordManager: NSObject {
    static let shared = RecordManager()
    
    /// 录音文件路径
    var recordPaths = [String]()
    
    func startRecording() {
        aacPath = "\(docDir)/\(dateName()).aac"
        
        guard let url = URL(string: aacPath),
            let settings = recorderSettings else {
            return
        }
        
        do {
            try session.setActive(true)
            
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.prepareToRecord()
            recorder?.record()
            print("开始录音")
            
        } catch let error {
            print("录音失败 - \(error.localizedDescription)")
        }
    }
    
    func stopRecording() {
        guard let recorder = recorder else {
            return
        }
        recorder.stop()
        print("录音结束")
        
        recordPaths.append(aacPath)
        
        do {
            try session.setActive(false)
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    
    func startPlaying(path: String? = nil, compeletion: (() -> ())? = nil) {
        var urlString = aacPath
        
        if let path = path {
            urlString = path
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        do {
            try player = AVAudioPlayer(contentsOf: url)
            player?.play()
            player?.delegate = self
            print("开始播放")
        } catch let error {
            print("播放失败 - \(error.localizedDescription)")
        }
        
        self.compeletion = compeletion
    }
    
    func stopPlaying() {
        if let player = player, player.isPlaying {
            player.stop()
        }
    }
    
    private override init() {
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
        } catch let error {
            print("初始化session失败 - \(error.localizedDescription)")
        }
        
        recorderSettings = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC),
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVSampleRateKey : 44100.0
        ]
    }
    
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var aacPath = ""
    private var recorderSettings: [String: Any]?
    private let session = AVAudioSession.sharedInstance()
    /// 播放完成回调
    fileprivate var compeletion: (() -> ())?
}

extension RecordManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            compeletion?()
        }
    }
}

extension RecordManager {
    fileprivate func dateName() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        
        let name = formatter.string(from: Date())
        return name
    }
}
