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
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneButtonClicked:(UIButton *)sender
{
    [self postQuestionToFirebase];
}

- (void)postQuestionToFirebase
{
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    NSDictionary *question = @{@"description": self.questionBody.text, @"userId": dataService.currentUserRef.key};
    
    Firebase *newQuestionRef = [dataService.questionsRef childByAutoId];
    [newQuestionRef setValue: question];
    
    NSString *newQuestionId = newQuestionRef.key;
    Firebase *userQuestionsRef = [dataService.currentUserRef childByAppendingPath:@"questions"];
    NSLog(@"IDDD: %@", dataService.currentUserRef.key);
    
    NSDictionary *userQuestion = @{newQuestionId : @YES};
    [userQuestionsRef setValue:userQuestion];
    
    self.questionBody.text = @"";
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
