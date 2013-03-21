//
//  avatarCell.h
//  Numzle
//
//  Created by Andrea Terzani on 15/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface avatarCell : UICollectionViewCell


-(void)initWithFile:(PFFile*)imageFile;
@end
