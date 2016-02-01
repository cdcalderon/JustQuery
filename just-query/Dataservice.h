//
//  Dataservice.h
//  just-query
//
//  Created by carlos calderon on 1/31/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
@interface Dataservice : NSObject {
    Firebase *rootRef;
}

@property (nonatomic, retain) Firebase *rootRef;

+ (id)sharedDataservice;
@end
