//
//  ScoreViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 10/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface ScoreViewController : UIViewController<GKLeaderboardViewControllerDelegate>
- (IBAction)viewLeaderBoard:(id)sender;

@end
