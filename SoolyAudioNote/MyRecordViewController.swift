//
//  MyRecordViewController.swift
//  SoolyAudioNote
//
//  Created by SoolyChristina on 2017/6/6.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

class MyRecordViewController: UIViewController {

    lazy var tableView = UITableView()
    /// 正在播放cell的索引
    var playingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

// MARK: tableView方法
extension MyRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecordManager.shared.recordPaths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyRecordCell.cell(tableview: tableView, indexPath: indexPath, playingIndexPath: playingIndexPath)
        cell.delegate = self
        return cell
    }
}

extension MyRecordViewController: MyRecordCellDelegate {
    
    // 点击cell的播放按钮 记录此cell的indePath 并隐藏之前cell的播放状态
    func myRecordCellPlayButtonClick(indexPath: IndexPath) {
        guard let playingIndexPath = playingIndexPath else {
            self.playingIndexPath = indexPath
            return
        }
        
        let cell = tableView.cellForRow(at: playingIndexPath) as? MyRecordCell
        cell?.playingTagBtn.isHidden = true
        
        self.playingIndexPath = indexPath
    }
    
    func myRecordCellClick() {
        playingIndexPath = nil
    }
}

// MARK: UI
extension MyRecordViewController {
    fileprivate func setupUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 54
        tableView.register(UINib(nibName: "MyRecordCell", bundle: Bundle.main), forCellReuseIdentifier: cellID)
        view.addSubview(tableView)
    }
}
