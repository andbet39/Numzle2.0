//
//  ParseHelper.m
//  Numzle
//
//  Created by Andrea Terzani on 13/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ParseHelper.h"
#import "FaceBookHelper.h"


@implementation ParseHelper


static ParseHelper *sharedHelper = nil;

+ (ParseHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[ParseHelper alloc] init];
        
    }
    return sharedHelper;
}

-(void)setAvatar:(NSString *) avatarID forPlayerID:(NSString*)playerID{


             
            
            PFObject *playerAvatar = [PFObject objectWithClassName:@"PlayerAvatar"];
            [playerAvatar setObject:playerID forKey:@"playerID"];
            [playerAvatar setObject:avatarID forKey:@"avatarId"];
            [playerAvatar saveEventually];
            NSLog(@"Avatar will be saved for player",playerID);

            
    
}

-(void)TryPostWinStoryOnFBVSPlayerID:(NSString*)GCplayerID
{
    
    NSLog(@"Try posting FB story vs : %@",GCplayerID);
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerFacebookID"];
    [query whereKey:@"gameCenterID" equalTo:GCplayerID];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // The find succeeded.
            
            if ([objects count]!=0) {
                PFObject * result = objects[0];
                [[FaceBookHelper sharedInstance]postBeatFriendStoryWithFriendId: [result valueForKey:@"facebookID"]];
                
            }
        
        
        
        }
    }];
    
}

-(void)registerMeOnParseWithFbId:(NSString*)facebookID andGCID:(NSString*)gamecenterID{

    if (facebookID!=nil && gamecenterID!=nil) {
        
    
    PFQuery *query = [PFQuery queryWithClassName:@"PlayerFacebookID"];
    [query whereKey:@"facebookID" equalTo:facebookID];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            
            if ([objects count]==0) {
                
            PFObject *playerAvatar = [PFObject objectWithClassName:@"PlayerFacebookID"];
            [playerAvatar setObject:facebookID forKey:@"facebookID"];
            [playerAvatar setObject:gamecenterID forKey:@"gameCenterID"];
            [playerAvatar saveEventually];
                
            }else{
            //UPDATE
                
              PFObject *playerAvatar =  [objects objectAtIndex:0];
            [playerAvatar setObject:facebookID forKey:@"facebookID"];
            [playerAvatar setObject:gamecenterID forKey:@"gameCenterID"];
            [playerAvatar saveEventually];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    }
    
    
}

@end
