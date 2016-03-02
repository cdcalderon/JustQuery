//
//  QuestionViewController.m
//  just-query
//
//  Created by carlos calderon on 2/5/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "QuestionViewController.h"
#import "QuestionCell.h"
#import "Dataservice.h"
#import "Question.h"
#import "SubmitAnswerViewController.h"
#import "AddQuestionViewController.h"
#import "AnswersController.h"

@interface QuestionViewController()

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    Dataservice *dataService = [Dataservice sharedDataservice];
    Firebase *questionRef = [dataService questionsRef];
    [questionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *snapShots = snapshot.children.allObjects;
        [self.questions removeAllObjects];
        for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Snap Key %@", snap.key);

            NSLog(@"Snap Value %@", snap.value);
            
            Question *question = [[Question alloc] init:snap.key dictionary:snap.value];
            
            [self.questions addObject: question];
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (NSMutableArray *)questions
{
    if (!_questions) _questions = [[NSMutableArray alloc] init];
    return _questions;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = (QuestionCell *)[tableView dequeueReusableCellWithIdentifier:@"QuestionCustomCell" forIndexPath:indexPath];
    
        if (cell == nil )
        {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"QuestionCustomCell"];
        }
    
    
    cell.myLabel.text = [self.questions[indexPath.row] questionKey];
    cell.questionBody.text = [self.questions[indexPath.row] questionDescription];
    cell.answerNumberButtonLink1.tag = indexPath.row;
    cell.answerIndicatorButtonLink2.tag = indexPath.row;
    return cell;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SubmitAnswerViewController class]]) {
        SubmitAnswerViewController *svc = (SubmitAnswerViewController *)segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        svc.questionKey = [self.questions[path.row] questionKey];
        svc.questionBody = [self.questions[path.row] questionDescription];
    } else if ([segue.destinationViewController isKindOfClass:[AnswersController class]]) {
        AnswersController *ac = (AnswersController *)segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        UIButton *pressedButton = (UIButton *)sender;
        ac.questionBodyDescription = [self.questions[pressedButton.tag] questionDescription];
        ac.questionKey = [self.questions[pressedButton.tag] questionKey];
    }
}

- (IBAction)addedQuestion:(UIStoryboardSegue *)segue
{
    if ([segue.destinationViewController isKindOfClass:[AddQuestionViewController class]]) {
        NSLog(@"addedQuestion addedQuestion addedQuestion addedQuestion addedQuestion");
    }
}

@end
