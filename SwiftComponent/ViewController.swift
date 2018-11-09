//
//  ViewController.swift
//  SwiftComponent
//
//  Created by zhouen on 2018/10/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
    let reuseIdentifier = "ReuseIdentifier"
    var tableView:UITableView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cc_initSubview()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "标签在导航栏的滚动视图"
        }
        
        if indexPath.row == 1 {
            cell.textLabel?.text = "Collectionview的使用"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(CCPageControlTestController(), animated: true)
        }
        
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(CCBookItemViewController(), animated: true)
        }
    }
    
    
    func cc_initSubview() {
        tableView = UITableView(frame: self.view.bounds, style:.grouped)
        tableView?.frame.origin.y = 88
        tableView?.frame.size.height = self.view.frame.size.height - 88 - 83
        tableView?.delegate = self
        tableView?.dataSource = self
        self.view.addSubview(tableView!)
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        let cc_header = CCRefreshHeader(refresh: {
            [unowned self] in
            
            let time: TimeInterval = 3.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //code
                self.tableView?.cc_header?.endRefreshing()
            }
            
            
            //正在加载
        })
        tableView?.cc_header = cc_header
        tableView?.cc_footer = CCRefreshFooter(refresh: {
            [unowned self] in
            
            let time: TimeInterval = 3.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //code
                self.tableView?.cc_footer?.endRefreshing()
            }
        })
        
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

}

