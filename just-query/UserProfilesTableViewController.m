//
//  UserProfilesTableViewController.m
//  just-query
//
//  Created by carlos calderon on 3/20/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "UserProfilesTableViewController.h"
#import "Dataservice.h"
#import "UserProfile.h"

@interface UserProfilesTableViewController ()

@end

@implementation UserProfilesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Dataservice *dataService = [Dataservice sharedDataservice];
    Firebase *profilesRef = [dataService profilesRef];
    [profilesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSArray *snapShots = snapshot.children.allObjects;
        [self.userProfiles removeAllObjects];
        for (FDataSnapshot *snap in snapShots) {
            NSLog(@"Snap Key %@", snap.key);
            
            NSLog(@"Snap Value %@", snap.value);
            
            UserProfile *userProfile = [[UserProfile alloc] init:snap.key dictionary:snap.value];
            
            [self.userProfiles addObject: userProfile];
        }
        [self.tableView reloadData];
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];

}

- (NSMutableArray *)userProfiles
{
    if (!_userProfiles) _userProfiles = [[NSMutableArray alloc] init];
    return _userProfiles;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userProfiles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"test 2";
    cell.detailTextLabel.text = @"test details";
//    cell.questionBody.text = [self.questions[indexPath.row] questionDescription];
//    cell.answerNumberButtonLink1.tag = indexPath.row;
//    cell.answerIndicatorButtonLink2.tag = indexPath.row;

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
