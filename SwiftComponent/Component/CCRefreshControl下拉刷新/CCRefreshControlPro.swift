//
//  CCRefreshControlPro.swift
//  CCNovel
//
//  Created by zhouen on 2018/10/25.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

enum RefreshStatus:Int {
    case normal = 0
    case pulling = 1
    case refreshing = 2
}

protocol CCRefreshControlProtocol {
    var isRefreshing: Bool { get }
    var status: RefreshStatus { get  set}
    
    func beginRefreshing()
    func endRefreshing()
}
