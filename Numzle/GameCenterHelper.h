//
//  GameCenterHelper.h
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "MatchDataClass.h"


#define kMultiplayerLeaderBoard @"MultiplayerLeaderboard"
#define kSoloPlayerLeaderBoard @"SoloGameLeaderboard"


#define NUMBER_OF_TURN 3


@protocol GameCenterInterfaceHelperDelegate
-(void)GameCenterInterfaceHelperDelegateReceivedListOfGames:(NSArray *)matchs;
-(void)GameCenterInterfaceHelperDelegateDidFindMath:(GKTurnBasedMatch*)match;
-(void)GameCenterInterfaceHelperDelegateDidReceiveUpdateForMatch:(GKTurnBasedMatch*)match;
-(void)GameCenterInterfaceHelperDelegateDidFoundPlayerForMatch:(GKTurnBasedMatch *)match andPlayers:(GKPlayer*)player;
@end


@interface GameCenterHelper : NSObject <GKTurnBasedEventHandlerDelegate> {
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
    
    
  
}

@property (nonatomic, retain) id <GameCenterInterfaceHelperDelegate> interfaceDelegate;

@property(nonatomic,strong)NSMutableArray * OthermatchsArray;
@property(nonatomic,strong)NSMutableArray * myTurnMatchArray;
@property(nonatomic,strong)NSMutableArray * ClosedMatchArray;
@property(nonatomic,strong)NSMutableArray * MatchingMatchArray;

@property (assign, readonly) BOOL gameCenterAvailable;
@property (readwrite, getter=isGameCenterAuthenticationComplete) BOOL gameCenterAuthenticationComplete;
@property (retain,readwrite) NSString * currentPlayerID;
@property (retain) GKTurnBasedMatch * currentMatch;

+(GameCenterHelper *)sharedInstance;
-(void)authenticateLocalUser;
-(void)loadMatches;
-(void)findCasualMatch ;
-(void)sendEndTurn :(MatchDataClass*)MatchData forMatch:(GKTurnBasedMatch*)match;
-(void)sendEndGame :(MatchDataClass*)MatchData forMatch:(GKTurnBasedMatch*)match;
-(void)inviteMatchWithFriend:(GKPlayer*)player ;
-(void)leaveMatch:(GKTurnBasedMatch*)match andData:(MatchDataClass *)MatchData;
-(void)quitMatchNotInTurn:(GKTurnBasedMatch*)match andData:(MatchDataClass*)MatchData;

-(void)removeAllClosedMatch;



- (void) reportScore: (int64_t) score forLeaderboardID: (NSString*) category;
@end

