//
//  RLMRealm+Defaults.m
//  SwiftSwizzling
//
//  Created by John Clayton on 12/14/14.
//  Copyright (c) 2014 Code Monkey Labs LLC. All rights reserved.
//

#import "RLMRealm+Defaults.h"
#import <objc/runtime.h>

@implementation RLMRealm (Defaults)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"[ObjC] Swizzling RLMRealm");

        Class class = [self class];

        SEL originalSelector = @selector(defaultRealm);
        SEL swizzledSelector = @selector(objc_appRealm);

        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        // This doesn't actually swizzle the method, but if not called Swift won't be able to either?!
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
            NSLog(@"[ObjC] Replaced method");
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
            NSLog(@"[ObjC] Exchanged implementation");
        }
    });
}

+ (instancetype)objc_appRealm {
    NSLog(@"objc_appRealm");
    return [self inMemoryRealmWithIdentifier:@"Swizzled_objc.realm"];
}

@end
