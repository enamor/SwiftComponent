//
//  CCPageBarView.swift
//  SwiftComponent
//
//  Created by zhouen on 2018/10/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit
protocol CCPageBarViewDelegate:AnyObject {
    func pageBar(didSelected index:Int)
}

class CCPageBarView: UIView {
    weak var delegate: CCPageBarViewDelegate?
    
    /** 字体大小 */
    var textColor: UIColor
    /** 字体大小 */
    var font: UIFont
    /** 标签选中颜色 */
    var selectColor: UIColor
    /** 标签指示器颜色 */
    var indicatorColor: UIColor
    /** 标签指示器高度 */
    var indicatorHeight: CGFloat
    /** item之间间隔 */
    var margin: CGFloat
    /** 字体本身宽度额外增加的宽度 */
    var extraWidth: CGFloat
    
    let indicator: UILabel
    
    var selectItem:CCPageBarLabel?
    
    var items: [String]? {
        didSet {
            cc_fillData()
        }
    }
    
    var labelItems = [CCPageBarLabel]()
    
    override init(frame: CGRect) {
        self.textColor = UIColor.gray
        self.font = UIFont.systemFont(ofSize: 14)
        self.selectColor = UIColor.black
        self.indicatorColor = UIColor.black
        self.indicatorHeight = 2.0
        self.margin = 10
        self.extraWidth = 10;
        self.indicator = UILabel();
        
        super.init(frame: frame)
        
        
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func cc_fillData() {
        guard let items = items else { return }
        indicator.backgroundColor = indicatorColor
        
        var left = (self.frame.width - margin * CGFloat(items.count) - totalWith()) / 2.0
        for (index,title) in items.enumerated() {
            let label = CCPageBarLabel(font: font, color: textColor)
            label.text = title
            label.tag = index
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.itemAction(recognizer:)))
            label.addGestureRecognizer(tap)
            self.addSubview(label)
            labelItems.append(label)
            
            let width = label.cc_getWidth(by: extraWidth)
            label.frame = CGRect(x: left, y: 0, width: width, height: self.frame.height)
            
            left += (width + margin)
            
            if index == 0 {
                label.textColor = selectColor;
                self.addSubview(indicator)
                var rect = label.frame
                rect.origin.y = self.frame.height - indicatorHeight
                rect.size.height = indicatorHeight;
                indicator.frame = rect;
                
                selectItem = label;
            }
        }
    }
    
    
    
    private func totalWith() -> CGFloat {
        guard let items = items else { return 0 }
        
        var width:CGFloat = 0
        for title in items {
            width += title.size(withAttributes: [NSAttributedString.Key.font: font]).width + extraWidth
        }
        
        return width
    }
    
    @objc func itemAction(recognizer: UITapGestureRecognizer)  {
        let item = recognizer.view as! CCPageBarLabel
        changeIndicator(by: item)
        
        if let delegate = delegate {
            delegate.pageBar(didSelected: item.tag)
        }
    }
    
    
    func scroll(to index: Int) {
        let item = labelItems[index]
        changeIndicator(by: item)
    }
    
    // MARK: 改变指示器位置
    func changeIndicator(by item:CCPageBarLabel) {
        selectItem?.textColor = textColor
        item.textColor = selectColor
        selectItem = item
        
        var rect = item.frame
        rect.origin.y = self.frame.height - indicatorHeight
        rect.size.height = indicatorHeight;
        
        UIView.animate(withDuration: 0.3) {
            self.indicator.frame = rect
        }
    }
    
    

}

class CCPageBarLabel: UILabel {
    convenience init(font: UIFont, color: UIColor){
        self.init()
        self.textAlignment = .center
        self.textColor = color
        self.font = font
        self.isUserInteractionEnabled = true
    }
    
    func cc_getWidth(by extraWidth:CGFloat) -> CGFloat {
        guard let text = self.text else {
            return 0
        }
        return text.size(withAttributes: [NSAttributedString.Key.font: font]).width + extraWidth
    }
}
