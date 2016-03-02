//
//  Answer.h
//  just-query
//
//  Created by carlos calderon on 3/2/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Answer : UIViewController

@property (nonatomic, strong) NSString *answerDescription;
@property (nonatomic, strong) NSString *answerKey;

- (instancetype)init:(NSString *)answerKey dictionary:(NSDictionary *)dictionary;
- (instancetype)init:(NSString *)answerKey;


@end
