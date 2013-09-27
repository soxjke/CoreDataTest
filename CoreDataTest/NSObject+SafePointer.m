//
//  NSObject+SafePointer.m
//  CoreDataTest
//
//  Created by Petro Korienev on 9/28/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#if __has_feature(objc_arc)
#error ARC must be disabled for this file! use -fno-objc-arc flag for compile this source
#endif

#import "NSObject+SafePointer.h"

@implementation NSObject (SafePointer)

+ (BOOL)safeObject:(id)object isMemberOfClass:(__unsafe_unretained Class)aClass
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-objc-isa-usage"
    return ((NSUInteger*)object->isa == (NSUInteger*)aClass);
#pragma clang diagnostic pop
}

@end

