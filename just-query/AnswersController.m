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
#import "Answer.h"

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
                for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Answer Key Destination %@", snap.key);
            
            //Firebase *answerRef = [dataService.answersRef childByAppendingPath:snap.key];
            NSArray *snapShotsA = snapshot.children.allObjects;
            for (FDataSnapshot *snap2 in snapShotsA) {
                //[self.answers removeAllObjects];

                NSLog(@"Answer2 Key Destination %@", snap2.key);
                
                NSDictionary *answer = snap2.value;
                
                if([answer isKindOfClass:[NSDictionary class]]){
                    NSString *answerKey = [[answer allKeys] objectAtIndex:0];
                    NSLog(@"Answer2 Value Destination %@", answerKey);
                    Firebase *answerRef = [dataService.answersRef childByAppendingPath:answerKey];
                    
                    
                    [answerRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot2) {
                        NSLog(@"Content Answer Destination:::::  %@", snapshot2.value);
                        
                        Answer *answer = [[Answer alloc] init:snapshot2.key dictionary:snapshot2.value];
                        
                        
                        if (![self containAnswer:answer]) {
                            [self.answers addObject: answer];
                        }
                        
                        [self.tableViewAnswers reloadData];
                    } withCancelBlock:^(NSError *error) {
                        NSLog(@"%@", error.description);
                    }];
                    
                }
                
            }
                }
        //[self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

- (NSMutableArray *)answers
{
    if (!_answers) _answers = [[NSMutableArray alloc] init];
    return _answers;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    
    cell.textLabel.text = [[self.answers objectAtIndex:indexPath.row] answerDescription];
    
    //cell.imageView.image = [UIImage imageNamed:@"geekPic.jpg"];
    
    return cell;
}

- (BOOL)containAnswer:(Answer *)answer
{
    for (Answer *ans in self.answers) {
        if (ans.answerKey == answer.answerKey) {
            return YES;
        }
        // do something with object
    }
    return NO;
}

@end
