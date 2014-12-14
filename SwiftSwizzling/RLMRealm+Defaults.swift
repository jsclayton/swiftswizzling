//
//  RLMRealm.swift
//  SwiftSwizzling
//
//  Created by John Clayton on 12/14/14.
//  Copyright (c) 2014 Code Monkey Labs LLC. All rights reserved.
//

import Realm

extension RLMRealm {

    class func swizzle() {

        struct Static {
            static var onceToken: dispatch_once_t = 0
        }

        dispatch_once(&Static.onceToken) {
            NSLog("[Swift] Swizzling RLMRealm")

            let originalMethod = class_getClassMethod(self, "defaultRealm")
            let swizzledMethod = class_getClassMethod(self, "swift_appRealm")

            method_exchangeImplementations(originalMethod, swizzledMethod)
        }

    }

    class func swift_appRealm() -> RLMRealm! {

        NSLog("swift_appRealm")
        return self.inMemoryRealmWithIdentifier("Swizzled_swift.realm")
        
    }

}
