//
//  TasksListViewController.swift
//  Demo
//
//  Created by 小星星 on 2018/9/26.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import NicooDownload

class TasksListViewController: UIViewController {
    
    static let cellId = "DownloadTaskCell"

    var urlStrings: [String]!
    var nameString: [String]!
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 164
        table.tableFooterView = UIView()
        return table
    }()
    private lazy var fileBarButton: UIBarButtonItem = {
        let bar = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(TasksListViewController.fileVC))
        return bar
    }()
    
    private var tasks: [NicooTask]?
    
    var tasksManager = NicooManager("TaskListViewController", isStoreInfo: true)
   
   
//    deinit {
//        tasksManager.invalidate()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "taskList-Downloading"
        
        if #available(iOS 11, *) {
        } else {
            tableView.contentInset.top = 64
            tableView.scrollIndicatorInsets.top = 64
        }
        navigationItem.rightBarButtonItems = [fileBarButton]
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "DownloadTaskCell", bundle: Bundle.main), forCellReuseIdentifier: TasksListViewController.cellId)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downLoad()
    }
    
    private func downLoad() {
        tasksManager.maxConcurrentTasksLimit = 3
        tasksManager.isStartDownloadImmediately = true
        tasksManager.multiDownload(urlStrings, fileNames: nameString, progressHandler: nil, successHandler: nil, failureHandler: nil)
        setupManager()
        tableView.reloadData()
        
    }
    
    @objc func fileVC() {
        let filevc = FileViewController()
        navigationController?.pushViewController(filevc, animated: true)
    }
    
    /// 全部任务下载完成或者其他
    func setupManager() {
        // 设置manager的回调
        tasksManager.progress { [weak self] (manager) in
            guard let strongSelf = self else { return }
            }.success{ [weak self] (manager) in
                guard let strongSelf = self else { return }
                if manager.status == .suspend {
                    // manager 暂停了 下载
                }
                if manager.status == .completed {
                    print("all task - completed ")
                    // manager 完成了 下载 (这里的完成时所有任务的完成）
                    
                }
            }.failure { [weak self] (manager) in
                
                if manager.status == .failed {
                    // manager 失败了
                }
                if manager.status == .cancel {
                    // manager 取消了
                }
                if manager.status == .remove {
                    // manager 移除了
                }
        }
    }
    
    /// 单个任务下载完成或者其他
    func configTask(task: NicooTask, cell: UITableViewCell, visible: Bool) {
        task.progress { [weak cell] (task) in
            guard let cell = cell as? DownloadTaskCell else { return }
            if visible {
                // 可视范围内的cell更新UI
                cell.updateProgress(task: task)
            }
            }
            .success({ [weak self] (task) in
                guard let cell = cell as? DownloadTaskCell else { return }
                if visible {
                     // 可视范围内
                    cell.statusLabel.text = "状态：\(task.status)"
                }
               
                if task.status == .suspend {
                    // 下载任务暂停了
                }
                if task.status == .completed {
                    // 下载任务完成了 (这里的完成时单个任务的完成）
                    print("single task - completed ->\(task.fileName)")
                   // self?.tasksManager.remove(task.URLString, completely: false)
                    self?.tableView.reloadData()
                }
            })
            .failure({ [weak cell] (task) in
                guard let cell = cell as? DownloadTaskCell else { return }
                if visible {
                     // 可视氛围内，更新cell上的UI
                    cell.statusLabel.text = "状态：\(task.status)"
                }
                
                if task.status == .failed {
                    // 下载任务失败了
                }
                if task.status == .cancel {
                    // 下载任务取消了
                }
                if task.status == .remove {
                    // 下载任务移除了
                }
            })
    }
    

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TasksListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksManager.unCompletedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TasksListViewController.cellId, for: indexPath) as! DownloadTaskCell
        let task = tasksManager.unCompletedTasks[indexPath.row]
        
        cell.updateProgress(task: task)
        
        
        return cell
    }
    
    // 每个cell中的状态更新，应该在willDisplay中执行
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let task = tasksManager.unCompletedTasks.safeObjectAtIndex(indexPath.row)
            else { return }
        
        configTask(task: task, cell: cell, visible: true)
    }
    
    // 由于cell是循环利用的，不在可视范围内的cell，不应该去更新cell的状态
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let task = tasksManager.unCompletedTasks.safeObjectAtIndex(indexPath.row)
            else { return }
        
        configTask(task: task, cell: cell, visible: false)
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let task = tasksManager.fetchTask(urlStrings[indexPath.row]) {
            if task.status == .suspend {
                tasksManager.start(task.URLString)
            } else if task.status == .running {
                tasksManager.suspend(task.URLString)
            }
        }
    }
}
