//
//  NSObject+SafePointer.h
//  CoreDataTest
//
//  Created by Petro Korienev on 9/28/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafePointer)

+ (BOOL)safeObject:(id)object isMemberOfClass:(__unsafe_unretained Class)aClass;

@end
