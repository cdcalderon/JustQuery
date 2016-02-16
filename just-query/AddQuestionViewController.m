//
//  AddQuestionViewController.m
//  just-query
//
//  Created by carlos calderon on 2/14/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "Dataservice.h"
#import "Constants.h"


@implementation AddQuestionViewController

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSRange resultRange = [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet] options:NSBackwardsSearch];
    if ([text length] == 1 && resultRange.location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)cancelButtonClicked:(UIButton *)sender
{
    
}

- (IBAction)doneButtonClicked:(UIButton *)sender
{
    [self postQuestionToFirebase];
}

- (void)postQuestionToFirebase
{
    Dataservice *dataService = [Dataservice sharedDataservice];
    NSDictionary *question = @{@"description": self.questionBody.text};
    
    Firebase *newQuestionRef = [dataService.questionsRef childByAutoId];
    [newQuestionRef setValue: question];
    
    self.questionBody.text = @"";
    
}

@end
