//
//  InviteFriendViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"
#import "FacebookFriendCell.h"
#import "FaceBookHelper.h"

@class InviteFriendViewController;
@protocol InviteFriendViewControllerDelegate

- (void)InviteFriendViewController:(InviteFriendViewController*)sender didSelectPlayer:(GKPlayer*)player;
- (void)InviteFriendViewControllerDidBack;

@end
@interface InviteFriendViewController : UIViewController<FacebookFriendCellDelegate,FaceBookHelperDelegate>

@property(nonatomic,strong)id<InviteFriendViewControllerDelegate>delegate;

@property(strong,nonatomic)NSArray * GamecenterfriendsArray;
@property(strong,nonatomic)NSArray * FacebookfriendsArray;
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundCellImage;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@end
