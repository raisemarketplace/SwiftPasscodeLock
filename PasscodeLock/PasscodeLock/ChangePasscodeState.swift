//
//  ChangePasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct ChangePasscodeState: PasscodeLockStateType {
    
    let title: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init() {
        title = localizedStringFor("PasscodeLockChangeTitle", comment: "Change passcode title")
    }
    
    func accept(passcode: [Int], fromLock lock: PasscodeLockType) {
        
        guard let currentPasscode = lock.repository.passcode else {
            return
        }
        
        if passcode == currentPasscode {
            
            let nextState = SetPasscodeState()
            
            lock.changeStateTo(nextState)
            
        } else {
            
            lock.delegate?.passcodeLockDidFail(lock)
        }
    }
}
