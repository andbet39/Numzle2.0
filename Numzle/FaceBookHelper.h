//
//  FaceBookHelper.h
//  Numzle
//
//  Created by Andrea Terzani on 18/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Facebook.h"

@protocol FaceBookHelperDelegate <NSObject>

-(void)FacebookHelperFriendListUpdated;

@end

@interface FaceBookHelper : NSObject<FBDialogDelegate>

{
     
}

@property(strong,nonatomic)id<FaceBookHelperDelegate> delegate;

@property(strong,nonatomic)FBSession *session;
@property(strong,nonatomic)Facebook *facebook;
@property(strong,nonatomic)NSMutableArray<FBGraphUser> * friends;

+(FaceBookHelper *)sharedInstance;

-(void)postInviteToWall:(FBGraphObject<FBGraphUser>*)user;
-(BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI ;
-(void)loadFriendListAllowFBUI:(BOOL)allowUI;
-(void)postBeatFriendStoryWithFriendId:(NSString*)friendID;
-(void)sendRequestToFBID:(NSString*)FbID andMessage:(NSString*)message;
-(void)LoginWithAllowUI:(BOOL)allowUI;
-(void)Logout;

@end
