//
//  AnswerCell.m
//  just-query
//
//  Created by carlos calderon on 3/24/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "AnswerCell.h"

@interface AnswerCell()
@end

@implementation AnswerCell



- (void)awakeFromNib {
    self.answerBodyTextView.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
