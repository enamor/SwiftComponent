//
//  CCRefreshFooter.swift
//  CCNovel
//
//  Created by zhouen on 2018/10/25.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCRefreshFooter: UIView, CCRefreshControlProtocol {
    /// 隐藏内部属性供kvo状态监听
    @objc private dynamic var observerStatus: Int
    
    var status: RefreshStatus {
        didSet {
            cc_statusChanged()
        }
    }
    
    let maxHeight = 50.0
    let label = UILabel()
    let indicator: UIActivityIndicatorView
    var isRefreshing: Bool
    var refreshBlock: (()->())?
    
    var statusBlock: ((RefreshStatus)->())?
    
    override init(frame: CGRect) {
        self.status = .normal
        self.isRefreshing = false
        
        self.indicator = UIActivityIndicatorView(style: .gray)
        self.observerStatus = Int(self.status.rawValue)
        super.init(frame: frame)
        
        cc_initSubview()
    }
    
    convenience init(refresh block:@escaping () -> () ) {
        self.init()
        
        self.refreshBlock = block
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - override
extension CCRefreshFooter {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.sizeToFit()
        let x = Double((self.frame.width - label.frame.width) / 2.0)
        let h = Double(self.frame.height)
        let w = Double(label.frame.width)
        label.frame = CGRect(x: x, y: 0.0, width: w, height: h)
        indicator.frame = CGRect(x: x - 60.0, y: Double(self.frame.size.height - 40) / 2.0, width: 40, height: 40)
        
    }
}

// MARK: - private
extension CCRefreshFooter {
    private func cc_initSubview() {
        self.addSubview(label)
        
        self.addSubview(indicator)
        
        indicator.isHidden = true
        indicator.color = UIColor.black
        self.addSubview(indicator)
        
        label.text = "加载更多..."
        label.textAlignment = .center
    }
    
    private func cc_statusChanged() {
        self.observerStatus = Int(self.status.rawValue)
        switch self.status {
        case .normal:
            indicator.isHidden = true
            indicator.stopAnimating()
        case .pulling:
            indicator.isHidden = false
        case .refreshing:
            indicator.isHidden = false
            indicator.startAnimating()
            if let refresh = refreshBlock {
                refresh()
            }
        }
    }
    
}
// MARK: - public
extension CCRefreshFooter {
    
    func beginRefreshing() {
        status = .refreshing
    }
    
    func endRefreshing() {
        status = .normal
    }
}
