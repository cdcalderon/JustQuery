//
//  Dataservice.m
//  just-query
//
//  Created by carlos calderon on 1/31/16

//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "Dataservice.h"

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
        _rootRef = [[Firebase alloc] initWithUrl:@"https://justquery.firebaseio.com"];
    }
    return self;
}

@end
