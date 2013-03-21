//
//  MultiPlayerInterfaceViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterHelper.h"
#import <iAd/iAd.h>
#import "InviteFriendViewController.h"
#import "ButtonsCell.h"
#import "GAITrackedViewController.h"

@interface MultiPlayerInterfaceViewController : GAITrackedViewController<ButtonsCellDelegate,GameCenterInterfaceHelperDelegate,InviteFriendViewControllerDelegate,ADBannerViewDelegate>
{

    
}
@property(readwrite)bool bannerIsVisible;

@property (weak, nonatomic) IBOutlet UITableView *matchTableView;
- (IBAction)endAllMatch:(id)sender;
- (IBAction)findMatch:(id)sender;
- (IBAction)inviteFriendButton:(id)sender;
- (IBAction)removeActionButton:(id)sender;
- (IBAction)reloadDataButton:(id)sender;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutBannerToTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalSpace;

@end
