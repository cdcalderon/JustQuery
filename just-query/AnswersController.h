//
//  AnswersController.h
//  just-query
//
//  Created by carlos calderon on 3/2/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswersController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *questionBody;
@property (nonatomic, strong) NSString *questionBodyDescription;
@property (nonatomic, strong) NSString *questionKey;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAnswers;
@property (nonatomic, strong) NSMutableArray *answers;
@end
