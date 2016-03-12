//
//  SubmitAnswerViewController.m
//  just-query
//
//  Created by carlos calderon on 2/17/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "SubmitAnswerViewController.h"
#import "Dataservice.h"
#import "Constants.h"

@implementation SubmitAnswerViewController

- (void)viewDidLoad
{
    self.questionBodyTextField.text = self.questionBody;
}

- (IBAction)saveAnswerButtonClicked:(UIButton *)sender {
    // Sync before push master
    NSLog(@"the question key where I need to inser the answer is :::: %@", self.questionKey);
    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    //create new answer
    NSDictionary *answer = @{@"description": self.answerTextView.text};
    Firebase *newAnswerRef = [dataService.answersRef childByAutoId];
    [newAnswerRef setValue: answer];
    
    Firebase *questionRef = [dataService.questionsRef childByAppendingPath:self.questionKey];
    Firebase *answersForQuestionRef = [questionRef childByAppendingPath:@"answers"];
   
    NSDictionary *newAnswerForQuestion = @{newAnswerRef.key : @YES};
    
    //////
    Firebase *newAnswerRef2 = [answersForQuestionRef childByAutoId];
    [newAnswerRef2 setValue: newAnswerForQuestion];

    
    /////
   // [answersForQuestionRef setValue: newAnswerForQuestion];
    
    self.answerTextView.text = @"";
    
}

- (IBAction)doneButtonClicked:(id)sender {
    [self.answerTextView resignFirstResponder];
}




@end

