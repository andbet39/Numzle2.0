//
//  matchData.m
//  Numzle
//
//  Created by Andrea Terzani on 08/02/13.
//  Copyright (c) 2013 Andrea Terzani. All rights reserved.
//

#import "MatchDataClass.h"

@implementation MatchDataClass
@synthesize p1Results,p2Results,turnNumber,numbersToHit,matchfFase,p1ID,p2ID;

-(id)init{
    
    if (self=[super init]) {
        p1ID=@"";
        p2ID=@"";
        
        p1Results = [[NSMutableArray alloc]init];
        p2Results = [[NSMutableArray alloc]init];
        turnNumber = [NSNumber numberWithInt:0];
        numbersToHit =[[NSMutableArray alloc]init];
        
        matchfFase =@"CREATED";
        
        for (int i =0; i<4; i++) {
            [numbersToHit addObject:[NSNumber numberWithInt:(arc4random()%900)+100]];
        }
    }
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super init]) {
        
        self.p1Results = [aDecoder decodeObjectForKey:kP1Results];
        self.p2Results = [aDecoder decodeObjectForKey:kP2Results];
        self.p1ID = [aDecoder decodeObjectForKey:kP1ID];
        self.p2ID = [aDecoder decodeObjectForKey:kP2ID];
        
        self.p2Results = [aDecoder decodeObjectForKey:kP2Results];
        self.turnNumber = [aDecoder decodeObjectForKey:kTurnNumber];
        self.numbersToHit = [aDecoder decodeObjectForKey:kNumberToHit];
        self.matchfFase = [aDecoder decodeObjectForKey:kMatchfase];
        
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{


    [aCoder  encodeObject:self.p1Results forKey:kP1Results];
    [aCoder encodeObject:self.p2Results forKey:kP2Results];
    [aCoder  encodeObject:self.p1ID forKey:kP1ID];
    [aCoder encodeObject:self.p2ID forKey:kP2ID];
    
    [aCoder encodeObject:self.turnNumber forKey:kTurnNumber];
    [aCoder encodeObject:self.numbersToHit  forKey:kNumberToHit];
    [aCoder encodeObject:self.matchfFase forKey:kMatchfase];
    
}

-(NSString*)description{
    
  return [NSString stringWithFormat:@"MATCH Info - Turn:%@ | MatchFase:%@ |P1ResultCount:%d |P2Result:%d",
     self.turnNumber,self.matchfFase,[self.p1Results count],[self.p2Results count]];
    
}


@end
