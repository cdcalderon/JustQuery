//
//  LoginViewController.m
//  just-query
//
//  Created by carlos calderon on 1/31/16.
//  Copyright © 2016 carlos calderon. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Dataservice.h"
#import "Constants.h"

@implementation LoginViewController

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:KEY_UID] != nil) {
        [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
    }
}

- (IBAction)fbButtonPressed:(UIButton *)sender {
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"]
                         fromViewController:self
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            NSLog(@"FSuccessfully logged in with Facebook Hurra hurra!!!. : with token: %@", accessToken);
                                            
                                            Dataservice *dataService = [Dataservice sharedDataservice];
                                            [dataService.rootRef authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                                                if (error) {
                                                    NSLog(@"Login failed. %@", error);
                                                } else {
                                                    NSLog(@"Logged in! %@", authData);
                                                    
                                                    NSDictionary *user = @{@"provider" : authData.provider, @"TestProp" : @"cool"};
                                                    [dataService createFirebaseUser:authData.uid user:user];
                                                    
                                                    [[NSUserDefaults standardUserDefaults]setObject:authData.uid forKey:KEY_UID];
                                                    [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
                                                }
                                            }];                                        }
                                    }];
}

- (IBAction)loginSignupButtonPressed:(UIButton *)sender {
    
    if ([self.emalAddressTextField hasText] && [self.passwordTextField hasText]) {
        Dataservice *dataService = [Dataservice sharedDataservice];
        [dataService.rootRef authUser:self.emalAddressTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {
            
            if ( error != nil ) {
                NSLog(@"%@", error);
                
                if (error.code == STATUS_ACCOUNT_NONEXIST) {
                    
                    [dataService.rootRef createUser:self.emalAddressTextField.text password:self.passwordTextField.text withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
                        
                        if (error != nil) {
                            [self showErrorAlert:@"Error Could not create account" message:@"Error creating account. Try again please"];
                        } else {
                            [[NSUserDefaults standardUserDefaults]setObject:result[KEY_UID] forKey:KEY_UID];
                            [dataService.rootRef authUser:self.emalAddressTextField.text password:self.passwordTextField.text withCompletionBlock:nil];
                            [dataService.rootRef authUser:self.emalAddressTextField.text password:self.passwordTextField.text withCompletionBlock:^(NSError *error, FAuthData *authData) {

                                NSDictionary *user = @{@"provider" : authData.provider, @"Email" : @"cool test"};
                                [dataService createFirebaseUser:authData.uid user:user];

                                
                            }];
                            
                            [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
                        }
                    }];
                } else {
                    [self showErrorAlert:@"Could not login" message:@"Please check your username or password"];
                }
            } else {
                [[NSUserDefaults standardUserDefaults]setObject:authData.uid forKey:KEY_UID];
                [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];

                //[self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
            }
        }];
        
    } else {
        [self showErrorAlert:@"Email and Password Required" message:@"You must enter an email and a password"];
    }
}

- (void)showErrorAlert:(NSString *)title message:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *s = @"";
}

@end
