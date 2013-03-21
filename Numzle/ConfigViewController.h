//
//  ConfigViewController.h
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectAvatarViewController.h"
#import <Parse/Parse.h>

@interface ConfigViewController : UIViewController<selectAvaterViewControllerDelegate,SKPaymentTransactionObserver >

- (IBAction)selectAvatarButtonAction:(id)sender;
- (IBAction)selectAvatarSet2:(id)sender;
- (IBAction)selectAvatarSet1:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *restoreInApp;
- (IBAction)restorInAppAction:(id)sender;

- (IBAction)SoundButton:(id)sender;
- (IBAction)facebookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (strong,nonatomic)NSString * selectedCategory;
@property (weak, nonatomic) IBOutlet UISwitch *facebookSwith;
@end
