//
//  AutoSizeAdjustingCircularView.swift
//  Pods
//
//  Created by Sathya on 8/5/17.
//
//

import Foundation

@IBDesignable
open class AutoSizeAdjustingCircularView: UIView {
    
    @IBInspectable
    open var heightWidth: CGFloat = 10.0 {
        didSet {
            setupView()
        }
    }
    
    open override var intrinsicContentSize : CGSize {
        
        return CGSize(width: heightWidth, height: heightWidth)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = heightWidth / 2
    }
}
