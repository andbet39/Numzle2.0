//
//  InAppHelper.h
//  Numzle
//
//  Created by Andrea Terzani on 13/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface InAppHelper : NSObject



@property(readwrite)bool isPremiumVersion;

+(InAppHelper *)sharedInstance;
-(void)registerHandleForProduct:(NSString*)productID;

-(void)buyProduct:(NSString*)productID;
-(void)restoreInApp;

@end
