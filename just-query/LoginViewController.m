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
    
    //Firebase *ref = [[Firebase alloc] initWithUrl:@"https://justquery.firebaseio.com"];
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
                                                         [[NSUserDefaults standardUserDefaults]setObject:authData.uid forKey:KEY_UID];
                                                         [self performSegueWithIdentifier:SEGUE_LOGGED_IN sender:nil];
                                                     }
                                            }];
                                            
                                           //***** ///Refactor using Data Service
//                                            [ref authWithOAuthProvider:@"facebook" token:accessToken
//                                                   withCompletionBlock:^(NSError *error, FAuthData *authData) {
//                                                       if (error) {
//                                                           NSLog(@"Login failed. %@", error);
//                                                       } else {
//                                                           NSLog(@"Logged in! %@", authData);
//                                                       }
//                                                   }];
                                        }
                                    }];
}

@end
