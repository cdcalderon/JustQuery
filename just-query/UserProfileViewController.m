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

@implementation UserProfileViewController


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
    
    
   // CLCloudinary *cloudinary = [[CLCloudinary alloc] init];
    //[cloudinary.config setValue:@"demo" forKey:@"cloud_name"];
    
    NSString *imageFilePath = [[NSBundle mainBundle] pathForResource:@"logocomplete"
                                                              ofType:@"png"];
    
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
   // [uploader unsignedUpload:imageFilePath uploadPreset:@"zcudy0uz" options:@{}];
    
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    
    
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 0.2);
    
    if (imageToUpload)
    {
    
       // NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath];
        
//        [uploader unsignedUpload:imageToUpload uploadPreset:@"zcudy0uz" options:[NSDictionary dictionaryWithObjectsAndKeys:@"user_sample_image_Carlos", @"public_id", @"tags", @"ios_upload", nil] withCompletion:^(NSDictionary *successResult, NSString *errorResult, NSInteger code, id context) {
//            
//            if (successResult) {
//                
//                NSString* publicId = [successResult valueForKey:@"public_id"];
//                NSLog(@"Upload success. Public ID=%@, Full result=%@", publicId, successResult);
//                CLTransformation *transformation = [CLTransformation transformation];
//                [transformation setWidthWithInt: 150];
//                [transformation setHeightWithInt: 100];
//                [transformation setCrop: @"fill"];
//                [transformation setGravity:@"face"];
//                
//                NSLog(@"Result: %@", [cloudinary url:publicId options:@{@"transformation": transformation, @"format": @"jpg"}]);
//                
//            } else {
//                
//                NSLog(@"Upload error: %@, %d", errorResult, code);
//                
//            }
//            
//        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
//            NSLog(@"Upload progress: %d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
//        }];
        
        //NSData *imageData = [NSData dataWithContentsOfFile:imageFilePath];
        //[uploader upload:imageData options:@{@"public_id": @"ios_image_1"}];
        
        [uploader upload:imageToUpload options:@{@"public_id": @"ios_image_3"}];
        
    }
    
    
    
    
    NSLog(@"FInish Pickeing");
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


@end
