//
//  FakePasscodeState.swift
//  PasscodeLock
//
//  Created by Yanko Dimitrov on 8/28/15.
//  Copyright © 2015 Yanko Dimitrov. All rights reserved.
//

import Foundation

class FakePasscodeState: PasscodeLockStateType {
    
    var title = "A"
    var description = "B"
    var isCancellableAction = true
    var isTouchIDAllowed = true
    
    var acceptPaccodeCalled = false
    var acceptedPasscode = [Int]()
    var numberOfAcceptedPasscodes = 0
    
    init() {}
    
    func accept(passcode: [Int], fromLock lock: PasscodeLockType) {
        
        acceptedPasscode = passcode
        acceptPaccodeCalled = true
        numberOfAcceptedPasscodes += 1
    }
}
