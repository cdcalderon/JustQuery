//
//  AddQuestionViewController.h
//  just-query
//
//  Created by carlos calderon on 2/14/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddQuestionViewController : UIViewController <UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *questionBody;

@end
