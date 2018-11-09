//
//  CCDownloadViewController.swift
//  CCNovel
//
//  Created by zhouen on 2018/10/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCBookItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    
    let reuseIdentifier = "CCPageControlCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cc_initSubview()
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = UIColor.red
        } else {
            cell.backgroundColor = UIColor.blue
        }
        
        return cell
    }

    func cc_initSubview() {
        
        flowLayout = UICollectionViewFlowLayout()
        guard let flowLayout = flowLayout  else {
            return
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.view.addSubview(collectionView!)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.bounces = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        let width = (self.view.frame.size.width - 40 - 36) / 3.0
        let height = (246.0 * width / 193.0) + 30
        // 设置cell的大小和细节
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.scrollDirection = .vertical;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 18, bottom: 20, right: 18)
        collectionView!.showsVerticalScrollIndicator = false;
        
        collectionView?.frame = self.view.bounds
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
}
