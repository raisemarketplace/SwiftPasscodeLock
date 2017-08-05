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
