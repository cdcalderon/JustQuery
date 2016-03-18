//
//  Question.m
//  just-query
//
//  Created by carlos calderon on 2/9/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)init
{
    self = [super init];
    return self;
}

- (instancetype)init:(NSString *)questionKey dictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.questionKey = questionKey;
    self.questionDescription = dictionary[@"description"];
    self.userId = dictionary[@"userId"];

    return self;
}

@end
