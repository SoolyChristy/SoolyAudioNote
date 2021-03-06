//
//  MyRecordCell.swift
//  SoolyAudioNote
//
//  Created by SoolyChristina on 2017/6/6.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

@objc protocol MyRecordCellDelegate {
    func myRecordCellPlayButtonClick(indexPath: IndexPath)
    func myRecordCellClick()
}

class MyRecordCell: UITableViewCell {
    
    weak var delegate: MyRecordCellDelegate?
    
    /// 文件路径
    var recordPath: String? {
        didSet {
            if let recordPath = recordPath {
                nameLabel.text = (recordPath as NSString).lastPathComponent
            }
        }
    }
    /// 正在播放标识
    var isPlaying = false {
        didSet {
            playingTagBtn.isHidden = !isPlaying
            playBtn.isEnabled = !isPlaying
        }
    }
    
    var indexPath = IndexPath()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playingTagBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    
    /// 从缓存池里取cell
    ///
    /// - Parameters:
    ///   - tableview: 表格
    ///   - indexPath: 当前cell的indexPath
    ///   - playingIndexPath: 正在播放cell的indexPath
    /// - Returns: 返回的cell
    static func cell(tableview: UITableView, indexPath: IndexPath, playingIndexPath: IndexPath?) -> MyRecordCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyRecordCell
        
        cell.indexPath = indexPath
        cell.recordPath = RecordManager.shared.recordPaths[indexPath.row]
        
        cell.isPlaying = false
        
        // 若当前cell 是 正在播放的cell 则保留 播放状态标识
        if let playingIndexPath = playingIndexPath, playingIndexPath == indexPath {
            cell.isPlaying = true
        }
        
        return cell
    }
    
    // 点击播放按钮
    @IBAction func playBtnClick() {
        RecordManager.shared.startPlaying(path: recordPath) { [weak self] in
            self?.isPlaying = false
            self?.delegate?.myRecordCellClick()
        }
        
        isPlaying = true
        delegate?.myRecordCellPlayButtonClick(indexPath: indexPath)
    }
    
    func stopPlaying() {
        RecordManager.shared.stopPlaying()
        isPlaying = false
    }
}
