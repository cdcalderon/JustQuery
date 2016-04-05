//
//  QuestionCell.h
//  just-query
//
//  Created by carlos calderon on 2/5/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *questionBody;
@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UIView *answersIndicator;
@property (weak, nonatomic) IBOutlet UIButton *answerNumberButtonLink1;
@property (weak, nonatomic) IBOutlet UIButton *answerIndicatorButtonLink2;
@property (weak, nonatomic) IBOutlet UIImageView *userPicture;
@property (weak, nonatomic) IBOutlet UIButton *followUserButton;

@end
