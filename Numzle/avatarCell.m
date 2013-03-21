//
//  avatarCell.m
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "avatarCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation avatarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initWithFile:(PFFile*)imageFile{

    /*self.contentView.backgroundColor=[UIColor clearColor];
     self.contentView.layer.cornerRadius = 5;
     self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth=2;
    self.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    */
    
    PFImageView * imageView= [[PFImageView alloc]initWithFrame:CGRectMake(5, 3, 50, 50)];
    [imageView setFile:imageFile];
    [imageView loadInBackground];
    [self.contentView addSubview:imageView];
    
}



@end
