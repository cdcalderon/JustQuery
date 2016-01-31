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


@implementation LoginViewController

- (IBAction)fbButtonPressed:(UIButton *)sender {
    
    //Firebase *ref = [[Firebase alloc] initWithUrl:@"https://<YOUR-FIREBASE-APP>.firebaseio.com"];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {
                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
                                            NSLog(@"FSuccessfully logged in with Facebook Hurra hurra!!!.");
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
