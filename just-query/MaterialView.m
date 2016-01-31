//
//  MaterialView.m
//  just-query
//
//  Created by carlos calderon on 1/30/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "MaterialView.h"
#import <UIKit/UIKit.h>
#import "Constants.m"

@implementation MaterialView


- (void)awakeFromNib
{
    self.layer.cornerRadius = 2.0;
    self.layer.shadowColor = [[UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5f] CGColor];
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
}

@end
