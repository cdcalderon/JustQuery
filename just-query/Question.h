//
//  Question.h
//  just-query
//
//  Created by carlos calderon on 2/9/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (nonatomic, strong) NSString *questionDescription;
@property (nonatomic, strong) NSString *questionKey;

- (instancetype)init:(NSString *)questionKey dictionary:(NSDictionary *)dictionary;
@end
