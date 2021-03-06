//
//  MainViewController.m
//  twitter
//
//  Created by mhahn on 6/26/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "UIViewController+ContentViewControllerDelegate.h"
#import "MainViewController.h"
#import "PanelTableViewController.h"
#import "TweetsTableViewController.h"

#define SLIDE_DURATION .25
#define PANEL_WIDTH 100

@interface MainViewController () <ContentViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) UIViewController *panelTableViewController;
@property (nonatomic, assign) BOOL displayingPanel;
@property (nonatomic, assign) BOOL showPanel;

@end

@implementation MainViewController

- (id)initWithContentViewController:(UIViewController *)contentViewController {
    self = [super init];
    if (self) {
        [self setContentViewController:contentViewController animated:NO];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setContentViewController:(UIViewController *)contentViewController animated:(BOOL)animated {
    if (animated) {
        [self togglePanel];
    }
    
    contentViewController.delegate = self;
    _navigationController = [[UINavigationController alloc] initWithRootViewController:contentViewController];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [_navigationController.view addGestureRecognizer:panRecognizer];

    [_navigationController willMoveToParentViewController:self];
    
    for (UIView *view in self.view.subviews) {
        if (view.tag != 1) {
            [view removeFromSuperview];
        }
    }
    
    [self.view addSubview:_navigationController.view];
    [self addChildViewController:_navigationController];
    [_navigationController didMoveToParentViewController:self];
}

- (UIView *)getPanelView {
    if (_panelTableViewController == nil) {
        _panelTableViewController = [[PanelTableViewController alloc] initWithNibName:@"PanelTableViewController" bundle:nil];
        _panelTableViewController.view.tag = 1;
// at some point i think i'll want this
//        _leftPanelViewController.delegate = _contentViewController;
        
        [self.view addSubview:_panelTableViewController.view];
        [self addChildViewController:_panelTableViewController];
        [_panelTableViewController didMoveToParentViewController:self];
        _panelTableViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    // XXX set a shadow
    UIView *view = _panelTableViewController.view;
    return view;
}

- (void)movePanelRight {
    UIView *childView = [self getPanelView];
    [self.view sendSubviewToBack:childView];
    [UIView animateKeyframesWithDuration:SLIDE_DURATION delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        _navigationController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _displayingPanel = YES;
        }
    }];
}

- (void)movePanelToOriginalPosition {
    [UIView animateKeyframesWithDuration:SLIDE_DURATION delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        _navigationController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _displayingPanel = NO;
    } completion:^(BOOL finished) {
        if (finished) {
            [self resetMainView];
        }
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    BOOL validGesture = NO;
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    CGPoint newCenter = CGPointMake([gestureRecognizer view].center.x + translatedPoint.x, [gestureRecognizer view].center.y);
    CGPoint velocity = [gestureRecognizer velocityInView:[gestureRecognizer view]];
    
    if (newCenter.x >= 160 && velocity.y == 0) {
        validGesture = YES;
    }

    return validGesture;
}

- (void)movePanel:(id)sender {
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self.view];
	CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:[sender view]];
    CGPoint newCenter = CGPointMake([sender view].center.x + translatedPoint.x, [sender view].center.y);
    
    BOOL validGesture = NO;
    if (newCenter.x >= 160) {
        validGesture = YES;
    }
    if (validGesture ) {
        
        if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
            UIView *childView = nil;
            if (velocity.x > 0) {
                childView = [self getPanelView];
            }
            [self.view sendSubviewToBack:childView];
            [[sender view] bringSubviewToFront:[(UIPanGestureRecognizer *)sender view]];
        }
        
        if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateChanged) {
            [sender view].center = newCenter;
            [(UIPanGestureRecognizer *)sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        
        if ([(UIPanGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {

            BOOL showPanel = YES;
            
            if (velocity.x > 0 && velocity.x < 100) {
                showPanel = abs([sender view].center.x - _navigationController.view.frame.size.width/2) > _navigationController.view.frame.size.width/2;
            } else if (velocity.x < 0 && velocity.x > -100) {
                showPanel = abs([sender view].center.x - _navigationController.view.frame.size.width/2) < _navigationController.view.frame.size.width/2;
            }
            
            if (showPanel && _displayingPanel) {
                [self movePanelToOriginalPosition];
            } else if (showPanel && !_displayingPanel) {
                [self movePanelRight];
            } else if (!showPanel && _displayingPanel) {
                [self movePanelRight];
            } else {
                [self movePanelToOriginalPosition];
            }

        }
    }
}

- (void)resetMainView {
    if (_panelTableViewController != nil) {
        [_panelTableViewController.view removeFromSuperview];
        _panelTableViewController = nil;
    }
}

- (void)togglePanel {
    if (_displayingPanel) {
        [self movePanelToOriginalPosition];
    } else {
        [self movePanelRight];
    }
}

@end
