//
//  PasscodeNumberLabel.swift
//  Pods
//
//  Created by Sathya on 8/5/17.
//
//

import UIKit

@IBDesignable
open class PasscodeNumberLabel: UILabel {
    
    @IBInspectable
    open var fontSize: CGFloat = 10 {
        didSet {
            setupView()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        self.font = UIFont(descriptor: self.font.fontDescriptor, size: fontSize / 375 * UIScreen.main.bounds.width)
    }
}
