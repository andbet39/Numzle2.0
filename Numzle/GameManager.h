//
//  GameManager.h
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 06/02/13.
//
//

#import <Foundation/Foundation.h>
#import "MatchDataClass.h"
#import <GameKit/GameKit.h>
@interface GameManager : NSObject
{

 
    
}

@property(nonatomic,strong)NSMutableArray *results;
@property(nonatomic,strong)NSMutableArray *operations;
@property(nonatomic,strong)NSNumber *numberToHit;
@property(nonatomic,strong)MatchDataClass *currentMathData;
@property(nonatomic,strong)GKTurnBasedMatch *currentMatch;


+ (GameManager *)sharedInstance;
-(void)initzialize;
-(void)addResult:(int)result;
-(void)addOperation:(NSString*)operation;
-(int)getGrandTotal;

-(int)getOperationNumber;
@end
