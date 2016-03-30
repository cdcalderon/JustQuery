//
//  AnswerCell.h
//  just-query
//
//  Created by carlos calderon on 3/24/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *answerBodyTextView;
@property (weak, nonatomic) IBOutlet UIImageView *answerUserImage;
@property (weak, nonatomic) IBOutlet UIButton *answerUpVoteButton;

@end
