//
//  AchievementHelper.m
//  Numzle
//
//  Created by Andrea Terzani on 27/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "AchievementHelper.h"
#import "GameManager.h"
#import "GameCenterHelper.h"

@interface AchievementHelper()

@property(nonatomic, retain) NSMutableDictionary *achievementsDictionary;



@end

@implementation AchievementHelper


static AchievementHelper *sharedHelper = nil;

+ (AchievementHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[AchievementHelper alloc] init];
        
    }
    return sharedHelper;
}

-(id)init
{
    if (self==[super init]) {
        
        
       self.achievementsDictionary = [[NSMutableDictionary alloc] init];

        
    }


    return self;
}

- (void) loadAchievements
{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error)
     {
         if (error == nil)
         {
             for (GKAchievement* achievement in achievements){
                 [self.achievementsDictionary setObject: achievement forKey: achievement.identifier];
                 NSLog(achievement.identifier);
             }
         }
     }];
}


- (GKAchievement*) getAchievementForIdentifier: (NSString*) identifier
{
    GKAchievement *achievement = [self.achievementsDictionary objectForKey:identifier];
    if (achievement == nil)
    {
        achievement = [[GKAchievement alloc] initWithIdentifier:identifier];
        [self.achievementsDictionary setObject:achievement forKey:achievement.identifier];
    }
    return achievement;
}


- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent
{
    GKAchievement *achievement = [self getAchievementForIdentifier:identifier];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil)
             {
                 // Log the error.
             }
         }];
    }
}

- (void) resetAchievements
{
    // Clear all locally saved achievement objects.
    self.achievementsDictionary = [[NSMutableDictionary alloc] init];
    // Clear all progress saved on Game Center.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {}      // handle the error.
    }];
}

-(void)checkAchievementForCurrentTurnEnd
{
    

}

-(void)checkForJobsAchievementInMatch:(MatchDataClass*)match andPresenterViewController:(UIViewController*)viewController
{
    NSString * localPlayerID = [GKLocalPlayer localPlayer].playerID ;
                                
    //check per vedere se sono finiti tutti i turni
    if ([match.p1Results count]==NUMBER_OF_TURN && [match.p2Results count]==NUMBER_OF_TURN) {
        
        bool isAchieved=FALSE;

      //Check su player 1
        if ([match.p1ID isEqualToString:localPlayerID]) {
            
            if ([match.p1Results[0]intValue]<[match.p2Results[0]intValue] &&
                [match.p1Results[1]intValue]<[match.p2Results[1]intValue] &&
                [match.p1Results[2]intValue]>[match.p2Results[2]intValue])isAchieved=TRUE;
            
        }
        
        //Check su player 1
        if ([match.p2ID isEqualToString:localPlayerID]) {
            
             if ([match.p2Results[0]intValue]<[match.p1Results[0]intValue] &&
                [match.p2Results[1]intValue]<[match.p1Results[1]intValue] &&
                [match.p2Results[2]intValue]>[match.p1Results[2]intValue])isAchieved=TRUE;
            
        }
        
        if ([self.achievementsDictionary objectForKey:kJobs]==NULL && isAchieved) {
            
            [self showAchievementControllerWithID:kJobs onViewController:viewController];
            [self reportAchievementIdentifier:kJobs percentComplete:100];
            NSLog(@"Achievement postato");


        }else{
        
            NSLog(@"Achievement già presente o non ottenuto : non verrà postato");
        }
        
    }

    
}


-(void)showAchievementControllerWithID:(NSString*)achivementID onViewController:(UIViewController*)presenterViewController{


    AchievementViewController * childController = [[AchievementViewController alloc]initWithNibName:@"AchievementViewController" bundle:nil];
    
    
    [presenterViewController addChildViewController:childController];
    [presenterViewController.view addSubview:childController.view];
    
    
    


}



-(void)addPlayedGame
{
    

}

-(void)addFacbookInvitation
{


}

-(void)addMatchWinned
{

}

-(void)resetWinnedMatch
{


}




@end
