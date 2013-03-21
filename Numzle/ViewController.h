//
//  ViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCViewController.h"
#import "InAppHelper.h"
#import "ParseHelper.h"
#import "GameCenterHelper.h"
#import "GAITrackedViewController.h"


@interface ViewController : GAITrackedViewController<CCViewControllerDelegate,GKGameCenterControllerDelegate>

- (IBAction)playButton:(id)sender ;

- (IBAction)buyProVersion:(id)sender;
- (IBAction)setAvatar:(id)sender;
- (IBAction)fbLoaginButton:(id)sender;
- (IBAction)postAction:(id)sender;
- (IBAction)viewLeaderboardAction:(id)sender;
- (IBAction)postFacebookwin:(id)sender;
- (IBAction)goConfigAction:(id)sender;
@end
