//
//  ConfirmPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct ConfirmPasscodeState: PasscodeLockStateType {
    
    let title: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    fileprivate var passcodeToConfirm: [Int]
    
    init(passcode: [Int]) {
        
        passcodeToConfirm = passcode
        title = localizedStringFor("PasscodeLockConfirmTitle", comment: "Confirm passcode title")
    }
    
    func accept(passcode: [Int], fromLock lock: PasscodeLockType) {
        
        if passcode == passcodeToConfirm {
            
            lock.repository.savePasscode(passcode)
            lock.delegate?.passcodeLockDidSucceed(lock)
        
        } else {
            
            let mismatchTitle = localizedStringFor("PasscodeLockMismatchTitle", comment: "Passcode mismatch title")
            
            let nextState = SetPasscodeState(title: mismatchTitle)
            
            lock.changeStateTo(nextState)
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
