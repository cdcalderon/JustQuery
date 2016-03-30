//
//  UserProfile.h
//  just-query
//
//  Created by carlos calderon on 3/20/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, strong) NSString *userProfileFirstName;
@property (nonatomic, strong) NSString *userProfileLastName;
@property (nonatomic, strong) NSString *userProfileDescription;
@property (nonatomic, strong) NSString *userProfilePicture;
@property (nonatomic, strong) NSString *userProfileKey;

- (instancetype)init:(NSString *)userProfileKey dictionary:(NSDictionary *)dictionary;
- (instancetype)init:(NSString *)userProfileKey;

@end
