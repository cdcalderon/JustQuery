//
//  UserProfile.m
//  just-query
//
//  Created by carlos calderon on 3/20/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile


- (instancetype)init:(NSString *)userProfileKey dictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.userProfileKey = userProfileKey;
    self.userProfileDescription = dictionary[@"description"];
    self.userProfilePicture = dictionary[@"picture"];
    self.userProfileFirstName = dictionary[@"firstName"];
    self.userProfileLastName = dictionary[@"lastName"];

    
    return self;
}

@end
