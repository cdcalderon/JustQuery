//
//  SubmitAnswerViewController.h
//  just-query
//
//  Created by carlos calderon on 2/17/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitAnswerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (nonatomic, strong) NSString *questionKey;

@end
