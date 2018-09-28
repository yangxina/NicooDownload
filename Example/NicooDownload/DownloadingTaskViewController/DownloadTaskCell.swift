//
//  DownloadTaskCell.swift
//  Example
//
//  Created by Daniels on 2018/3/16.
//  Copyright © 2018年 Daniels. All rights reserved.
//

import UIKit
import NicooDownload

class DownloadTaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var bytesLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    var tapClosure: ((DownloadTaskCell) -> Void)?

    func updateProgress(task: NicooTask) {
        progressView.progress = Float(task.progress.fractionCompleted)
        bytesLabel.text = "\(task.progress.completedUnitCount.tr.convertBytesToString())/\(task.progress.totalUnitCount.tr.convertBytesToString())"
        speedLabel.text = task.speed.tr.convertSpeedToString()
        timeRemainingLabel.text = "剩余时间：\(task.timeRemaining.tr.convertTimeToString())"
        startDateLabel.text = "开始时间：\(task.startDate.tr.convertTimeToDateString())"
        statusLabel.text = "状态：\(task.status)"
        
        titleLabel.text = task.fileName

    }

}
