//
//  SetPasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

struct SetPasscodeState: PasscodeLockStateType {
    
    let title: String
    let isCancellableAction = true
    var isTouchIDAllowed = false
    
    init(title: String) {
        
        self.title = title
    }
    
    init() {
        
        title = localizedStringFor("PasscodeLockSetTitle", comment: "Set passcode title")
    }
    
    func accept(passcode: [Int], fromLock lock: PasscodeLockType) {
        
        let nextState = ConfirmPasscodeState(passcode: passcode)
        
        lock.changeStateTo(nextState)
    }
}
