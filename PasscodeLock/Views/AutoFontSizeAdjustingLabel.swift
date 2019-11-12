//
//  AutoFontSizeAdjustingLabel.swift
//  Pods
//
//  Created by Sathya on 8/5/17.
//
//

import UIKit

@IBDesignable
open class AutoFontSizeAdjustingLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        font = UIFont(descriptor: font.fontDescriptor, size: font.pointSize / 375 * UIScreen.main.bounds.width)
    }
}

open class AutoFontSizeAdjustingButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        guard let font = titleLabel?.font else { return }
        titleLabel?.font = UIFont(descriptor: font.fontDescriptor, size: font.pointSize / 414 * UIScreen.main.bounds.width)
    }
}
