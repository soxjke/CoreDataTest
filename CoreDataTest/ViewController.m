//
//  ViewController.m
//  CoreDataTest
//
//  Created by Petro Korienev on 9/27/13.
//  Copyright (c) 2013 Petro Korienev. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Message.h"
#import "NSObject+SafePointer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSEntityDescription *messageEntity = [NSEntityDescription entityForName:NSStringFromClass([Message class]) inManagedObjectContext:context];
    
    // Here we create message object and fill it
    Message *message = [[Message alloc] initWithEntity:messageEntity insertIntoManagedObjectContext:context];
    
    message.body        = @"Hello world!";
    message.from        = @"Petro Korienev";
    
    NSDate *now = [NSDate date];
    
    message.timestamp   = now;
    
    // Now imagine that we send message to some server. Server processes it, and sends back new timestamp which we should assign to message object.
    // Because working with managed objects asynchronously is not safe, we save context, than we get it's objectId and refetch object in completion block
    
    NSError *error;
    [context save:&error];

    if (error)
    {
        NSLog(@"Error saving");
        return;
    }
    
    __unsafe_unretained NSManagedObjectID *objectId = message.objectID;
    Class objectIdClass = [objectId class];
    // Now simulate server delay
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        
        if (![NSObject safeObject:objectId isMemberOfClass:objectIdClass])
        {
            NSLog(@"Object for update already deleted");
            return;
        }
        
        // Refetch object
        NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        
        Message *message = (Message*)[context objectWithID:objectId];

        message.timestamp = [NSDate date];

        NSError *error;
        [context save:&error];
        
        if (error)
        {
            NSLog(@"Error updating");
            return;
        }
        
    });
    
    // Accidentaly user deletes message before response from server is returned
    
    delayInSeconds = 2.0;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        // Fetch desired managed object
        NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"timestamp == %@", now];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Message class])];
        request.predicate = predicate;
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (error)
        {
            NSLog(@"Error fetching");
            return;
        }
        
        Message *message = [results lastObject];
        
        [context deleteObject:message];
        [context save:&error];
        
        if (error)
        {
            NSLog(@"Error deleting");
            return;
        }
    });
}

@end
