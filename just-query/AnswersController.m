//
//  AnswersController.m
//  just-query
//
//  Created by carlos calderon on 3/2/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "AnswersController.h"
#import "Dataservice.h"
#import "Constants.h"

@implementation AnswersController

- (void)viewDidLoad
{
    NSLog(@"NSStringFromUIEdgeInsets(self.itemTextField.contentInset) = %@", NSStringFromUIEdgeInsets(self.questionBody.contentInset));

    self.questionBody.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.questionBody.text = self.questionBodyDescription;

    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    Firebase *questionRef = [dataService.questionsRef childByAppendingPath:self.questionKey];
    
    Firebase *answersForQuestionRef = [questionRef childByAppendingPath:@"answers"];
    
    [answersForQuestionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *snapShots = snapshot.children.allObjects;
        [self.answers removeAllObjects];
        for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Answer Key %@", snap.key);
            
            Firebase *answerRef = [dataService.answersRef childByAppendingPath:snap.key];
            
            [answerRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSLog(@"Content  %@", snapshot.value);
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
            
            
            
            
           // NSLog(@"Answer Value %@", snap.value);
            
           // Question *question = [[Question alloc] init:snap.key dictionary:snap.value];
            
            //[self.answers addObject: question];
        }
        //[self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    

}

@end
