//
//  MaterialUITextView.m
//  just-query
//
//  Created by carlos calderon on 3/31/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "MaterialUITextView.h"

@implementation MaterialUITextView

- (void)awakeFromNib
{
//    self.layer.cornerRadius = 2.0;
//    self.layer.borderWidth = 1.0;
    
    self.layer.cornerRadius = 2.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);

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
