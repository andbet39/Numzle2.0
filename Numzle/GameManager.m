//
//  GameManager.m
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 06/02/13.
//
//

#import "GameManager.h"

@implementation GameManager

@synthesize operations;
@synthesize results,numberToHit,currentMathData,currentMatch;

+ (GameManager *)sharedInstance
{
    static GameManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)initzialize{

    operations = [[NSMutableArray alloc]init];
    results = [[NSMutableArray alloc]init];
    
}

-(void)addResult:(int)result{

    [results addObject:[NSNumber numberWithInt:result]];
}
-(void)addOperation:(NSString*)operation{

    [operations addObject:operation];
}
-(int)getOperationNumber{
    return [operations count];
}
-(int)getGrandTotal{

    int total =0;
    for (NSNumber * n  in results) {
        total+=[n intValue];
    }
    
    return total;
}
@end
