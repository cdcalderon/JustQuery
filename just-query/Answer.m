//
//  Answer.m
//  just-query
//
//  Created by carlos calderon on 3/2/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (id)init
{
    self = [super init];
    return self;
}

- (instancetype)init:(NSString *)answerKey dictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    self.answerKey = answerKey;
    self.answerDescription = dictionary[@"description"];
    
    return self;
}

- (instancetype)init:(NSString *)answerKey {
    self = [super init];
    
    self.answerKey = answerKey;
    
    return self;
}

@end
