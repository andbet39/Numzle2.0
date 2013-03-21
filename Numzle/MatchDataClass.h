//
//  matchData.h
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kP1Results @"P1Results"
#define kP2Results  @"P2Results"
#define kP1ID @"P1Id"
#define kP2ID  @"P2Id"
#define kTurnNumber @"turnNumber"
#define kNumberToHit @"NumberToHit"
#define kMatchfase @"matchFase"


@interface MatchDataClass : NSObject<NSCoding>
{

    
}

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;

@property(nonatomic,strong)NSMutableArray * p1Results;
@property(nonatomic,strong)NSMutableArray * p2Results;
@property(nonatomic,strong)NSMutableArray * numbersToHit;
@property(nonatomic,strong)NSNumber *  turnNumber;
@property(nonatomic,strong)NSString * matchfFase;
@property(nonatomic,strong)NSString *p1ID;
@property(nonatomic,strong)NSString *p2ID;



@end
