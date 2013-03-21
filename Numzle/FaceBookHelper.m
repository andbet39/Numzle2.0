//
//  FaceBookHelper.m
//  Numzle
//
//  Created by Andrea Terzani on 18/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "FaceBookHelper.h"
#import "ParseHelper.h"
#import "ParseHelper.h"
#import <GameKit/GameKit.h>

@implementation FaceBookHelper
@synthesize friends;
@synthesize facebook;
@synthesize delegate;
@synthesize session = _session;

static FaceBookHelper *sharedHelper = nil;

+ (FaceBookHelper *) sharedInstance {
    if (!sharedHelper) {
        sharedHelper = [[FaceBookHelper alloc] init];
        
    }
    return sharedHelper;
}


-(void)LoginWithAllowUI:(BOOL)allowUI{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            nil];
    
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:allowUI completionHandler:^(FBSession *session,
                                                                                                      FBSessionState status,
                                                                                                      NSError *error)
     {
         // Did something go wrong during login? I.e. did the user cancel?
         if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening) {
             
             // If so, just send them round the loop again
             [[FBSession activeSession] closeAndClearTokenInformation];
             [FBSession setActiveSession:nil];
             [self CreateNewSession];
         }
         else
         {
             
             // Required to initialise the old SDK FB object here so we can play with Dialogs
             self.facebook = [[Facebook alloc] initWithAppId:[FBSession activeSession].appID andDelegate:nil];
             
             // Initialise the old SDK with our new credentials
             self.facebook.accessToken = [FBSession activeSession].accessToken;
             self.facebook.expirationDate = [FBSession activeSession].expirationDate;
             
             [self registerMeOnParse];

             
             //[self loadMyInfo];
         }
     }];
    
}

-(void)Logout{

    if ([[FBSession activeSession]isOpen]) {
        
    
        self.facebook.accessToken = nil;
        self.facebook.expirationDate=nil;
        self.facebook=nil;
    
    
        [[FBSession activeSession] closeAndClearTokenInformation];
        [FBSession setActiveSession:nil];
    }
}

-(void)CreateNewSession{
    
    self.session = [[FBSession alloc] init];
    [FBSession setActiveSession: self.session];

    
}



- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    
    [self LoginWithAllowUI:allowLoginUI];
    
    return true;
    
}

-(void)registerMeOnParse{
    
    if (FBSession.activeSession.isOpen) {
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
         if (!error) {
             [[ParseHelper sharedInstance]registerMeOnParseWithFbId:[user objectForKey:@"id"] andGCID:[GKLocalPlayer localPlayer].playerID];
         }
     }];
    }
}



-(void)loadFriendListAllowFBUI:(BOOL)allowUI{

    // FBSample logic
    // Check to see whether we have already opened a sessio
    
    [self LoginWithAllowUI:allowUI];
    friends = [[NSMutableArray alloc]init];

    FBRequest *request = [FBRequest requestForMyFriends];
        
        
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSArray *data = [result objectForKey:@"data"];
            
            [friends removeAllObjects];
            for (FBGraphObject<FBGraphUser> *friend in data) {
                NSLog(@"%@", [friend first_name]);
                [friends addObject:friend];
            }
            NSSortDescriptor *sortDescriptor;
            
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"  ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            friends = [friends sortedArrayUsingDescriptors:sortDescriptors];
            
            
            [delegate FacebookHelperFriendListUpdated];

            
        }];
  
    
}


-(void)postInviteToWall:(FBGraphObject<FBGraphUser>*)user{


    self.facebook = [[Facebook alloc]
                     initWithAppId:@"291937484267843"
                     andDelegate:nil];
    
    // Store the Facebook session information
    self.facebook.accessToken = FBSession.activeSession.accessToken;
    self.facebook.expirationDate = FBSession.activeSession.expirationDate;
    

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Challenge me in Numzle", @"name",
                                   @"Install Numzle now... It's the new fast math game for iPhone.", @"caption",
                                   @"http://www.atdevapps.com/Numzle/redirect.php", @"link",
                                   @"http://www.atdevapps.com/Numzle/icon512.png", @"picture",
                                   @"foo", @"ref",
                                   user.id,@"to",
                                   nil];

    
    //@"https://m.facebook.com/apps/uniquenamespace/?deeplink=multyplayer", @"link",
    

       [self.facebook dialog:@"feed" andParams:params andDelegate:self];


}



// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    //NSDictionary *params = [self parseURLParams:[url query]];
    
    NSString *msg = @"The invitation has been sent...";
    NSLog(@"%@", msg);
    // Show the result in an alert
    [[[UIAlertView alloc] initWithTitle:@"Successfull"
                                message:msg
                               delegate:nil
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil]
     show];
}

// We need to request write permissions from Facebook
static bool bHaveRequestedPublishPermissions = false;


-(void)requestForWritePermission{
    
    if (!bHaveRequestedPublishPermissions)
    {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_actions", nil];
        
        [[FBSession activeSession] reauthorizeWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session,            NSError* error) {
            
            NSLog(@"Reauthorized with publish permissions.");
            
        }];
        
        bHaveRequestedPublishPermissions = true;
    }
    
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

-(void)postBeatFriendStoryWithFriendId:(NSString*)friendID{
    
    //[self LoginWithAllowUI:FALSE];
    if ([FBSession activeSession].isOpen) {
     
    [self requestForWritePermission];
    
    NSMutableDictionary<FBGraphObject> *action = [FBGraphObject graphObject];
    action[@"profile"] = [NSString stringWithFormat:@"http://www.facebook.com/%@",friendID];
    
    [FBRequestConnection startForPostWithGraphPath:@"me/atdevapps_numzle:won_against"
                                       graphObject:action
                                 completionHandler:^(FBRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
                                     // handle the result
                                 }];
    }
}

-(void)sendRequestToFBID:(NSString*)FbID andMessage:(NSString*)message
{
    
    NSMutableDictionary* params =   [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     message, @"message",
                                     FbID, @"to",
                                     nil];
    
    [self.facebook dialog:@"apprequests" andParams:params andDelegate:self];

}


@end
