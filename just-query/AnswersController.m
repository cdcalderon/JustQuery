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
#import "AnswerCell.h"

@implementation AnswersController

- (void)viewDidLoad
{
    
    NSLog(@"NSStringFromUIEdgeInsets(self.itemTextField.contentInset) = %@", NSStringFromUIEdgeInsets(self.questionBody.contentInset));

    self.questionBody.contentInset = UIEdgeInsetsZero;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.questionBody.text = self.questionBodyDescription;
    
    [self setImageToUIImageView:self.questionUserImage fromUserId:self.questionUserIdKey];

    
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
    static NSString *simpleTableIdentifier = @"AnswerCell";
    
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[AnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    } else {
        //reset Image
        UIImage *btnImage = [UIImage imageNamed:@"thumbsUpE.png"];
        [cell.answerUpVoteButton setImage:btnImage forState:UIControlStateNormal];
    }
    
    cell.answerUpVoteButton.tag = indexPath.row;
    
    NSLog(@"%ld", (long)indexPath.row);
    [cell.answerUpVoteButton addTarget:self action:@selector(answerUpvoteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.answerBodyTextView.text =[[self.answers objectAtIndex:indexPath.row] answerDescription];
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    Firebase *userProfileRef2 = [dataService.answersRef childByAppendingPath:[self.answers[indexPath.row] answerKey]];
    Firebase *answerUpvotes = [userProfileRef2 childByAppendingPath:@"upvotes"];
    // Attach a block to read the data at our posts reference
    [answerUpvotes observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@" UPVAOTES %@", snapshot.value);
        NSArray *snapShots = snapshot.children.allObjects;
        for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Snap Key %@", snap.key);
            
            NSLog(@"Snap Value %@", snap.value);
            NSDictionary *profile = snap.value;
            
            if([profile isKindOfClass:[NSDictionary class]]){
                
                NSString *profileKey = [[profile allKeys] objectAtIndex:0];
                NSString *userId = dataService.currentUserRef.key;
                NSLog(@" dic Key %@", profileKey);
                
                [self setImageToUIImageView:cell.answerUserImage fromUserId:profileKey];
                NSLog(@" UserIdd %@", userId);
                if ([profileKey isEqualToString:userId]) {
                    UIImage *btnImage = [UIImage imageNamed:@"thumbsUpF.png"];
                    [cell.answerUpVoteButton setImage:btnImage forState:UIControlStateNormal];
                }
                NSLog(@" dic Key %@", [[profile allKeys] objectAtIndex:0]);
            }
        }

    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
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

-(void)answerUpvoteButtonClicked:(UIButton*)sender
{
    NSLog(@"%ld", (long)sender.tag);
    NSString *answerKey = [self.answers[sender.tag] answerKey];
    NSLog(@"%@", answerKey);

    // Sync before push master
    NSLog(@"the Answer key where I need to inser the upvote is :::: %@", self.questionKey);
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    NSLog(@"User IDDD: %@", dataService.currentUserRef.key);
    Firebase *answerRef = [dataService.answersRef childByAppendingPath:answerKey];
    Firebase *answerUpvotes = [answerRef childByAppendingPath:@"upvotes"];
    // Attach a block to read the data at our posts reference
    [answerUpvotes observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@" UPVOTES %@", snapshot.value);
        NSArray *snapShots = snapshot.children.allObjects;
        BOOL upvoted = NO;
        for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Snap Key %@", snap.key);
            
            NSLog(@"Snap Value %@", snap.value);
            NSDictionary *profile = snap.value;
            
            if([profile isKindOfClass:[NSDictionary class]]){
                
                NSString *profileKey = [[profile allKeys] objectAtIndex:0];
                NSString *userId = dataService.currentUserRef.key;
                NSLog(@" dic Key %@", profileKey);
                NSLog(@" UserIdd %@", userId);
                if ([profileKey isEqualToString:userId]) {
                    upvoted = YES;
                }
                NSLog(@" dic Key %@", [[profile allKeys] objectAtIndex:0]);
            }
        }
        if (upvoted == NO) {
            NSDictionary *newAnswerForQuestion = @{dataService.currentUserRef.key : @YES};
            
            //////
            Firebase *newAnswerRef = [answerUpvotes childByAutoId];
            [newAnswerRef setValue: newAnswerForQuestion];

        }
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}

- (void)setImageToUIImageView:(UIImageView *)imageView fromUserId:(NSString *)userId
{
    
    Dataservice *dataService = [Dataservice sharedDataservice];
    Firebase *usersRef = [dataService.usersRef childByAppendingPath:userId];
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
                    
                    NSString *imageUrl = [snapshot.value objectForKey:@"picture"];
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               if ( !error )
                                               {
                                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                                   imageView.image = image;
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
    
}

@end
