//
//  ButtonsCell.m
//  Numzle
//
//  Created by Andrea Terzani on 12/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "ButtonsCell.h"

@implementation ButtonsCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)randomButton:(id)sender {
    
    [delegate ButtonsCelldidPressRandomButton:self];
}

- (IBAction)friendButton:(id)sender {
    [delegate ButtonsCelldidPressFriendsButton:self];
}
@end
