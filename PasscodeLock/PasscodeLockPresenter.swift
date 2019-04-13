//
//  PasscodeLockPresenter.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/29/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

open class PasscodeLockPresenter {
    
    fileprivate var mainWindow: UIWindow?
    
    fileprivate lazy var passcodeLockWindow: UIWindow = {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.makeKeyAndVisible()
        
        return window
    }()
    
    fileprivate let passcodeConfiguration: PasscodeLockConfigurationType
    open var isPasscodePresented = false
    public let passcodeLockVC: PasscodeLockViewController
    open var successCallback: ((_ lock: PasscodeLockType) -> Void)?
    open var dismissCompletionCallback: (() -> Void)?
    open var helpVC: UIViewController?
    
    public init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType, viewController: PasscodeLockViewController) {
        
        mainWindow = window
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        passcodeConfiguration = configuration
        
        passcodeLockVC = viewController
    }

    public convenience init(mainWindow window: UIWindow?, configuration: PasscodeLockConfigurationType) {
        
        let passcodeLockVC = PasscodeLockViewController(state: .enterPasscode, configuration: configuration)
        
        self.init(mainWindow: window, configuration: configuration, viewController: passcodeLockVC)
    }
    
    open func presentPasscodeLock() {
        
        guard passcodeConfiguration.repository.hasPasscode else { return }
        guard !isPasscodePresented else { return }
        
        isPasscodePresented = true
        
        passcodeLockWindow.windowLevel = UIWindow.Level(rawValue: 2)
        passcodeLockWindow.isHidden = false
        
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        mainWindow?.endEditing(true)
        
        let passcodeLockVC = PasscodeLockViewController(state: .enterPasscode, configuration: passcodeConfiguration)
        passcodeLockVC.successCallback = { lock in
            self.dismissPasscodeLock()
            self.successCallback?(lock)
        }
        passcodeLockVC.dismissCompletionCallback = {
            self.dismissPasscodeLock()
            self.dismissCompletionCallback?()
        }
        passcodeLockVC.helpVC = helpVC
        passcodeLockWindow.rootViewController = passcodeLockVC
    }
    
    open func dismissPasscodeLock(animated: Bool = true) {
        
        isPasscodePresented = false
        mainWindow?.windowLevel = UIWindow.Level(rawValue: 1)
        mainWindow?.makeKeyAndVisible()
        
        if animated {
        
            animatePasscodeLockDismissal()
            
        } else {
            
            passcodeLockWindow.windowLevel = UIWindow.Level(rawValue: 0)
            passcodeLockWindow.rootViewController = nil
        }
    }
    
    internal func animatePasscodeLockDismissal() {
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: { [weak self] in
                
                self?.passcodeLockWindow.alpha = 0
            },
            completion: { [weak self] _ in
                
                self?.passcodeLockWindow.windowLevel = UIWindow.Level(rawValue: 0)
                self?.passcodeLockWindow.rootViewController = nil
                self?.passcodeLockWindow.alpha = 1
            }
        )
    }
    
    open func dismissHelpVC() {
        passcodeLockVC.dismissHelpVC()
    }
}
