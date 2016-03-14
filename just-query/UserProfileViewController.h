//
//  UserProfileViewController.h
//  just-query
//
//  Created by carlos calderon on 3/13/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "Cloudinary/CLUploader.h"

@interface UserProfileViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLUploaderDelegate>

@property (nonatomic, strong) AFHTTPRequestOperationManager *userProfileOperationManager;

@end
