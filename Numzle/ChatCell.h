//
//  ChatCell.h
//  Numzle
//
//  Created by Andrea Terzani on 23/03/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textString;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageBackGround;

@end
