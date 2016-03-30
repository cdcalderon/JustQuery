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
#import "UserProfileViewController.h"

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
            
            Firebase *questionRef = [dataService.questionsRef childByAppendingPath:snap.key];
            
            Firebase *answersForQuestionRef = [questionRef childByAppendingPath:@"answers"];
            
            [answersForQuestionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSArray *snapShotsAnswers = snapshot.children.allObjects;
                
                
                Question *question = [[Question alloc] init:snap.key dictionary:snap.value];
                question.numOfAnswers = snapShotsAnswers.count;
                
                [self.questions addObject: question];
                [self.tableView reloadData];
                
                //NSArray *quests = [self.questions copy];
                
                _sortedQuestions = [self.questions sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSUInteger first = [(Question *)obj1 numOfAnswers];
                    NSUInteger second = [(Question *)obj2 numOfAnswers];
                    return first < second;

                }];
                
                NSLog(@"%@", _sortedQuestions);
                
                
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];

        }
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
    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
     [cell.answerNumberButtonLink1 setTitle:[NSString stringWithFormat:@"%lu answers",(unsigned long)[self.sortedQuestions[indexPath.row] numOfAnswers]] forState:UIControlStateNormal];
    
    
    NSString *keyr = [self.sortedQuestions[indexPath.row] userId];
    
    Firebase *usersRef = [dataService.usersRef childByAppendingPath:[self.sortedQuestions[indexPath.row] userId]];
    Firebase *userProfileRef = [usersRef childByAppendingPath:@"profile"];
    
    
    // Attach a block to read the data at our posts reference
    [userProfileRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *profile = snapshot.value;
        
        if([profile isKindOfClass:[NSDictionary class]]){
            
            NSString *profileKey = [[profile allKeys] objectAtIndex:0];
            NSLog(@"%@", [[profile allKeys] objectAtIndex:0]);
            
            Firebase *userProfileRef2 = [dataService.profilesRef childByAppendingPath:profileKey];
            // Attach a block to read the data at our posts reference
            [userProfileRef2 observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSLog(@"%@", snapshot.value);
                
                if([snapshot.value isKindOfClass:[NSDictionary class]]){
                    NSString *profileDescription = [snapshot.value objectForKey:@"description"];
                    NSString *fullName = [NSString stringWithFormat:@"%@ %@", [snapshot.value objectForKey:@"firstName"], [snapshot.value objectForKey:@"lastName"]];
                    
                    NSString *imageUrl = [snapshot.value objectForKey:@"picture"];
                    cell.myLabel.text = fullName;
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               if ( !error )
                                               {
                                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                                   cell.userPicture.image = image;
                                               } else{
                                                   NSLog(@"Error @%", error);                                               }
                                           }];
                    
                }
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
        }
        
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
    
    cell.questionBody.text = [self.sortedQuestions[indexPath.row] questionDescription];
    cell.answerNumberButtonLink1.tag = indexPath.row;
    cell.answerIndicatorButtonLink2.tag = indexPath.row;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[SubmitAnswerViewController class]]) {
        SubmitAnswerViewController *svc = (SubmitAnswerViewController *)segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        svc.questionKey = [self.sortedQuestions[path.row] questionKey];
        svc.questionBody = [self.sortedQuestions[path.row] questionDescription];
    } else if ([segue.destinationViewController isKindOfClass:[AnswersController class]]) {
        AnswersController *ac = (AnswersController *)segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        UIButton *pressedButton = (UIButton *)sender;
        ac.questionBodyDescription = [self.sortedQuestions[pressedButton.tag] questionDescription];
        ac.questionKey = [self.sortedQuestions[pressedButton.tag] questionKey];
        ac.questionUserIdKey = [self.sortedQuestions[pressedButton.tag] userId];
    } else if ([segue.destinationViewController isKindOfClass:[UserProfileViewController class]]) {
        UserProfileViewController *ac = (UserProfileViewController *)segue.destinationViewController;
       
    }

}

- (IBAction)addedQuestion:(UIStoryboardSegue *)segue
{
    if ([segue.destinationViewController isKindOfClass:[AddQuestionViewController class]]) {
        NSLog(@"addedQuestion addedQuestion addedQuestion addedQuestion addedQuestion");
    }
}

@end
