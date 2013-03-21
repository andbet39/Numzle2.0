//
//  CCViewController.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "CCViewController.h"
#import "HelloWorldLayer.h"

#import "GAI.h"


@implementation CCViewController


@synthesize gameOverDelegate;

#pragma mark - HelloWorldLayerDelegate


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"GameOver"]) {

        MPGameOverViewController * destination = segue.destinationViewController;
        [destination setDelegate:self];
        
    }

}


-(void)didEndGame:(HelloWorldLayer *)sender
{
    CCDirector *director = [CCDirector sharedDirector];
    
    [director removeFromParentViewController];

    [self performSegueWithIdentifier:@"GameOver" sender:self];
    
}

#pragma mark GameOverDelegate
-(void)MPGameOverViewControllerDidEndGame:(MPGameOverViewController *)sender
{

    
    [sender dismissViewControllerAnimated:FALSE completion:^{
        [gameOverDelegate CCViewControllerDidEndGame:self];
    }];


}
#pragma mark GameOverDelegate
-(void)GameOverViewControllerDidEndGame:(GameOverViewController *)sender{
    
   
    [sender dismissViewControllerAnimated:FALSE completion:^{
          }];
    [gameOverDelegate CCViewControllerDidEndGame:self];
    
}
#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker sendView:@"Play Screen"];
    
    CCDirector *director = [CCDirector sharedDirector];
    
    // If the director's OpenGL view hasn't been set up yet, then we should create it now. If you would like to prevent this "lazy loading", you should initialize the director and set its view elsewhere in your code.
    if([director isViewLoaded] == NO)
    {
        director.view = [self createDirectorGLView];
        [self didInitializeDirector];
    }
    
    director.delegate = self;
    
    // Add the director as a child view controller.
    [self addChildViewController:director];

    
    
    // Add the director's OpenGL view, and send it to the back of the view hierarchy so we can place UIKit elements on top of it.
    [self.view addSubview:director.view];
    [self.view sendSubviewToBack:director.view];
    
    // Ensure we fulfill all of our view controller containment requirements.
    [director didMoveToParentViewController:self];
    
    
    GameManager * gm  =[GameManager sharedInstance];
    
    [gm initzialize];
    
    if(director.runningScene)
        [director replaceScene:[HelloWorldLayer sceneWithDelegate:self]];
    else
        [director pushScene:[HelloWorldLayer sceneWithDelegate:self]];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Observe some notifications so we can properly instruct the director.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationSignificantTimeChange:)
                                                 name:UIApplicationSignificantTimeChangeNotification
                                               object:nil];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationSignificantTimeChangeNotification object:nil];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[CCDirector sharedDirector] setDelegate:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [[CCDirector sharedDirector] purgeCachedData];
}


#pragma mark - Setting up the director

- (CCGLView *)createDirectorGLView
{
    // Create a default OpenGL view.
    CCGLView *glView = [CCGLView viewWithFrame:[[[UIApplication sharedApplication] keyWindow] bounds]
                                   pixelFormat:kEAGLColorFormatRGB565
                                   depthFormat:0
                            preserveBackbuffer:NO
                                    sharegroup:nil
                                 multiSampling:NO
                               numberOfSamples:0];
    
    glView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return glView;
}


- (void)didInitializeDirector
{
    CCDirector *director = [CCDirector sharedDirector];
    
    // Set up some common director properties.
    [director setAnimationInterval:1.0f/60.0f];
    [director enableRetinaDisplay:YES];
}


#pragma mark - Notification handlers

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] pause];
}


- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [[CCDirector sharedDirector] resume];
}


- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] stopAnimation];
}


- (void)applicationWillEnterForeground:(NSNotification *)notification
{
    [[CCDirector sharedDirector] startAnimation];
}


- (void)applicationWillTerminate:(NSNotification *)notification
{
    [[CCDirector sharedDirector] end];
}


- (void)applicationSignificantTimeChange:(NSNotification *)notification
{
    [[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}



@end
