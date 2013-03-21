//
//  ParseHelper.h
//  Numzle
//
//  Created by Andrea Terzani on 13/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@interface ParseHelper : NSObject



+(ParseHelper *)sharedInstance;
-(void)setAvatar:(NSString *) avatarID forPlayerID:(NSString*)playerID;
-(void)registerMeOnParseWithFbId:(NSString*)facebookID andGCID:(NSString*)gamecenterID;
-(void)TryPostWinStoryOnFBVSPlayerID:(NSString*)GCplayerID;


@end
