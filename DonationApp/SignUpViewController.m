//
//  SignUpViewController.m
//  DonationApp
//
//  Created by Fernando Jinzenji on 2017-06-28.
//  Copyright © 2017 Alex Lee. All rights reserved.
//

#import "SignUpViewController.h"
#import <FirebaseDatabase/FirebaseDatabase.h>
#import "User.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) FIRDatabaseReference *ref;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Actions

- (IBAction)signUpButtonPressed:(UIButton *)sender {
    
    self.ref = [FIRDatabase database].reference;
    
    FIRDatabaseReference *usersRef = [self.ref child:@"users"];
    FIRDatabaseReference *newUserRef = [usersRef childByAutoId];
    
    // create a user and save in firebase
    User *newUser = [[User alloc] init];
    newUser.name = self.fullNameTextField.text;
    newUser.email = self.emailTextField.text;
    newUser.phoneNumber = self.phoneNumberTextField.text;
    newUser.password = self.passwordTextField.text;
    [newUserRef setValue:[newUser formattedUser]];
    
    // set userid
    newUser.key = newUserRef.key;
    NSLog(@"%@", newUser.key);
    
    // set user in app delegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.currentUser = newUser;
    
    // set key to NSUserDefaults to keep user logged
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:newUser.key forKey:@"UserKey"];
}

- (IBAction)viewTapped:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

@end
