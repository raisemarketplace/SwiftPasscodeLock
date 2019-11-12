//
//  PasscodeLockViewController.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import UIKit

open class PasscodeLockViewController: UIViewController, PasscodeLockTypeDelegate {
    
    public enum LockState {
        case getPasscode
        case enterPasscode
        case setPasscode
        case changePasscode
        case removePasscode
        
        func getState() -> PasscodeLockStateType {
            
            switch self {
            case .getPasscode: return GetPasscodeState()
            case .enterPasscode: return EnterPasscodeState()
            case .setPasscode: return SetPasscodeState()
            case .changePasscode: return ChangePasscodeState()
            case .removePasscode: return EnterPasscodeState(allowCancellation: true)
            }
        }
    }
    
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var infoButton: UIButton!
    @IBOutlet open var placeholders: [PasscodeSignPlaceholderView] = [PasscodeSignPlaceholderView]()
    @IBOutlet open weak var deleteCancelButton: UIButton!
    @IBOutlet open weak var touchIDButton: UIButton!
    @IBOutlet open weak var placeholdersX: NSLayoutConstraint!
    
    @IBOutlet open weak var vSpaceLabelAndDots: NSLayoutConstraint!
    
    @IBOutlet open weak var hDotSpace1And2: NSLayoutConstraint!
    @IBOutlet open weak var hDotSpace2And3: NSLayoutConstraint!
    @IBOutlet open weak var hDotSpace3And4: NSLayoutConstraint!
    
    @IBOutlet open weak var vSpace2ANd5: NSLayoutConstraint!
    @IBOutlet open weak var vSpace5And8: NSLayoutConstraint!
    @IBOutlet open weak var vSpace8And0: NSLayoutConstraint!
    @IBOutlet open weak var hSpace1And2: NSLayoutConstraint!
    @IBOutlet open weak var hSpace2And3: NSLayoutConstraint!
    
    @IBOutlet open weak var v2: NSLayoutConstraint!
    @IBOutlet open weak var v3: NSLayoutConstraint!
    @IBOutlet open weak var v4: NSLayoutConstraint!
    @IBOutlet open weak var v5: NSLayoutConstraint!
    @IBOutlet open weak var v6: NSLayoutConstraint!
    @IBOutlet open weak var v7: NSLayoutConstraint!
    @IBOutlet open weak var v8: NSLayoutConstraint!
    @IBOutlet open weak var v9: NSLayoutConstraint!
    
    @IBOutlet open weak var vAbc: NSLayoutConstraint!
    @IBOutlet open weak var vDef: NSLayoutConstraint!
    @IBOutlet open weak var vGhi: NSLayoutConstraint!
    @IBOutlet open weak var vJkl: NSLayoutConstraint!
    @IBOutlet open weak var vMno: NSLayoutConstraint!
    @IBOutlet open weak var vPqrs: NSLayoutConstraint!
    @IBOutlet open weak var vTuv: NSLayoutConstraint!
    @IBOutlet open weak var vWxyz: NSLayoutConstraint!
    
    @IBOutlet open weak var touchIDButtonBottom: NSLayoutConstraint!
    @IBOutlet open weak var deleteButtonBottom: NSLayoutConstraint!
    
    open var getPasscodeBlock: ((_ passcode: [Int]) -> Void)?
    open var successCallback: ((_ lock: PasscodeLockType) -> Void)?
    open var dismissCompletionCallback: (()->Void)?
    open var helpVC: UIViewController?
    open var animateOnDismiss: Bool
    open var notificationCenter: NotificationCenter?
    
    internal let passcodeConfiguration: PasscodeLockConfigurationType
    internal var passcodeLock: PasscodeLockType
    internal var isPlaceholdersAnimationCompleted = true
    
    fileprivate var shouldTryToAuthenticateWithBiometrics = true
    
    // MARK: - Initializers
    
    public init(nibName: String?, bundle: Bundle?, state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        self.animateOnDismiss = animateOnDismiss
        
        passcodeConfiguration = configuration
        passcodeLock = PasscodeLock(state: state, configuration: configuration)

        super.init(nibName: nibName, bundle: bundle)
        passcodeLock.delegate = self
        notificationCenter = NotificationCenter.default
    }
    
    public convenience init(state: PasscodeLockStateType, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        let nibName = "PasscodeLockView"
        let bundle: Bundle = bundleForResource(nibName, ofType: "nib")
        self.init(nibName: nibName, bundle: bundle, state: state, configuration: configuration, animateOnDismiss: animateOnDismiss)
    }
    
    public convenience init(nibName: String?, bundle: Bundle?, state: LockState, configuration: PasscodeLockConfigurationType, animateOnDismiss: Bool = true) {
        self.init(nibName: nibName, bundle: bundle, state: state.getState(), configuration: configuration, animateOnDismiss: animateOnDismiss)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        clearEvents()
    }
    
    // MARK: - View
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        updateConstraint()
        updatePasscodeView()
        deleteCancelButton?.setTitle("Cancel", for: .normal)
        
        setupEvents()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldTryToAuthenticateWithBiometrics {
        
            authenticateWithBiometrics()
        }
    }
    
    private func updateConstraint() {
        let ratio = UIScreen.main.bounds.height / 667
        
        vSpaceLabelAndDots.constant = vSpaceLabelAndDots.constant * ratio
        
        hDotSpace1And2.constant = hDotSpace1And2.constant * ratio
        hDotSpace2And3.constant = hDotSpace2And3.constant * ratio
        hDotSpace3And4.constant = hDotSpace3And4.constant * ratio
        
        vSpace2ANd5.constant = vSpace2ANd5.constant * ratio
        vSpace5And8.constant = vSpace5And8.constant * ratio
        vSpace8And0.constant = vSpace8And0.constant * ratio
        
        hSpace1And2.constant = hSpace1And2.constant * ratio
        hSpace2And3.constant = hSpace2And3.constant * ratio
        
        v2.constant = v2.constant * ratio
        v3.constant = v3.constant * ratio
        v4.constant = v4.constant * ratio
        v5.constant = v5.constant * ratio
        v6.constant = v6.constant * ratio
        v7.constant = v7.constant * ratio
        v8.constant = v8.constant * ratio
        v9.constant = v9.constant * ratio
        
        vAbc.constant = vAbc.constant * ratio
        vDef.constant = vDef.constant * ratio
        vGhi.constant = vGhi.constant * ratio
        vJkl.constant = vJkl.constant * ratio
        vMno.constant = vMno.constant * ratio
        vPqrs.constant = vPqrs.constant * ratio
        vTuv.constant = vTuv.constant * ratio
        vWxyz.constant = vWxyz.constant * ratio
        
        touchIDButtonBottom.constant = touchIDButtonBottom.constant * ratio
        deleteButtonBottom.constant = deleteButtonBottom.constant * ratio
    }
    
    internal func updatePasscodeView() {
        
        titleLabel?.text = passcodeLock.state.title
        deleteCancelButton.isHidden = !passcodeLock.state.isCancellableAction
        touchIDButton?.isHidden = !passcodeLock.isTouchIDAllowed
    }
    
    // MARK: - Events
    
    fileprivate func setupEvents() {
        
        notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appWillEnterForegroundHandler(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter?.addObserver(self, selector: #selector(PasscodeLockViewController.appDidEnterBackgroundHandler(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    fileprivate func clearEvents() {
        
        notificationCenter?.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        notificationCenter?.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc open func appWillEnterForegroundHandler(_ notification: Notification) {
        
        authenticateWithBiometrics()
    }
    
    @objc open func appDidEnterBackgroundHandler(_ notification: Notification) {
        
        shouldTryToAuthenticateWithBiometrics = false
    }
    
    // MARK: - Actions
    
    @IBAction func whatsThisButtonTap(_ sender: UIButton) {
        let title = localizedStringFor("What's this? Title", comment: "Title")
        let message = localizedStringFor("What's this? Message", comment: "Message")
        let button1 = localizedStringFor("What's this? button1", comment: "Button 1")
        let button2 = localizedStringFor("What's this? button2", comment: "Button 2")
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertVC.addAction(UIAlertAction(title: button1, style: .cancel, handler: { action in
            if let helpVC = self.helpVC {
                self.present(helpVC, animated: true, completion: nil)
            }
        }))
        alertVC.addAction(UIAlertAction(title: button2, style: .default, handler: nil))
        alertVC.view.tintColor = passcodeConfiguration.tintColor
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func passcodeSignButtonTap(_ sender: PasscodeSignButton) {
        
        guard isPlaceholdersAnimationCompleted else { return }
        
        passcodeLock.addSign(sender.passcodeSign)
    }
    
    @IBAction func deleteSignButtonTap(_ sender: UIButton) {
        
        if let buttonTitle = deleteCancelButton.titleLabel?.text, buttonTitle == "Cancel" {
            dismissPasscodeLock(passcodeLock, success: false)
        } else {
            passcodeLock.removeSign()
        }
    }
    
    @IBAction func touchIDButtonTap(_ sender: UIButton) {
        
        passcodeLock.authenticateWithBiometrics()
    }
    
    fileprivate func authenticateWithBiometrics() {
        
        if passcodeConfiguration.shouldRequestTouchIDImmediately && passcodeLock.isTouchIDAllowed {
            
            passcodeLock.authenticateWithBiometrics()
        }
    }
    
    internal func dismissPasscodeLock(_ lock: PasscodeLockType, success: Bool) {
        
        // if presented as modal
        if presentingViewController?.presentedViewController == self {
            
            dismiss(animated: animateOnDismiss, completion: {
                
                if success {
                    self.successCallback?(lock)
                } else {
                    self.dismissCompletionCallback?()
                }
            })
            
            return
            
        // if pushed in a navigation controller
        } else if navigationController != nil {
        
            navigationController?.popViewController(animated: animateOnDismiss)
        }
        
        if success {
            self.successCallback?(lock)
        } else {
            self.dismissCompletionCallback?()
        }
    }
    
    // MARK: - Animations
    
    internal func animateWrongPassword() {
        
        deleteCancelButton?.setTitle("Cancel", for: .normal)
        isPlaceholdersAnimationCompleted = false
        
        animatePlaceholders(placeholders, toState: .error)
        
        placeholdersX?.constant = -40
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                
                self.placeholdersX?.constant = 0
                self.view.layoutIfNeeded()
            },
            completion: { completed in
                
                self.isPlaceholdersAnimationCompleted = true
                self.animatePlaceholders(self.placeholders, toState: .inactive)
        })
    }
    
    internal func animatePlaceholders(_ placeholders: [PasscodeSignPlaceholderView], toState state: PasscodeSignPlaceholderView.State) {
        
        for placeholder in placeholders {
            
            placeholder.animateState(state)
        }
    }
    
    fileprivate func animatePlacehodlerAtIndex(_ index: Int, toState state: PasscodeSignPlaceholderView.State) {
        
        guard index < placeholders.count && index >= 0 else { return }
        
        placeholders[index].animateState(state)
    }

    // MARK: - PasscodeLockDelegate
    
    open func passcodeLockDidSucceed(_ lock: PasscodeLockType) {
        
        deleteCancelButton?.setTitle("Delete", for: .normal)
        animatePlaceholders(placeholders, toState: .inactive)
        dismissPasscodeLock(lock, success: true)
    }
    
    open func passcodeLockDidFail(_ lock: PasscodeLockType) {
        
        animateWrongPassword()
    }
    
    open func passcodeLockDidChangeState(_ lock: PasscodeLockType) {
        
        updatePasscodeView()
        animatePlaceholders(placeholders, toState: .inactive)
        deleteCancelButton?.setTitle("Cancel", for: .normal)
    }
    
    open func passcodeLock(_ lock: PasscodeLockType, addedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .active)
        deleteCancelButton?.setTitle("Delete", for: .normal)
    }
    
    open func passcodeLock(_ lock: PasscodeLockType, removedSignAtIndex index: Int) {
        
        animatePlacehodlerAtIndex(index, toState: .inactive)
        
        if index == 0 {
            deleteCancelButton?.setTitle("Cancel", for: .normal)
        }
    }
    
    open func passcodeEntered(_ passcode: [Int]) {
        
        getPasscodeBlock?(passcode)
    }
    
    open func dismissHelpVC() {
        helpVC?.dismiss(animated: true, completion: nil)
    }
}
