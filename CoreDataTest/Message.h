//
//  Message.h
//  CoreDataTest
//
//  Created by Petro Korienev on 9/27/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSDate * timestamp;

@end
