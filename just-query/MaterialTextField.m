//
//  MaterialTextField.m
//  just-query
//
//  Created by carlos calderon on 1/31/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "MaterialTextField.h"
#import <UIKit/UIKit.h>
#import "Constants.h"

@implementation MaterialTextField

- (void)awakeFromNib
{
    self.layer.cornerRadius = 2.0;
    self.layer.borderColor = [[UIColor colorWithRed:SHADOW_COLOR green:SHADOW_COLOR blue:SHADOW_COLOR alpha:0.5f] CGColor];
    self.layer.borderWidth = 1.0;
}

// Place holder

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, 10, 0);
}

@end
