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

@interface QuestionViewController()

@end

@implementation QuestionViewController

- (void)viewDidLoad
{
    Dataservice *dataService = [Dataservice sharedDataservice];
    Firebase *questionRef = [dataService questionsRef];
    [questionRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *snapShots = snapshot.children.allObjects;
        
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
    
    return cell;

}

@end
