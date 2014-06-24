//
//  LoginViewController.m
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//
#import <ReactiveCocoa.h>

#import "LoginViewController.h"
#import "TwitterManager.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[TwitterManager sharedManager] login];
    }];
    [loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        [loginSignal subscribeCompleted:^{
            NSLog(@"login successful!");
        }];
    }];
    self.loginButton.rac_command = loginCommand;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
