//
//  CCRefreshHeader.swift
//  CCNovel
//
//  Created by zhouen on 2018/10/25.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCRefreshHeader: UIView , CCRefreshControlProtocol {
    
    /// 隐藏内部属性供kvo状态监听
    @objc private dynamic var observerStatus: Int
    var status: RefreshStatus {
        didSet {
            cc_statusChanged()
        }
    }

    let maxHeight = 50.0
    let label = UILabel()
    let indicator = UIImageView()
    let indicatorView: UIActivityIndicatorView
    var isRefreshing: Bool
    var refreshBlock: (()->())?
    
    var statusBlock: ((RefreshStatus)->())?
    
    override init(frame: CGRect) {
        self.status = .normal
        self.isRefreshing = false
        
        self.indicatorView = UIActivityIndicatorView(style: .gray)
    
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
extension CCRefreshHeader {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = UIScreen.main.bounds.width
        let height = maxHeight
        label.sizeToFit()
        let x = Double((width - label.frame.width) / 2.0)
        let h = Double(height)
        let w = Double(label.frame.width)
        label.frame = CGRect(x: x, y: 0.0, width: w, height: h)
        indicator.frame = CGRect(x: x - 60.0, y: Double(height - 40) / 2.0, width: 40, height: 40)
        
        indicatorView.frame = indicator.frame
    }
}

// MARK: - private
extension CCRefreshHeader {
    private func cc_initSubview() {
        self.addSubview(label)
        
        indicator.image = UIImage(named: "cc_refresh_arrow")
        self.addSubview(indicator)
        
        indicatorView.isHidden = true
        indicatorView.color = UIColor.black
        
        self.addSubview(indicatorView)
        
        label.text = "下拉刷新"
        label.textAlignment = .center
    }
    
    private func cc_statusChanged() {
        
        self.observerStatus = Int(status.rawValue)
        
        switch self.status {
        case .normal:
            indicatorView.isHidden = true
            indicator.isHidden = false
            indicatorView.stopAnimating()
            indicator.transform = CGAffineTransform.identity
            label.text = "下拉刷新"
        case .pulling:
            label.text = "松开刷新"
            UIView.animate(withDuration: 0.2) {
                self.indicator.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
            
        case .refreshing:
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            indicator.isHidden = true
            label.text = "加载中..."
            
            if let refresh = refreshBlock {
                refresh()
            }
        }
    }
    
}
// MARK: - public
extension CCRefreshHeader {

    func beginRefreshing() {
        status = .refreshing
    }
    
    func endRefreshing() {
        
        if let statusBlock = statusBlock {
            statusBlock(.normal)
        }
        status = .normal
    }
}
