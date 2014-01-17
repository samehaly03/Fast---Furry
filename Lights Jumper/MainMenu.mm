//
//  MainMenu.m
//  Lights Jumper
//
//  Created by Sameh Aly on 5/1/12.
//  Copyright 2012 Extreme Solution. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"

@implementation MainMenu

+(id) scene
{
	//CCLOG(@"===========================================");
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	CCScene* scene = [CCScene node];
	MainMenu* layer = [MainMenu node];
	[scene addChild:layer];
	return scene;
}

-(id) init
{
	if ((self = [super init]))
	{
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        self.isTouchEnabled = YES;
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        [self setupBackground];
        
        [self animateMouse];
        
        [self schedule:@selector(moveBackground) interval:1/5];
        
        [self setupButtons];
        
        [self setupAudio];

    }
    
    return self;
}

-(void) dealloc
{
    
    [self removeAllChildrenWithCleanup:YES];
    [self unscheduleAllSelectors];
    [self removeFromParentAndCleanup:YES];
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(void) onEnter
{
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onEnter];
}
//+++++++++++++++++++++++++++++++++++++++++++++++++
-(void) onEnterTransitionDidFinish
{
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	// must call super here:
	[super onEnterTransitionDidFinish];
}
//+++++++++++++++++++++++++++++++++++++++++++++++++
-(void) onExit
{
	//CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onExit];
}

- (void) animateMouse
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mouse.plist"];
    
    spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"mouse.png"];
    
    [self addChild:spriteSheet];
    
    flyAnimFrames = [[NSMutableArray array] retain];
    for(int i = 1; i <= 2; i++) 
    {
        [flyAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"mousefly%i.png", i]]];
    }
    

    _player = [CCSprite spriteWithSpriteFrameName:@"mousefly1.png"];
    
    [spriteSheet addChild:_player];
    
    flyAnim = [CCAnimation animationWithFrames:flyAnimFrames delay:0.1f];
    
    flyAction = [CCRepeatForever actionWithAction:
                 [CCAnimate actionWithAnimation:flyAnim restoreOriginalFrame:NO]];
    _player.position = ccp( winSize.width/2, winSize.height* 1/2);
    
    [_player runAction:flyAction];

    
}

- (void) setupButtons
{
    play = [CCSprite spriteWithFile:@"menu_play.png"];
    [play setPosition:ccp(winSize.width /2, winSize.height *1/5)];
    [self addChild:play];
    
    audio = [CCSprite spriteWithFile:@"audio off.png"];
    [audio setPosition:ccp(winSize.width /5, winSize.height *4/5)];
    [self addChild:audio];
    
    /*
    gameCenter = [CCSprite spriteWithFile:@"21-gamecenter-1 copy.png"];
    [gameCenter setPosition:ccp(winSize.width * 4/5, winSize.height *4/5)];
    [self addChild:gameCenter];
     */
}

- (void) toggleAudio
{
    isMusicOff = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMusicOff"];
    
    isMusicOff=!isMusicOff;
    
    [[NSUserDefaults standardUserDefaults] setBool:isMusicOff forKey:@"isMusicOff"];
    

    if (isMusicOff)
    {
        [audio setTexture:[[CCTextureCache sharedTextureCache] addImage:@"audio off.png"]];
    }
    else
    {
        [audio setTexture:[[CCTextureCache sharedTextureCache] addImage:@"audio.png"]];
    }
}

- (void) setupAudio
{
    isMusicOff = [[NSUserDefaults standardUserDefaults] boolForKey:@"isMusicOff"];
 
    if (isMusicOff)
    {
        [audio setTexture:[[CCTextureCache sharedTextureCache] addImage:@"audio off.png"]];
    }
    else
    {
        [audio setTexture:[[CCTextureCache sharedTextureCache] addImage:@"audio.png"]];
    }
    
}


- (void) setupBackground
{

    background1 = [CCSprite spriteWithFile:@"mainmenu.png"];
    background1.position = ccp(winSize.width/2, 160);
    [background1.textureAtlas.texture setAntiAliasTexParameters];
    [self addChild:background1 z:-10];

    
    background2 = [CCSprite spriteWithFile:@"mainmenu.png"];
    background2.position = ccp(winSize.width + 240, 160);
    [background2.textureAtlas.texture setAntiAliasTexParameters];
    [self addChild:background2 z:-10];
    
}

- (void) moveBackground
{
    // scroll our background
    background1.position = ccp( background1.position.x - 1.0, 160);
    background2.position = ccp( background2.position.x - 1.0, 160);
    
    //reset it's position if needed
    if (background1.position.x < -240)
    {
        [background1 setPosition:ccp(background2.position.x + winSize.width -2, 160)];
    }
    if (background2.position.x < -240)
    {
        [background2 setPosition:ccp(background1.position.x + winSize.width -2, 160)];
    }
}

-(void)gotoGame
{
    CCScene * gameScene = [GameScene scene];
    CCTransitionFade * fadeTransitions = [CCTransitionFade transitionWithDuration:1 scene:gameScene withColor:ccBLACK];
    
	[[CCDirector sharedDirector] replaceScene:fadeTransitions];

}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    for( UITouch *touch in touches ) 
    {
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        //location = [self convertToNodeSpace:location];

        CGRect playRect = CGRectMake(play.boundingBox.origin.x , play.boundingBox.origin.y,
                                     play.boundingBox.size.width, play.boundingBox.size.height);
        
        CGRect audioRect = CGRectMake(audio.boundingBox.origin.x , audio.boundingBox.origin.y,
                                     audio.boundingBox.size.width, audio.boundingBox.size.height);
        
        if (CGRectContainsPoint(playRect, location)) 
        {
            [self gotoGame];
        }
        
        else if (CGRectContainsPoint(audioRect, location))
        {
            [self toggleAudio];
        }
        
    }
    

}

@end
