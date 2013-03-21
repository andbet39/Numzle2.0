//
//  RootViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 23/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "RootViewController.h"

#import "FaceBookHelper.h"



@interface RootViewController ()

@property (nonatomic, retain) FirstViewController *firstViewController;
@property (nonatomic, retain) SecondViewController *secondViewController;
@property (nonatomic, retain) ThirdViewController *thirdViewController;


@end

@implementation RootViewController
@synthesize firstViewController=_firstViewController;
@synthesize secondViewController=_secondViewController;
@synthesize thirdViewController=_thirdViewController;


-(void)customizeInterface{
    
    UIImage * navigationBarImage =[UIImage imageNamed:@"tutorialNavBar"];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarImage forBarMetrics:UIBarMetricsDefault];
    
  
[self.navigationItem setHidesBackButton:YES animated:NO];
    
    UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *reloadBtnImage = [UIImage imageNamed:@"doneButton"]  ;
    [reloadBtn setBackgroundImage:reloadBtnImage forState:UIControlStateNormal];
    [reloadBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    reloadBtn.frame = CGRectMake(0, 0, 68, 32);
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithCustomView:reloadBtn] ;
    self.navigationItem.rightBarButtonItem = reloadButton;

    
}

-(void)goback{

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goback:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeInterface];
    self.dataSource = self;
    
    
    // Aggancio il view controller iniziale.
    [self setViewControllers:@[self.firstViewController]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:YES
                  completion:nil];



}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    UIViewController *nextViewController = nil;
    
    if (viewController == self.firstViewController) {
        nextViewController = self.secondViewController;
    }
    if (viewController == self.secondViewController) {
        nextViewController = self.thirdViewController;
    }

    return nextViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    UIViewController *prevViewController = nil;
    
    if (viewController == self.secondViewController) {
        prevViewController = self.firstViewController;
    }
    if (viewController==self.thirdViewController) {
        prevViewController = self.secondViewController;

    }
 
    return prevViewController;
}


- (FirstViewController *)firstViewController {
    
    if (!_firstViewController) {
        UIStoryboard *storyboard = self.storyboard;
        _firstViewController = [storyboard instantiateViewControllerWithIdentifier:@"First View"];
    }
    
    return _firstViewController;
}

- (SecondViewController *)secondViewController {
    
    if (!_secondViewController) {
        UIStoryboard *storyboard = self.storyboard;
        _secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"Second View"];
    }
    
    return _secondViewController;
}
- (ThirdViewController *)thirdViewController {
    
    if (!_thirdViewController) {
        UIStoryboard *storyboard = self.storyboard;
        _thirdViewController = [storyboard instantiateViewControllerWithIdentifier:@"Third View"];
    }
    
    return _thirdViewController;
}
@end
