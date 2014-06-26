//
//  LoginViewController.m
//  twitter
//
//  Created by mhahn on 6/23/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//
#import <ReactiveCocoa.h>

#import "LoginViewController.h"
#import "TimelineTableViewController.h"
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
    
    UIColor *twitterBlue = [UIColor colorWithRed:0.333 green:0.675 blue:0.933 alpha:1]; /*#55acee*/
    self.view.backgroundColor = twitterBlue;
    [self.navigationController setNavigationBarHidden:YES];
    
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[TwitterManager instance] login];
    }];
    [loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        [loginSignal subscribeCompleted:^{
            
            NSArray *viewControllers = [NSArray arrayWithObject:[[TimelineTableViewController alloc] init]];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController setViewControllers:viewControllers animated:NO];

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
