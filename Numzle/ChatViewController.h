//
//  ChatViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 23/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import <iAd/iAd.h>


@interface ChatViewController : UIViewController<UITextFieldDelegate,ADBannerViewDelegate>
{
    NSMutableArray          * chatData;
    PF_EGORefreshTableHeaderView *_refreshHeaderView;
}


@property (weak, nonatomic) IBOutlet UITableView *chatTable;

-(void) registerForKeyboardNotifications;
-(void) freeKeyboardNotifications;
-(void) keyboardWasShown:(NSNotification*)aNotification;
-(void) keyboardWillHide:(NSNotification*)aNotification;

-(void)initWithChatIdentifier:(NSString*)identifier andPlayerName:(NSDictionary*)players;
@property (weak, nonatomic) IBOutlet UITextField *tfEntry;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerVerticalSpace;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@end
