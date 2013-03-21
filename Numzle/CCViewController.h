//
//  CCViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "MPGameOverViewController.h"
#import "GameOverViewController.h"
@class CCViewController;

@protocol CCViewControllerDelegate
-(void)CCViewControllerDidEndGame:(CCViewController*)sender;
@end



@interface CCViewController : UIViewController <CCDirectorDelegate,HelloWorldLayerDelegate,MPGameOverViewControllerDelegate,GameOverViewControllerDelegate>



@property(strong,nonatomic)id<CCViewControllerDelegate>gameOverDelegate;

#pragma mark - Setting up the director

// NOTE: If you have multiple CCViewController subclasses, you must take care the createDirectorGLView and didInitializeDirector set up the Cocos2D director exactly the same in each instance. Otherwise, you may get unexpected results. To avoid this, create another subclass that sits between CCViewController and your other subclasses, and place these methods there.

// Override this method to customize the CCGLView that is created for the director.
- (CCGLView *)createDirectorGLView;

// Override this method if you would like to set additional options for the director when it is first initialized.
// By default, this method does the following:
//  [director setAnimationInterval:1.0f/60.0f];
//  [director enableRetinaDisplay:YES];
- (void)didInitializeDirector;


#pragma mark - Notification handlers

// NOTE: You may override these as a convenient way to respond to application notifications. Be sure to call the super method to ensure director stability.

// Called when this view controller is visible and the application resigns active status.
- (void)applicationWillResignActive:(NSNotification *)notification;

// Called when this view controller is visible and the application becomes active.
- (void)applicationDidBecomeActive:(NSNotification *)notification;

// Called when this view controller is visible and the application enters the background.
- (void)applicationDidEnterBackground:(NSNotification *)notification;

// Called when this view controller is visible and the application enters the foreground.
- (void)applicationWillEnterForeground:(NSNotification *)notification;

// Called when this view controller is visible and the application is set to terminate.
- (void)applicationWillTerminate:(NSNotification *)notification;

// Called when this view controller is visible and the application reports a significant time change.
- (void)applicationSignificantTimeChange:(NSNotification *)notification;

@end

