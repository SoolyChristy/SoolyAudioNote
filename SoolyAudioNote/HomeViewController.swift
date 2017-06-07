//
//  HomeViewController.swift
//  SoolyAudioNote
//
//  Created by SoolyChristina on 2017/6/6.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var playBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension HomeViewController {
    @objc func start() {
        RecordManager.shared.startRecording()
    }
    
    @objc func save() {
        RecordManager.shared.stopRecording()
        playBtn.isHidden = false
    }
    
    @objc func playing() {
        RecordManager.shared.startPlaying()

    }
    
    @objc func rightItemClick() {
        navigationController?.pushViewController(MyRecordViewController(), animated: true)
    }
}

extension HomeViewController {
    func setupUI() {
        
        let rightItem = UIBarButtonItem(title: "我的录音", style: .plain, target: self, action: #selector(rightItemClick))
        navigationItem.rightBarButtonItem = rightItem
        
        let recordBtn = UIButton()
        recordBtn.setTitle("长按录音", for: .normal)
        recordBtn.setTitle("松开保存", for: .highlighted)
        recordBtn.setTitleColor(.black, for: .normal)
        recordBtn.sizeToFit()
        recordBtn.center = view.center
        
        recordBtn.addTarget(self, action: #selector(start), for: .touchDown)
        recordBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        view.addSubview(recordBtn)
        
        playBtn = UIButton(type: .contactAdd)
        playBtn.frame = CGRect(x: 50, y: 100, width: 40, height: 40)
        playBtn.addTarget(self, action: #selector(playing), for: .touchUpInside)
        playBtn.isHidden = true
        
        view.addSubview(playBtn)
    }
}
