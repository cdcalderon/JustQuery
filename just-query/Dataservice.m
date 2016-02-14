//
//  Dataservice.m
//  just-query
//
//  Created by carlos calderon on 1/31/16

//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "Dataservice.h"
#import "Constants.h"

@interface Dataservice()
@property (nonatomic, retain) Firebase *usersRef;
@property (nonatomic, retain) Firebase *questionsRef;

@end

@implementation Dataservice

+(id)sharedDataservice
{
    static Dataservice *sharedDataservice = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataservice = [[self alloc] init];
    });
    
    return sharedDataservice;
}

- (id)init
{
    if (self = [super init]) {
       // _rootRef = [[Firebase alloc] initWithUrl:URL_BASE];
    }
    return self;
}

- (Firebase *)rootRef
{
    if (!_rootRef) _rootRef = [[Firebase alloc] initWithUrl:FIREBASE_URL_BASE];
    return _rootRef;
}

- (Firebase *)usersRef
{
    if (!_usersRef) _usersRef = [[Firebase alloc] initWithUrl: [NSString stringWithFormat:@"%@%@", FIREBASE_URL_BASE, @"/users"]];
    return _usersRef;
}

- (Firebase *)questionsRef
{
    if (!_questionsRef) _questionsRef = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", FIREBASE_URL_BASE, @"/questions"]];
    return _questionsRef;
}

- (void)createFirebaseUser:(NSString *)uid user:(NSDictionary*)user
{
    Firebase *newUserRef = [self.usersRef childByAppendingPath: uid];
    [newUserRef setValue:user];
}



@end
