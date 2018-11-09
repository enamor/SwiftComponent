//
//  CCRefreshControl.swift
//  CCNovel
//
//  Created by zhouen on 2018/10/25.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import Foundation
import UIKit

 var cc_headerRefreshControl = 100
 var cc_footerRefreshControl = 200

private var header = 0
private var footer = 1

extension UIScrollView {

    var cc_header: CCRefreshHeader? {
        set {
            objc_setAssociatedObject(self, &cc_headerRefreshControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if let cc_header = cc_header {
                self.addSubview(cc_header)
                
                let height = cc_header.maxHeight
                let width = Double(self.bounds.size.width)
                cc_header.frame = CGRect(x: 0.0, y: -height, width: width, height: height)
                
                
                cc_header.addObserver(self, forKeyPath: "observerStatus", options: .new, context: &header)
                
                //.normal 回调
//                cc_header.statusBlock = {(obj_bolck:RefreshStatus) in
//                    self.contentInset.top = 0
//                }
            }
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &cc_headerRefreshControl) as? CCRefreshHeader {
                return rs
            }
            return nil
        }
    }
    
    var cc_footer: CCRefreshFooter? {
        set {
            objc_setAssociatedObject(self, &cc_footerRefreshControl, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            if let cc_footer = cc_footer {
                self.addSubview(cc_footer)
                
                cc_footer.addObserver(self, forKeyPath: "observerStatus", options: .new, context: &footer)
            }
        }
        
        get {
            if let rs = objc_getAssociatedObject(self, &cc_footerRefreshControl) as? CCRefreshFooter {
                return rs
            }
            return nil
        }
    }
    
}

// MARK: override
extension UIScrollView {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }

    override open func removeFromSuperview() {
        super.removeFromSuperview()
        self.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let cc_header = cc_header {
            let height = cc_header.maxHeight
            let width = Double(self.bounds.size.width)
            cc_header.frame = CGRect(x: 0.0, y: -height, width: width, height: height)
        }
    }
    
}

// MARK: 滑动监听
extension UIScrollView {
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &header {
            if let newValue = change?[.newKey] as? Int {
                if newValue == 0 {
                    UIView.animate(withDuration: 0.25) {
                        self.contentInset.top = 0
                    }
                }
            }
        }
        
        if context == &footer {
            if let newValue = change?[.newKey] as? Int {
                if newValue == 0 {
                    UIView.animate(withDuration: 0.25) {
                        self.contentInset.bottom = 0
                    }
                }
            }
        }

        guard let _ = cc_header else { return }
        //丝滑处理
        let offSet = self.contentOffset.y
        let scrollHeight = self.bounds.size.height
        let inset = self.contentInset
        
        var currentOffset = offSet + scrollHeight - inset.bottom
        let maximumOffset = self.contentSize.height
        
        
        /** 数据未充满屏幕的情况 **/
        var isFull = true
        if maximumOffset < scrollHeight {
            currentOffset = offSet + maximumOffset - inset.bottom
            isFull = false
        }
        
        if offSet < 0 {
            /** 下拉刷新 */
            headerRefresh()
            
            
        }else if currentOffset - maximumOffset > 0 {
            /** 上拉加载 */
            print("下 \(currentOffset - maximumOffset)")
            
            guard let cc_footer = cc_footer else { return }
            let height = cc_footer.maxHeight
            let width = Double(self.bounds.size.width)
            let y = Double(self.bounds.size.height)
            cc_footer.frame = CGRect(x: 0.0, y: y, width: width, height: height)
            
            //内容未占满屏幕
            if maximumOffset < self.bounds.size.height {
                cc_footer.frame.origin.y = self.bounds.size.height
            } else {
                cc_footer.frame.origin.y = maximumOffset
            }
        
            footerRefresh(isFull)
            
            
        }else{
            
        }
    }
}


extension UIScrollView {
    func headerRefresh() {
        guard let cc_header = cc_header else { return }
        
        if cc_header.status == .refreshing {
            return
        }
        
        let contentOffsetY =  Double(self.contentOffset.y)
        
        if self.isDragging {//未松手
            if contentOffsetY > -cc_header.maxHeight && cc_header.status == .pulling{
                cc_header.status = .normal
            }else if contentOffsetY <= -cc_header.maxHeight && cc_header.status == .normal{
                cc_header.status = .pulling
            }
            
        }else {//松手
            if cc_header.status == .pulling{
                cc_header.status = .refreshing
                
                UIView.animate(withDuration: 0.3) {
                    self.contentInset.top = CGFloat(cc_header.maxHeight)
                }
                
                
            } else if cc_header.status == .normal {
                UIView.setAnimationCurve(.easeOut)
                UIView.animate(withDuration: 0.3) {
                    self.contentInset.top = 0
                }
            } else if cc_header.status == .refreshing {
                
                UIView.animate(withDuration: 0.3) {
                    self.contentInset.top = CGFloat(cc_header.maxHeight)
                }
            }
            
        }
    }
    
    
    
    func footerRefresh(_ isFull: Bool){
        
        guard let cc_footer = cc_footer else {
            return
        }
        
        if cc_footer.status == .refreshing {
            return
        }
 
        if self.isDragging {//未松手
            if cc_footer.status == .normal {
                cc_footer.status = .pulling
            }
            
        }else {//松手
            if cc_footer.status == .pulling{
                cc_footer.status = .refreshing
                UIView.animate(withDuration: 0.3) {
                    
                    if isFull {
                        self.contentInset.bottom = CGFloat(cc_footer.maxHeight)
                    } else {
                        let bt = self.bounds.size.height - self.contentSize.height + CGFloat(cc_footer.maxHeight)
                        self.contentInset.bottom = bt
                    }
                    
                }
                
            } else if cc_footer.status == .normal {
                UIView.animate(withDuration: 0.3) {
                    self.contentInset.bottom = 0
                }
            } else if cc_footer.status == .refreshing {
                
                UIView.animate(withDuration: 0.3) {
                    if isFull {
                        self.contentInset.bottom = CGFloat(cc_footer.maxHeight)
                    } else {
                        let bt = self.bounds.size.height - self.contentSize.height + CGFloat(cc_footer.maxHeight)
                        self.contentInset.bottom = bt
                    }
                }
            }
            
        }
    }
    
        
}
