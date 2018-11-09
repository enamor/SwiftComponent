//
//  CCPageControlTestController.swift
//  SwiftComponent
//
//  Created by zhouen on 2018/10/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCPageControlTestController: UIViewController,CCPageControlDelegate {
    
    func numberOfPageInPageControl(_ pageControl: CCPageControl) -> Int {
        return pageBar?.items?.count ?? 0
    }
    
    func pageControl(_ pageControl: CCPageControl, itemForRowAt index: Int) -> UIView {
        let view = UIView()
        if index % 2 == 0 {
            view.backgroundColor = UIColor.red
        } else {
            view.backgroundColor = UIColor.gray
        }
        return view
    }
    

    var pageBar: CCPageBarView?
    var pageControl: CCPageControl?


    
    override func viewDidLoad() {
        super.viewDidLoad()

        cc_initSubview()
        // Do any additional setup after loading the view.
    }
    

    func cc_initSubview() {
        pageBar = CCPageBarView(frame: CGRect(x: 0, y: 0, width: 200, height: 44));
        pageBar?.items = ["我的下载","推荐书籍"]
        
        self.navigationItem.titleView = pageBar;
        
        pageControl = CCPageControl(frame: self.view.bounds)
        pageControl?.delegate = self
        pageControl?.pageBar = pageBar
        self.view.addSubview(pageControl!)
        
    }
    
    deinit {
        print("xxx");
    }

}
