//
//  ButtonsCell.h
//  Numzle
//
//  Created by Andrea Terzani on 12/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonsCell;
@protocol ButtonsCellDelegate

-(void)ButtonsCelldidPressFriendsButton:(ButtonsCell*)sender;
-(void)ButtonsCelldidPressRandomButton:(ButtonsCell*)sender;

@end



@interface ButtonsCell : UITableViewCell
@property(weak,nonatomic)id<ButtonsCellDelegate> delegate;

- (IBAction)randomButton:(id)sender;
- (IBAction)friendButton:(id)sender;
@end
