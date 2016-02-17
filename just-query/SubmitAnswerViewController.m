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

- (IBAction)saveAnswerButtonClicked:(UIButton *)sender {
    
    NSLog(@"the question key where I need to inser the answer is :::: %@", self.questionKey);
//    Firebase *hopperRef = [usersRef childByAppendingPath: @"gracehop"];
//    
//    NSDictionary *nickname = @{
//                               @"nickname": @"Amazing Grace",
//                               };
//    
//    [hopperRef updateChildValues: nickname];
    
    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    NSDictionary *answer = @{@"description": self.answerTextView.text};
    
    Firebase *newAnswerRef = [dataService.answersRef childByAutoId];
    [newAnswerRef setValue: answer];
    
//    NSString *newQuestionId = newQuestionRef.key;
//    Firebase *userQuestionsRef = [dataService.currentUserRef childByAppendingPath:@"questions"];
//    NSLog(@"IDDD: %@", dataService.currentUserRef.key);
//    
//    NSDictionary *userQuestion = @{newQuestionId : @YES};
//    [userQuestionsRef setValue:userQuestion];
    
    self.answerTextView.text = @"";
}

@end
