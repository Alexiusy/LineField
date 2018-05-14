//
//  RiseTextField.swift
//  TextFieldDemo
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 zeacone. All rights reserved.
//

import UIKit


class LineField: UITextField {
    
    
    /// Placeholder's text color on normal state
    var tipsColorNomal = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    
    /// Placeholder's text color on editing state
    var tipsColorFocused = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
    
    /// Bottom line's color on normal state
    var lineColorNormal = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    /// Bottom line's color on editing state
    var lineColorFocused = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    
    
    lazy var placeholderLabel: UILabel! = {
        
        let label = UILabel()
        
        label.textColor = self.tipsColorNomal
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        let size = CGSize(width: self.bounds.width, height: label.font.lineHeight)
        let offsetY = self.bounds.height - size.height
        label.frame.origin = CGPoint(x: 0, y: offsetY)
        label.frame.size = size
        
        return label
    }()
    
    // MARK: Initialize method
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.defaultAppearance()
    }
    
    func defaultAppearance() {
        
        self.contentVerticalAlignment = .bottom
        self.borderStyle = .none
        self.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.addSubview(self.placeholderLabel)
        
        self.addNotification()
    }
    
    func addNotification() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(beginEditing(_:)), name: .UITextFieldTextDidBeginEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(endedEditing(_:)), name: .UITextFieldTextDidEndEditing, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_:)), name: .UITextFieldTextDidChange, object: self)
    }
    
    // MARK: Override method
    
    /// 绘制placeholder
    /// 当placeholder不存在时，不进行赋值
    ///
    /// - Parameter rect: 原placeholder的绘制范围
    override func drawPlaceholder(in rect: CGRect) {
        
        guard let _ = self.placeholder else { return }
        
        self.placeholderLabel.text = self.placeholder
        
        if let view = self.leftView {
            self.placeholderLabel.frame.origin.x += view.frame.maxX
        }
    }
    
    /// 当存在text时，drawPlaceholder将不会被调用，因此需要在此处对placeholderLabel赋值，并且执行上浮动画
    ///
    /// - Parameter rect: 原text的绘制范围
    override func drawText(in rect: CGRect) {
        
        super.drawText(in: rect)
        
        guard let _ = self.text else { return }
        
        self.placeholderLabel.text = self.placeholder
        
        execAnimation(self.isEditing)
    }
    
    func execAnimation(_ focused: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            
            self.placeholderLabel.textColor = focused ? self.tipsColorFocused : self.tipsColorNomal
            self.setNeedsDisplay()
            
            // 防止在UITextField高度过高的时候，placeholder label偏离太远
            var offsetY: CGFloat = max(-(self.placeholderLabel.bounds.height / 2), (self.bounds.height - self.font!.lineHeight - self.placeholderLabel.bounds.height - 5))
            
            if !focused && self.text?.count == 0 {
                offsetY = (self.bounds.height - self.placeholderLabel.bounds.height)
            }
            
            self.placeholderLabel.frame.origin.y = offsetY
        }
    }
    
    
    // MARK: Respond method
    /// 开始动画
    @objc func beginEditing(_ noti: Notification) {
        execAnimation(true)
    }
    
    /// 结束动画
    @objc func endedEditing(_ noti: Notification) {
        execAnimation(false)
    }
    
    /// 需要在编辑过程中执行的动画
    @objc func textChanged(_ noti: Notification) {
        execAnimation(true)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = self.leftView!.bounds.size
        return CGRect(x: 5, y: self.bounds.height - size.height, width: size.width, height: size.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let size = self.leftView!.bounds.size
        return CGRect(x: self.bounds.width - size.width - 5, y: self.bounds.height - size.height, width: size.width, height: size.height)
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setLineWidth(2)
        ctx?.setStrokeColor(self.isEditing ? self.lineColorFocused.cgColor : self.lineColorNormal.cgColor)
        
        var points = [CGPoint]()
        points.append(CGPoint(x: 0, y: self.bounds.maxY))
        points.append(CGPoint(x: self.bounds.width, y: self.bounds.maxY))
        
        ctx?.addLines(between: points)
        ctx?.drawPath(using: .stroke)
        
        super.draw(rect)
    }
}
