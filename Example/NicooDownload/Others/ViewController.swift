//
//  ViewController.swift
//  NicooDownload
//
//  Created by 504672006@qq.com on 09/27/2018.
//  Copyright (c) 2018 504672006@qq.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static let cellId = "ViewControllerCell"
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: self.view.bounds, style: .plain)
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 60
        table.tableFooterView = UIView()
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: ViewController.cellId)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewController.cellId, for: indexPath)
        cell.textLabel?.text = ["多选单选下载", "单个任务追加下载", "已下载目录"][indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            let choseVC = ChoseTasksViewController()
            navigationController?.pushViewController(choseVC, animated: true)
        }
        
        if indexPath.row == 1 {
            
        }
        
        if indexPath.row == 2 {
            let filevc = FileViewController()
            navigationController?.pushViewController(filevc, animated: true)
        }
    }
}
