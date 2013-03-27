//
//  AchievementHelper.h
//  Numzle
//
//  Created by Andrea Terzani on 27/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "MatchDataClass.h"
#import "AchievementViewController.h"



#define kJobs @"jobs"


@interface AchievementHelper : NSObject

+(AchievementHelper *)sharedInstance;


- (void) loadAchievements;

-(void)checkAchievementForCurrentTurnEnd;
-(void)addPlayedGame;
-(void)addFacbookInvitation;
-(void)addMatchWinned;
-(void)resetWinnedMatch;


- (void) resetAchievements;

-(void)checkForJobsAchievementInMatch:(MatchDataClass*)match andPresenterViewController:(UIViewController*)viewController;







@end
