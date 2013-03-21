//
//  FacebookFriendCell.h
//  Numzle
//
//  Created by Andrea Terzani on 18/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "Facebook.h"
@class FacebookFriendCell;
@protocol FacebookFriendCellDelegate

- (void)FacebookFriendCell:(FacebookFriendCell*)sender didInviteFriend:(FBGraphObject<FBGraphUser>*)inviteFriend;
- (void)FacebookFriendCell:(FacebookFriendCell*)sender didPlayGCFriend:(NSString*)playerID;

@end


@interface FacebookFriendCell : UITableViewCell
{

    FBGraphObject<FBGraphUser>* cellFriend;
}
-(void)initWithFBGraphUser:(FBGraphObject*)inviteFriend;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundCellImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong,nonatomic)FBProfilePictureView *picture;
@property (strong,nonatomic)NSString * GameCenterID;

@property(weak,nonatomic)id<FacebookFriendCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

- (IBAction)inviteButton:(id)sender;
@end
