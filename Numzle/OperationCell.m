//
//  OperationCell.m
//  Numzle
//
//  Created by Andrea Terzani on 07/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "OperationCell.h"

@implementation OperationCell
@synthesize punteggioLabel,operationLabel;
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

-(void)initStyle{
    [punteggioLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:18]];
    [operationLabel setFont:[UIFont fontWithName:@"Segoe Semibold" size:18]];
  

}
@end
