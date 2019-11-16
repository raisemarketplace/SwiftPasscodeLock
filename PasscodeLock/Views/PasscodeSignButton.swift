//
//  PasscodeSignButton.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

@IBDesignable
open class PasscodeSignButton: UIButton {
    
    @IBInspectable
    open var passcodeSign: Int = 1
    
    @IBInspectable
    open var borderColor: UIColor = UIColor.white {
        didSet {
            setupView()
        }
    }
    
    @IBInspectable
    open var borderRadius: CGFloat {
        get {
            return frame.width / 2
        }
    }
    
    @IBInspectable
    open var highlightBackgroundColor: UIColor = UIColor.clear {
        didSet {
            setupView()
        }
    }
    
    open override var intrinsicContentSize : CGSize {
        return CGSize(width: frame.size.width, height: frame.size.width)
    }
    
    fileprivate var defaultBackgroundColor = UIColor.clear
    
    fileprivate func setupView() {
        
        layer.borderWidth = 1
        layer.cornerRadius = borderRadius
        layer.borderColor = borderColor.cgColor
        
        if let backgroundColor = backgroundColor {
            
            defaultBackgroundColor = backgroundColor
        }
    }
    
    fileprivate func setupActions() {
        
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchDown), for: .touchDown)
        addTarget(self, action: #selector(PasscodeSignButton.handleTouchUp), for: [.touchUpInside, .touchDragOutside, .touchCancel])
    }
    
    @objc func handleTouchDown() {
        
        animateBackgroundColor(highlightBackgroundColor)
    }
    
    @objc func handleTouchUp() {
        
        animateBackgroundColor(defaultBackgroundColor)
    }
    
    fileprivate func animateBackgroundColor(_ color: UIColor) {
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0.0,
            options: [.allowUserInteraction, .beginFromCurrentState],
            animations: {
                
                self.backgroundColor = color
            },
            completion: nil
        )
    }
}
