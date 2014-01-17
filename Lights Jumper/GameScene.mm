//
//  HelloWorldLayer.mm
//  Lights Jumper
//
//  Created by Sameh Aly on 4/16/12.
//  Copyright Extreme Solution 2012. All rights reserved.
//


// Import the interfaces
#import "GameScene.h"
#import "Light.h"
#import "SimpleAudioEngine.h"
#import "iAd/ADBannerView.h"


//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


// HelloWorldLayer implementation
@implementation GameScene

@synthesize _hud;

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"bannerview did not receive any banner due to %@", error);}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{NSLog(@"bannerview was selected");}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{return willLeave;}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {NSLog(@"banner was loaded");}

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
    HUDLayer *hud = [HUDLayer node];
	[scene addChild:hud z:10000]; // <- ADD new layer to your scene!
    
	// 'layer' is an autorelease object.
	GameScene *layer = [[[GameScene alloc] initWithHUD:hud] autorelease];
	
	// add layer as a child to scene
	[scene addChild: layer z:9999];
	
	// return the scene
	return scene;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return NO;
}
// on "init" you need to initialize your instance
- (id)initWithHUD:(HUDLayer *)hud
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
    {
		
        _hud = hud;
        
        
        winSize = [[CCDirector sharedDirector] winSize];
        
		// enable touches
		self.isTouchEnabled = YES;
        
        isMusicOff = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMusicOff"];
        
        if (!isMusicOff) 
        {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Guiton Sketch.mp3" loop:YES];
        }
        /*
         ///////iAD code////////////////////
         UIViewController *controller = [[UIViewController alloc] init];
         controller.view.frame = CGRectMake(0,0,480,32);
         //controller.view.frame = CGRectMake(136, 135, 320, 32);
         // controller.view.transform = CGAffineTransformMakeRotation(M_PI / 2.0); // turn 180 degrees
         
         //From the official iAd programming guide
         ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
         
         adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
         
         adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
         
         [controller.view addSubview:adView];
         
         //Then I add the adView to the openglview of cocos2d
         [[[CCDirector sharedDirector] openGLView] addSubview:controller.view];
         /////////////////////////////////
         */
        
        boxWidth = 51200*8;
        boxHeight = 1280;
		
        xForce = 5.0;
        yForce = 0.3;
        
        [self setupBackground];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mouse.plist"];
        
        spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mouse.png"];
        
        [self addChild:spriteSheet];
        
        _player = [CCSprite spriteWithSpriteFrameName:@"rocketmouse_1_run.png"];
        
        [spriteSheet addChild:_player];
        
        //[self setupSummary];
        
        

		
        [self setupWorld];
		
        [self resetPlayerBody];
        
        /*
         // Debug Draw functions
         m_debugDraw = new GLESDebugDraw( PTM_RATIO );
         _world->SetDebugDraw(m_debugDraw);
         
         uint32 flags = 0;
         flags += b2DebugDraw::e_shapeBit;
         //		flags += b2DebugDraw::e_jointBit;
         //		flags += b2DebugDraw::e_aabbBit;
         //		flags += b2DebugDraw::e_pairBit;
         //		flags += b2DebugDraw::e_centerOfMassBit;
         m_debugDraw->SetFlags(flags);		
         */
        
        
		
        [self startGame];
	}
	return self;
}


/*
 -(void) draw
 {
 // Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
 // Needed states:  GL_VERTEX_ARRAY, 
 // Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
 glDisable(GL_TEXTURE_2D);
 glDisableClientState(GL_COLOR_ARRAY);
 glDisableClientState(GL_TEXTURE_COORD_ARRAY);
 
 _world->DrawDebugData();
 
 // restore default GL states
 glEnable(GL_TEXTURE_2D);
 glEnableClientState(GL_COLOR_ARRAY);
 glEnableClientState(GL_TEXTURE_COORD_ARRAY);
 
 }
 */

- (void) scale:(CGFloat) newScale scaleCenter:(CGPoint) scaleCenter 
{
    // scaleCenter is the point to zoom to.. 
    // If you are doing a pinch zoom, this should be the center of your pinch.
    
    // Get the original center point.
    CGPoint oldCenterPoint = ccp(scaleCenter.x * self.scale, scaleCenter.y * self.scale); 
    
    // Set the scale.
    self.scale = newScale;
    
    // Get the new center point.
    CGPoint newCenterPoint = ccp(scaleCenter.x * self.scale, scaleCenter.y * self.scale); 
    
    // Then calculate the delta.
    CGPoint centerPointDelta  = ccpSub(oldCenterPoint, newCenterPoint);
    
    // Now adjust your layer by the delta.
    self.position = ccpAdd(self.position, centerPointDelta);
}

-(void) tick: (ccTime) dt
{
    
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Add code here to do background processing
        //
        //
        int32 velocityIterations = 10;
        int32 positionIterations = 10;
        
        // Instruct the world to perform a single step of simulation. It is
        // generally best to keep the time step and iterations fixed.
        _world->Step(dt, velocityIterations, positionIterations);
        
        //[self scale:0.8 scaleCenter:_player.position];
        
        
        // Amount to scale the layer
        float zoomScale;
        
        // The range where zooming occurs
        float heightRange = 1200 - 10;
        
        // Get the ratio of the player's altitude with respect to the zoom range
        zoomScale = (1200 - _player.position.y) / heightRange;
        
        // Use a uniform distribution for zooming within the zoom range
        zoomScale = 0.7 + (1 - 0.7) * zoomScale;
        
        // Check the bounds for the scale
        if (zoomScale > 1)
            zoomScale = 1;
        if (zoomScale < 0.7)
            zoomScale = 0.7;
        
        // Perform zoom
        //NSLog(@"hight is %f", _body->GetPosition().y);
        
        if (_body->GetLinearVelocity().x < xForce) 
        {
            _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y));
        }
        
        if (isTouched) 
        {
            
            isWalking = NO;
            
            if (!isFlying) 
            {
                
                [_player stopAllActions];
                //setup fly animation
                
                flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
                flyAction = [CCRepeatForever actionWithAction:
                             [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
                
                [_player runAction:flyAction];
                isFlying = YES; 
            }
            
            _body->SetLinearVelocity(b2Vec2(_body->GetLinearVelocity().x,
                                            _body->GetLinearVelocity().y + yForce));
        }
        
        if (_body->GetPosition().y < 2.0) 
        {
            
            if (!isWalking && !isTouched && !isDying) 
            {
                walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
                
                
                walkAction = [CCRepeatForever actionWithAction:
                              [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
                
                [_player runAction:walkAction];
                isWalking = YES;
            }
            
        }
        
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
            //Iterate over the bodies in the physics world
            for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext())
            {
                if (b->GetUserData() != NULL) {
                    //Synchronize the AtlasSprites position and rotation with the corresponding body
                    //CCSprite *myActor = (CCSprite*)b->GetUserData();
                    _player.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                    //myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
                }	
            }
            
            
            self.scale = zoomScale;
            
        });
    });
    
}

- (void)checkForCollision
{
    if (isPaused) 
    {
        return;
    }
    
    playerRect = CGRectMake(_player.boundingBox.origin.x, _player.boundingBox.origin.y,
                            _player.boundingBox.size.width, _player.boundingBox.size.height);
    
    for (CCSprite *sprite in [self children]) 
    {
        spriteRect = CGRectMake(sprite.boundingBox.origin.x , 
                                sprite.boundingBox.origin.y,
                                sprite.boundingBox.size.width, 
                                sprite.boundingBox.size.height);
        
        
        
        if (CGRectIntersectsRect(playerRect, spriteRect)) 
        {
            if (sprite.tag == 1) 
            {
                isPaused = YES;
                [_hud showSummaryWithScore:score+cheeseScore+timeScore];
                [self stopGame];
            }
            else if (sprite.tag == 10)
            {
                score++;
                
                [self setLabels];
                
                if (!isMusicOff) 
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"22757__franciscopadilla__54-tambourine.wav"];
                }
                
                [self removeChild:sprite cleanup:YES];
                
            }
            else if (sprite.tag == 11)
            {
                cheeseScore++;
                
                [self setLabels];
                
                if (!isMusicOff) 
                {
                    [[SimpleAudioEngine sharedEngine] playEffect:@"20272__koops__apple-crunch-09.wav"];
                }
                
                [self removeChild:sprite cleanup:YES];
            }
            
        }
    }
    
}

-(void)addCoin
{
    if (isPaused) 
    {
        return;
    }
    
    Light *target = nil;
    
    // Determine where to spawn the target along the Y axis
	int minY = target.contentSize.height + 100;
	int maxY = boxHeight - 50 - target.contentSize.height;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
    
    
    target = [Coin light];
    
    target.tag = 10;
    
    
    target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), actualY);
    
    [self addChild:target];
}


-(void)addTarget 
{
    
	if (isPaused) 
    {
        return;
    }
    
	//CCSprite *target = [CCSprite spriteWithFile:@"shark.gif" rect:CGRectMake(0, 0, 32, 32)]; 
	
    
	Light *target = nil;
    
    // Determine where to spawn the target along the Y axis
	int minY = target.contentSize.height + 100;
	int maxY = boxHeight  - target.contentSize.height;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;
    
    int t = timeScore;
    
    if (t < 20) 
    {
        t = 2;
    }
    else if (t < 30 && t > 20)
    {
        t = 3;
    }
    else if (t < 40 && t > 30)
    {
        t = 4;
    }
    else if (t < 60 && t > 40)
    {
        t = 5;
    }
    else 
    {
        t = 6;
    }
    
    int i = arc4random() % t;
    
	if (i == 0) 
    {
        //coins
		target = [Coin light];
        
        target.tag = 10;
        
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), actualY);
        
        [self addChild:target];
        
	}
	else if (i == 1)
    {
        //laser
		target = [Laser light];
        target.tag = 1;
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), actualY);
        
        [self addChild:target];
        
        
        
	}
    else if (i == 2)
    {
        //cat
		target = [Cat light];
        target.tag = 1;
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), 80);
        
        //[target setColor:ccc3(100, 0, 0)];
        
        [self addChild:target];
        
        
	}
    else if (i == 3)
    {
        //dog
        target = [Dog light];
        target.tag = 1;
        
        
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), 80);
        
        [self addChild:target];
        
        
    }
    else if (i == 4)
    {
        
        
        //cheese
        target = [Cheese light];
        target.tag = 11;
        
        
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), 80);
        
        [self addChild:target];
        
        
    }
    else 
    {
        //laser
		target = [Laser light];
        target.tag = 1;
        
        target.position = ccp(_player.position.x + 480*3 + (target.contentSize.width/2), actualY);
        
        [self addChild:target];
        
        
        
        
    }
}
- (void) spriteMoveFinished:(id)sender
{
	
	CCSprite *sprite = (CCSprite *)sender;
	[self removeChild:sprite cleanup:YES];
    
	
    
}

- (void) gameLogic:(ccTime)dt
{
    for (CCSprite *sprite in [self children]) 
    {
        if (sprite.position.x < _player.position.x -480) 
        {
            if (sprite.tag == 1 || sprite.tag == 10 || sprite.tag == 11) 
            {
                [self removeChild:sprite cleanup:YES];
            }
            
        }
    }
    
	[self addTarget];
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) 
    {
        
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        location = [self convertToNodeSpace:location];
        
        CGRect pauseRect = CGRectMake(_hud.pauseButton.boundingBox.origin.x ,
                                      _hud.pauseButton.boundingBox.origin.y,
                                      _hud.pauseButton.boundingBox.size.width,
                                      _hud.pauseButton.boundingBox.size.height);
       
        /*
        CGRect playAgainRect = CGRectMake(_hud.playAgain.boundingBox.origin.x ,
                                          _hud.playAgain.boundingBox.origin.y,
                                          _hud.playAgain.boundingBox.size.width,
                                          _hud.playAgain.boundingBox.size.height);
        
        CGRect gotoMenuRect = CGRectMake(_hud.gotoMenuSprite.boundingBox.origin.x ,
                                         _hud.gotoMenuSprite.boundingBox.origin.y,
                                         _hud.gotoMenuSprite.boundingBox.size.width,
                                         _hud.gotoMenuSprite.boundingBox.size.height);
        */
        if (!isPaused) 
        {
            if (CGRectContainsPoint(pauseRect, location)) 
            {
                [[CCDirector sharedDirector] pause];
                isPaused = YES;
            }
        }
        /*
        if (isPaused)
        {
            NSLog(@"ispaused fired");

            
            if (CGRectContainsPoint(playAgainRect, location))
            {
                NSLog(@"rect play again");
                [_hud hideSummary];
                [self startGame];
            }
            else if (CGRectContainsPoint(gotoMenuRect, location))
            {
                NSLog(@"rect gotomenu");
                [_hud gotoMenu];
            }
            
        }
         */
    }
    
    
    

    
    isTouched = YES;
    
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouched = NO;
    
    for( UITouch *touch in touches ) 
    {
        
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        location = [self convertToNodeSpace:location];
        
        if (!isPaused) 
        {
            [_player stopAllActions];
            
            isWalking = NO;
            isFlying = NO;
            
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rocketmouse_6_fall.png"];
            
            [_player setDisplayFrame:frame];
        }

    }

    
}

- (void) setupWorld
{
    
    // Create a world
    b2Vec2 gravity = b2Vec2(0.0f, -5.0);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,1.5);
    groundBody = _world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &groundBox;
    
    
    //floor
    groundBox.SetAsEdge(b2Vec2(0/PTM_RATIO,1.5/PTM_RATIO), b2Vec2(boxWidth/PTM_RATIO, 1.5/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    
    //left
    groundBox.SetAsEdge(b2Vec2(0/PTM_RATIO,1.5/PTM_RATIO), b2Vec2(0/PTM_RATIO, boxHeight/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    
    
    //
    groundBox.SetAsEdge(b2Vec2(0/PTM_RATIO, boxHeight/PTM_RATIO), 
                        b2Vec2(boxWidth/PTM_RATIO, boxHeight/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    
    
    
    //
    groundBox.SetAsEdge(b2Vec2(boxWidth/PTM_RATIO, 
                               boxHeight/PTM_RATIO), b2Vec2(boxWidth/PTM_RATIO, 1.5/PTM_RATIO));
    
    groundBody->CreateFixture(&boxShapeDef);
    
    
}

- (void) resetPlayerBody
{
    
    [self destroyPlayerBody];
    
    
    // Create ball body and shape
    
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(1.5, 2.5);
    ballBodyDef.userData = _player;
    ballBodyDef.fixedRotation = NO;
    
    
    
    _body = _world->CreateBody(&ballBodyDef);
    
    _body->SetAwake(YES);
    //create rectangle shape and add it to body
    
    
    
    b2CircleShape rect;
    rect.m_radius = 0.43;
    
    b2FixtureDef rectShapeDef;
    rectShapeDef.shape = &rect;
    rectShapeDef.density = 0.5;
    rectShapeDef.friction = 0.5;
    rectShapeDef.restitution = 0.1f;
    
    
    _body->CreateFixture(&rectShapeDef);
    
    _body->SetLinearVelocity(b2Vec2(xForce, 0.0));
    
    [self runAction:[CCFollow actionWithTarget:_player worldBoundary:CGRectMake(0, 0, boxWidth, boxHeight-200)]];
}


- (void) destroyPlayerBody
{
    
    if (_body != NULL) 
    {
        
        _world->DestroyBody(_body);
    }
    
}


-(void)startGame
{
    isDying = NO;
    
    //setup walk animation
    walkAnimFrames = [[NSMutableArray array] retain];
    
    
    
    for(int i = 1; i <= 4; i++) 
    {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"rocketmouse_%i_run.png", i]]];
    }
    
    
    walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
    
    
    
    
    
    walkAction = [CCRepeatForever actionWithAction:
                  [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
    
    if ([_player runAction:walkAction]) 
    {
        isWalking = YES;
    }
    
    
    
    //setup fly animation
    flyAnimFrames = [[NSMutableArray array] retain];
    for(int i = 1; i <= 2; i++) 
    {
        [flyAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"mousefly%i.png", i]]];
    }
    flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
    flyAction = [CCRepeatForever actionWithAction:
                 [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
    
    _player.position = ccp( _player.boundingBox.size.width *2, winSize.height/2);
    
    
    
    score = 0;
    cheeseScore = 0;
    timeScore = 0;
    isPaused = NO;
    isTouched = NO;
    
    [self setLabels];
    [self resetPlayerBody];
    
    [self schedule:@selector(gameLogic:) interval:1.5];
    [self schedule:@selector(tick:)interval:1/30];
    [self schedule:@selector(checkForCollision)interval:1/5];
    [self schedule:@selector(gameTimer) interval:1.0];
    [self schedule:@selector(addCoin) interval:0.5];
}

-(void)stopGame
{
    isDying = YES;
    
    isPaused = YES;
    
    [_player stopAllActions];
    
    
    [self unschedule:@selector(gameLogic:)];
    [self unschedule:@selector(tick:)];
    [self unschedule:@selector(checkForCollision)];
    [self unschedule:@selector(gameTimer)];
    [self unschedule:@selector(addCoin)];
    
}

-(void)setLabels
{
    
    NSString * temp =[[NSString alloc]initWithFormat:@"%d",score];
    [_hud.coinLabel setString:temp];
    
    NSString*  temp2=[[NSString alloc]initWithFormat:@"%d",cheeseScore];
    [_hud.cheeseLabel setString:temp2];
    
    
    
    [temp release];
    temp=nil;
    
    [temp2 release];
    temp2=nil;
    
}

- (void) setupBackground
{
    
    
    ccTexParams params = {GL_LINEAR,GL_LINEAR,GL_REPEAT,GL_REPEAT};
    
    CCSprite *background01 = [CCSprite spriteWithFile:@"LargeEmptyBG.png" rect:CGRectMake(0, 0, boxWidth, 1536)];
    
    background01.anchorPoint = ccp(0, 0);
    background01.position = ccp(0, 0);
    background01.tag = 0;
    
    [background01.texture setTexParameters:&params];
    [self addChild:background01 z:-10];
    
    /*
     CCSprite *background02 = [CCSprite spriteWithFile:@"BG0102.png" rect:CGRectMake(0, 0, boxWidth, 4096)];
     
     background02.anchorPoint = ccp(0, 0);
     background02.position = ccp(0, 0);
     background02.tag = 0;
     
     [background02.texture setTexParameters:&params];
     [self addChild:background02 z:-20];
     */
    
}

- (void)gameTimer
{
    timeScore++;
    if (timeScore > 20 && timeScore < 30) 
    {
        xForce = 6.5;
        yForce = 0.3;
        _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y + yForce));
        NSLog(@"2222");
    }
    if (timeScore > 30 && timeScore < 40) 
    {
        xForce = 7.5;
        yForce = 0.4;
        _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y + yForce));
        NSLog(@"33333");
    }
    if (timeScore > 40 && timeScore < 50) 
    {
        xForce = 8.5;
        yForce = 0.4;
        _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y + yForce));
        NSLog(@"44444");
    }
    if (timeScore > 50 && timeScore < 60) 
    {
        xForce = 10.0;
        yForce = 0.5;
        _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y + yForce));
        NSLog(@"55555");
    }
    if (timeScore > 60) 
    {
        xForce = 12.0;
        yForce = 0.5;
        _body->SetLinearVelocity(b2Vec2(xForce, _body->GetLinearVelocity().y + yForce));
        NSLog(@"66666");
    }

}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    
	// in case you have something to dealloc, do it in this method
	delete _world;
	_world = NULL;
	
	delete m_debugDraw;
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
