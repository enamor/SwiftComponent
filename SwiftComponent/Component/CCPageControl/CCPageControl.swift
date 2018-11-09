//
//  CCPageControl.swift
//  SwiftComponent
//
//  Created by zhouen on 2018/10/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

protocol CCPageControlDelegate: AnyObject {
    func numberOfPageInPageControl(_ pageControl: CCPageControl) -> Int
    
    func pageControl(_ pageControl: CCPageControl, itemForRowAt index: Int) -> UIView
}


class CCPageControl: UIView,UICollectionViewDelegate,UICollectionViewDataSource,CCPageBarViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let delegate = delegate {
            return delegate.numberOfPageInPageControl(self)
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        for lastItem in cell.contentView.subviews {
            lastItem.removeFromSuperview()
        }
        
        if let view = cashs[String(indexPath.row)] {
            view.frame = cell.bounds
            cell.addSubview(view)
        } else {
            if let delegate = delegate {
                let view = delegate.pageControl(self, itemForRowAt: indexPath.row)
                
                view.frame = cell.bounds
                cell.addSubview(view)
                cashs[String(indexPath.row)] = view
            }
        }
        
        return cell;
    }
    
    
    // MARK:CCPageBarViewDelegate
    func pageBar(didSelected index: Int) {
        collectionView?.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView?.frame = self.bounds;
        flowLayout?.itemSize = self.bounds.size;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(scrollView === collectionView) {
            let index = scrollView.contentOffset.x / scrollView.frame.size.width;
            self.pageBar?.scroll(to: Int(index))
        }
    }
    
    weak open var delegate: CCPageControlDelegate?

    var pageBar: CCPageBarView? {
        didSet {
            pageBar?.delegate = self
        }
    }
    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    let reuseIdentifier = "CCPageControlCell"
    
    var cashs = [String:UIView]()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        cc_initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cc_initSubview() {
        
        flowLayout = UICollectionViewFlowLayout()
        guard let flowLayout = flowLayout  else {
            return
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.addSubview(collectionView!)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.bounces = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        
        // 设置cell的大小和细节
        flowLayout.itemSize = collectionView!.bounds.size
        flowLayout.scrollDirection = .horizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        collectionView!.isPagingEnabled = true
        collectionView!.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
}
