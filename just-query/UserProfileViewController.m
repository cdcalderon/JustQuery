//
//  UserProfileViewController.m
//  just-query
//
//  Created by carlos calderon on 3/13/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "UserProfileViewController.h"
#import "Cloudinary/CLCloudinary.h"
#import "Cloudinary/CLTransformation.h"
#import  <AFNetworking/AFNetworking.h>
#import  <AFNetworking/AFHTTPRequestOperation.h>


@implementation UserProfileViewController

- (void)viewDidLoad
{
    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    Firebase *userProfileRef = [dataService.currentUserRef childByAppendingPath:@"profile"];
   

    // Attach a block to read the data at our posts reference
    [userProfileRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        NSDictionary *profile = snapshot.value;
        
        if([profile isKindOfClass:[NSDictionary class]]){
            
            NSString *profileKey = [[profile allKeys] objectAtIndex:0];
            NSLog(@"%@", [[profile allKeys] objectAtIndex:0]);
        
         _userProfileRef = [dataService.profilesRef childByAppendingPath:profileKey];
            // Attach a block to read the data at our posts reference
            [_userProfileRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSLog(@"%@", snapshot.value);
                
                if([snapshot.value isKindOfClass:[NSDictionary class]]){
                    NSString *profileDescription = [snapshot.value objectForKey:@"description"];
                    NSString *imageUrl = [snapshot.value objectForKey:@"picture"];
                    NSString *firstName = [snapshot.value objectForKey:@"firstName"];
                    NSString *lastName = [snapshot.value objectForKey:@"lastName"];
                    
                    self.firstNameTextField.text = firstName;
                    self.lastNameTextField.text = lastName;

                    self.userDescription.text = profileDescription;
                    NSURL *url = [NSURL URLWithString:imageUrl];
                    
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                    [NSURLConnection sendAsynchronousRequest:request
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               if ( !error )
                                               {
                                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                                   _userProfileImageView.image = image;
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

- (IBAction)addUserImageClicked:(UIButton *)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    [cloudinary.config setValue:@"carlos-calderon" forKey:@"cloud_name"];
    [cloudinary.config setValue:@"686262751217777" forKey:@"api_key"];
    [cloudinary.config setValue:@"5qSCCtXQ45SHWF-dUeNi7JkpwZY" forKey:@"api_secret"];
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    
    _userProfileImage = info[UIImagePickerControllerEditedImage];
    if (!_userProfileImage) _userProfileImage = info[UIImagePickerControllerOriginalImage];
    
    NSLog(@"Finish Picking");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"Cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) uploaderSuccess:(NSDictionary*)result context:(id)context {
    NSString* publicId = [result valueForKey:@"public_id"];
    NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, result);
}

- (void) uploaderError:(NSString*)result code:(int) code context:(id)context {
    NSLog(@"Upload error: %@, %d", result, code);
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context {
    NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

- (IBAction)postUserProfile:(UIButton *)sender {
    [self postProfileToFirebase];
}

- (void)postProfileToFirebase
{
    CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    [cloudinary.config setValue:@"carlos-calderon" forKey:@"cloud_name"];
    [cloudinary.config setValue:@"686262751217777" forKey:@"api_key"];
    [cloudinary.config setValue:@"5qSCCtXQ45SHWF-dUeNi7JkpwZY" forKey:@"api_secret"];
    
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];

    
    Dataservice *dataService = [Dataservice sharedDataservice];
    
    NSDictionary *profile = @{@"picture": @"mypic2Updated", @"description": @"my descr2Updated"};
    
    if (_userProfileRef != nil ) {
        NSData *imageToUpload = UIImageJPEGRepresentation(_userProfileImage, 0.2);
        
        if (imageToUpload)
        {

            [uploader upload:imageToUpload options:@{@"public_id": dataService.currentUserRef.key} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
                NSDictionary *profile = @{@"picture": [successResult objectForKey:@"url"],
                                          @"description": self.userDescription.text,
                                          @"firstName": self.firstNameTextField.text,
                                          @"lastName": self.lastNameTextField.text};
                [_userProfileRef updateChildValues:profile];
                
            } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
                NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
            }];
            

        }
        
        //[_userProfileRef updateChildValues:profile];
    } else {
        
        NSData *imageToUpload = UIImageJPEGRepresentation(_userProfileImage, 0.2);
        
        if (imageToUpload)
        {

            [uploader upload:imageToUpload options:@{@"public_id": dataService.currentUserRef.key} withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
                NSDictionary *profile = @{@"picture": [successResult objectForKey:@"url"],
                                          @"description": self.userDescription.text,
                                          @"firstName": self.firstNameTextField.text,
                                          @"lastName": self.lastNameTextField.text};
                

                Firebase *newQuestionRef = [dataService.profilesRef childByAutoId];
                [newQuestionRef setValue: profile];
                
                
                NSString *newQuestionId = newQuestionRef.key;
                Firebase *userProfileRef = [dataService.currentUserRef childByAppendingPath:@"profile"];
                NSLog(@"IDDD: %@", dataService.currentUserRef.key);
                
                NSDictionary *userQuestion = @{newQuestionId : @YES};
                [userProfileRef setValue:userQuestion];
                
                
            } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
                NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
            }];
            
        }
        
    }
}

@end
