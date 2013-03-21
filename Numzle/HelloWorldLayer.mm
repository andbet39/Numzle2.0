//
//  HelloWorldLayer.mm
//  NuzzleAlpha
//
//  Created by Andrea Terzani on 04/02/13.
//  Copyright __MyCompanyName__ 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#import "PhysicsSprite.h"
#import "Bubble.h"


enum {
	kTagParentNode = 1,
};


#pragma mark - HelloWorldLayer

@interface HelloWorldLayer()

@property(strong,nonatomic)id <HelloWorldLayerDelegate> delegate;

-(void) initPhysics;

@end

@implementation HelloWorldLayer

@synthesize delegate;

+(CCScene *) sceneWithDelegate:(id<HelloWorldLayerDelegate>)delegate
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
    [layer setDelegate:delegate];
    
    
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
        
		// enable events
		
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = false;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
        game_time=90;
        started=true;
        NSString * hintNumber = [NSString stringWithFormat:@"Target is %d",[[GameManager sharedInstance].numberToHit intValue] ] ;
        CCLabelBMFont * hintLabel = [CCLabelBMFont labelWithString:hintNumber fntFile:@"futuraBianco30.fnt"];
         hintLabel.position=ccp( s.width/2, s.height/2+100);
        hintLabel.scale=1.0;
        
        [self addChild:hintLabel z:12];
        
        CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:1 opacity:0];
        
        [hintLabel runAction:[CCSequence actions:
                    [CCDelayTime actionWithDuration:2],fadeIn, nil
                              ]];

        total_time=0;
        bubblesArray = [[NSMutableArray alloc]init];
		
		//Set up sprite
		
        
        CCSprite *backGround = [CCSprite spriteWithFile:@"background.png"];
        backGround.position=ccp( s.width/2, s.height/2);

        [self addChild:backGround z:0];
        
        CCSprite *keybackGround = [CCSprite spriteWithFile:@"keyBackground.png"];
        keybackGround.position=ccp( s.width/2, s.height-480-88+keybackGround.contentSize.height/2);
        
        [self addChild:keybackGround z:5];
        
        
        mainDisplay = [[DisplayLayer alloc]init];        
        [self addChild:mainDisplay z:10];
        
		
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"palline.png"];
		CCNode *parent = [CCNode node];


		[self addChild:parent z:0 tag:kTagParentNode];
		
         timeLabel = [CCLabelBMFont labelWithString:@"0:00" fntFile:@"helveticaBold17.fnt"];
        
  
            [self addChild:timeLabel z:11];
		timeLabel.position = ccp( 285, s.height-42);
        
        [self initHudButton];
        
		[self scheduleUpdate];
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:1],
                         [CCCallFunc actionWithTarget:self selector:@selector(playStartSound)],
                         nil]];
        tickScheduled=false;
	}
	return self;
}


-(void)playStartSound{
    [[SoundManager sharedInstance] playInizioGame];

}
-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	//[super dealloc];
}	
-(void)initHudButton{
    
    CCMenuItem *itemPiu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"buttonPlus.png"] selectedSprite:[CCSprite spriteWithFile:@"buttonPlusActive.png"] block:^(id sender) {
        
      [mainDisplay addOperand:@"+"];
		
	}];
    CCMenuItem *itemMeno = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"buttonMeno.png"] selectedSprite:[CCSprite spriteWithFile:@"buttonMenoActive.png"] block:^(id sender) {
            [mainDisplay addOperand:@"-"];
	}];
    CCMenuItem *itemPer =[CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"buttonPer.png"] selectedSprite:[CCSprite spriteWithFile:@"buttonPerActive.png"] block:^(id sender) {
            [mainDisplay addOperand:@"*"];
	}];
    CCMenuItem *itemDiviso = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"buttonDiviso.png"] selectedSprite:[CCSprite spriteWithFile:@"buttonDivisoActive.png"] block:^(id sender) {
            [mainDisplay addOperand:@"/"];
	}];
   
    
    CCMenu *menu = [CCMenu menuWithItems:itemPiu, itemMeno,itemPer,itemDiviso, nil];
	
	[menu alignItemsHorizontallyWithPadding:7];
    //[menu alignItemsVertically];
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height-435)];
    [self addChild:menu z:11];
    
    
    
    CCMenuItem *itemUguale = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"buttonUguale.png"] selectedSprite:[CCSprite spriteWithFile:@"buttonUgualeActive.png"] block:^(id sender) {
        [mainDisplay addCifer:@"="];
        
	}];
    
    CCMenu *menuUguale = [CCMenu menuWithItems:itemUguale, nil];
	
    [menuUguale setPosition:ccp( size.width/2, size.height-375)];
    [self addChild:menuUguale z:11];

}


-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
 	m_debugDraw->SetFlags(flags);		
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
 	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;		
		
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	//world->DrawDebugData();
	
	kmGLPopMatrix();
    timeLabel.string = [self timeToString: game_time];
}


-(void) update: (ccTime) dt
{
    int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
  
    NSMutableArray *  toRemove = [[NSMutableArray alloc]init];
    for(Bubble *bub in bubblesArray){
        
        b2Body * b =(b2Body*) bub.userData;
        b2Vec2 pos = b->GetWorldCenter();
        if(pos.y>550/PTM_RATIO){
            world->DestroyBody(b);
            [toRemove addObject:(bub)];
            [self removeChild:bub cleanup:YES];
        }
    }
    [bubblesArray removeObjectsInArray:toRemove];
    
    
    if(total_time>CCRANDOM_0_1()+0.3f){
    
        int rand = arc4random()%100;
        int bonus=0;
        if (rand>80) {
            bonus=1;
        }
        if (rand>97) {
            bonus=2;
        }
        Bubble * b = [[Bubble alloc]initWithWorld:world andPosition:CGPointMake(36+((arc4random()%5)*70), 20) andValue:arc4random()%10 andBonus:bonus andtexture:spriteTexture_];
        
        [self addChild:b];
        [bubblesArray addObject:b];
        total_time=0;
    }else{
        total_time+=dt;
    }
    
    game_time-=dt;
    
    if (game_time<=0) {
        NSLog(@"Fine della partita");
        game_time=0;
        [self GameOver];
    }
    
    if (game_time<11 && game_time>2 && !tickScheduled) {
        tickScheduled=true;
        [self runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:0.8],
                         [CCCallFunc actionWithTarget:self selector:@selector(playTickSound)],
                         nil]];
    }
}

-(void)playTickSound{
    tickScheduled=false;
    [[SoundManager sharedInstance]playTickSound];
}

-(void)GameOver
{
    game_time=1000;
    [delegate didEndGame:self];
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		b2Vec2 locationb = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
        
      
        
        NSMutableArray *  toRemove = [[NSMutableArray alloc]init];
        for(Bubble *bub in bubblesArray){
        
            b2Body * b =(b2Body*) bub.userData;
            b2Fixture *bf1 = b->GetFixtureList();
            if (bf1->TestPoint(locationb))
            {
                b2Vec2 pos = b->GetWorldCenter();
                CGSize s = [[CCDirector sharedDirector] winSize];

                if (pos.y*PTM_RATIO>s.height-480+115) {
                     [mainDisplay addBubble:bub];
                [bub hit];
                [toRemove addObject:bub];
                }
                   
                
                
            }
            
        }
        [bubblesArray removeObjectsInArray:toRemove];
        
        
        
    }
    
    
}

-(NSString*)timeToString:(float)time
{
    
    int total_second = time;
    
    int minuts = total_second/60;
    int seconds = total_second-(minuts*60);

    return [NSString stringWithFormat:@"%d:%02d",minuts,seconds ];
    
}


@end
