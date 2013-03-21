//
//  InAppHelper.m
//  Numzle
//
//  Created by Andrea Terzani on 13/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "InAppHelper.h"

@implementation InAppHelper

@synthesize isPremiumVersion;

static InAppHelper *sharedHelper = nil;
+ (InAppHelper *) sharedInstance {
    if (!sharedHelper) {    		
        sharedHelper = [[InAppHelper alloc] init];
        
    }
    return sharedHelper;
}


-(id)init{

    if ((self = [super init])) {
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if ([prefs boolForKey:@"isPremiumVersion"] == FALSE)
        {
        
            isPremiumVersion=NO;
        
        }else{
            isPremiumVersion=YES;
        }

    }
    return self;
}

-(void)registerHandleForProduct:(NSString*)productID{
// Use the product identifier from iTunes to register a handler.
    [PFPurchase addObserverForProduct:productID block:^(SKPaymentTransaction *transaction) {
        // Write business logic that should run once this product is purchased.
        isPremiumVersion = YES;
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setBool:TRUE  forKey:@"isPremiumVersion"];
        [prefs synchronize];
        

    }];
}

-(void)buyProduct:(NSString*)productID{
    

    [PFPurchase buyProduct:productID block:^(NSError *error) {
    if (!error) {
            // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
        }
    }];

}

-(void)restoreInApp{

    [PFPurchase restore];
}
@end
