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

            let originalSelector: Selector = "defaultRealm"
            let swizzledSelector: Selector = "swift_appRealm"

            let originalMethod: Method = class_getClassMethod(self, originalSelector)
            let swizzledMethod: Method = class_getClassMethod(self, swizzledSelector)

            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if (didAddMethod) {
                // This runs when the ObjC version is commented out and the result is that it does NOT work
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
                NSLog("[Swift] Replaced method")
            } else {
                // This runs when the ObjC version is also running and DOES work
                method_exchangeImplementations(originalMethod, swizzledMethod)
                NSLog("[Swift] Exchanged implementation")
            }
        }

    }

    class func swift_appRealm() -> RLMRealm! {

        NSLog("swift_appRealm")
        return self.inMemoryRealmWithIdentifier("Swizzled_swift.realm")
        
    }

}
