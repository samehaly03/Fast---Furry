//
//  HUDLayer.m
//  PaperGlider
//
//  Created by Sameh Aly on 12/15/11.
//  Copyright 2011 Extreme Solution. All rights reserved.
//

#import "HUDLayer.h"
#import "MainMenu.h"
#import "GameScene.h"

@implementation HUDLayer

@synthesize cheeseLabel;
@synthesize coinLabel;
@synthesize pauseButton;
@synthesize playAgain;
@synthesize gotoMenuSprite;


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) 
    {
        winSize = [[CCDirector sharedDirector] winSize];
        
        [self createHUD];
        
        [self setupMenu];
        

	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for( UITouch *touch in touches ) 
    {
        
		CGPoint location = [touch locationInView: [touch view]];
        
		location = [[CCDirector sharedDirector] convertToGL: location];
        
        //location = [self convertToNodeSpace:location];
        
        CGRect pauseRect = CGRectMake(pauseButton.boundingBox.origin.x ,
                                      pauseButton.boundingBox.origin.y,
                                      pauseButton.boundingBox.size.width,
                                      pauseButton.boundingBox.size.height);
        
        CGRect menuRect = CGRectMake(mainmenuButton.boundingBox.origin.x ,
                                      mainmenuButton.boundingBox.origin.y,
                                      mainmenuButton.boundingBox.size.width,
                                      mainmenuButton.boundingBox.size.height);
        
        
        CGRect resumeRect = CGRectMake(resumeButton.boundingBox.origin.x ,
                                      resumeButton.boundingBox.origin.y,
                                      resumeButton.boundingBox.size.width,
                                      resumeButton.boundingBox.size.height);
        
        
        CGRect playAgainRect = CGRectMake(playAgain.boundingBox.origin.x ,
                                       playAgain.boundingBox.origin.y,
                                       playAgain.boundingBox.size.width,
                                       playAgain.boundingBox.size.height);
        
        CGRect gotoMenuRect = CGRectMake(gotoMenuSprite.boundingBox.origin.x ,
                                          gotoMenuSprite.boundingBox.origin.y,
                                          gotoMenuSprite.boundingBox.size.width,
                                          gotoMenuSprite.boundingBox.size.height);
        
        
        if (CGRectContainsPoint(pauseRect, location)) 
        {

            if (!isPaused) 
            {
                [[CCDirector sharedDirector] pause];
                isPaused = YES;
                [self showMenu];
            }
            
        }
        else if (CGRectContainsPoint(menuRect, location))
        {
            NSLog(@"rect menu");
            if (isPaused && isShowingMenu) 
            {
                [self gotoMenu];
                [[CCDirector sharedDirector] resume];
                isPaused = NO;
            }
        }
        
        else if (CGRectContainsPoint(resumeRect, location))
        {
             NSLog(@"rect resume");
            if (isPaused && isShowingMenu) 
            {
                [self hideMenu];
                [[CCDirector sharedDirector] resume];
                isPaused = NO;
            }
        }
        
        else if (CGRectContainsPoint(playAgainRect, location))
        {
             NSLog(@"rect play again");
            if (isPaused && isShowingSummary) 
            {
                [self hideSummary];

                [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
            }
        }
        else if (CGRectContainsPoint(gotoMenuRect, location))
        {
             NSLog(@"rect gotomenu");
            if (isPaused && isShowingSummary) 
            {
                [self gotoMenu];
            }
        }
         
    }
    
    
    /*
     if (isPaused && !isTouched)
     {
     [_hud hideSummary];
     [self startGame];
     
     }
     */
    //isTouched = YES;
    
    
}

- (void) setupSummary
{
    //CGSize screenSize = [CCDirector sharedDirector].winSize;

    summaryLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Lithos Pro" fontSize:24];
    //[self addChild:summaryLabel z:1002];
    //[summaryLabel setColor:ccc3(100,255,10)];
    
    [summaryLabel setOpacity:255];
    

    
}

- (void) showSummaryWithScore:(int)score
{
    isShowingSummary = YES;

    playAgain = [CCSprite spriteWithFile:@"playagain.png"];
    gotoMenuSprite = [CCSprite spriteWithFile:@"menu.png"];
    
    [playAgain setPosition:ccp(winSize.width/2, 160)];
    [self addChild:playAgain z:1002];

    [gotoMenuSprite setPosition:ccp(winSize.width/2, 80)];
    [self addChild:gotoMenuSprite z:1002];
    
    summaryLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Your Score: %i", score] fontName:@"Marker Felt" fontSize:28];
    [summaryLabel setPosition:ccp(winSize.width/2, 250)];
    [self addChild:summaryLabel z:1002];
    [summaryLabel setColor:ccc3(231,242,78)];

    box = [CCSprite spriteWithFile:@"box.png"];
    [box setPosition:ccp(winSize.width/2, winSize.height/2)];
    [box setOpacity:100];
    [self addChild:box z:1000];
    isPaused = YES;
    //[summaryLabel setOpacity:255];

}

- (void) hideSummary
{
    isShowingSummary = NO;
    isPaused = NO;
    [self removeChild:box cleanup:YES];
    [self removeChild:playAgain cleanup:YES];
    [self removeChild:gotoMenuSprite cleanup:YES];
    [self removeChild:summaryLabel cleanup:YES];
    [self removeChild:replayLabel cleanup:YES];
    
}

- (void) setupMenu
{
    mainmenuButton = [CCSprite spriteWithFile:@"menu.png"];
    [mainmenuButton setPosition:ccp(winSize.width/2, winSize.height *1/3)];
    [mainmenuButton setOpacity:0];
    [self addChild:mainmenuButton];
    
    resumeButton = [CCSprite spriteWithFile:@"resume.png"];
    [resumeButton setPosition:ccp(winSize.width/2, winSize.height *2/3)];
    [resumeButton setOpacity:0];
    [self addChild:resumeButton];
}

- (void) showMenu
{
    isShowingMenu = YES;
    [mainmenuButton setOpacity:255];
    [resumeButton setOpacity:255];
}

- (void) hideMenu
{
    isShowingMenu = NO;
    [mainmenuButton setOpacity:0];
    [resumeButton setOpacity:0];
    
}

- (void) gotoMenu
{
    CCScene * mainmenu = [MainMenu scene];
    CCTransitionFade * fadeTransitions = [CCTransitionFade transitionWithDuration:1 scene:mainmenu withColor:ccBLACK];
    
	[[CCDirector sharedDirector] replaceScene:fadeTransitions];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	// don't forget to call "super dealloc"
   // [self removeAllChildrenWithCleanup:YES];
   // [[CCTextureCache sharedTextureCache] removeUnusedTextures];
	[super dealloc];
}



- (void)createHUD
{
    //CGSize winSize = [[CCDirector sharedDirector] winSize]; 
    
    self.isTouchEnabled=YES;
    
    [self setupSummary];
    
    cheese = [CCSprite spriteWithFile:@"cheese.png"];
    [cheese setScale:0.6];
    [cheese setOpacity:150];
    [cheese setPosition:ccp(winSize.width/4, winSize.height - 20)];
    [self addChild:cheese];
    
    coin = [CCSprite spriteWithFile:@"coin.png"];
    [coin setScale:0.7];
    [coin setOpacity:150];
    [coin setPosition:ccp(winSize.width * 3/5, winSize.height - 20)];
    [self addChild:coin];
    
    cheeseLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:16];
    [cheeseLabel setPosition:ccp(winSize.width/4 + coin.contentSize.width *1.5, winSize.height - 20)];
    [cheeseLabel setColor:ccc3(255,255,183)];
    [self addChild:cheeseLabel];
    
    
    
    coinLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:16];
    [coinLabel setPosition:ccp(winSize.width * 3/5 + coin.contentSize.width *1.5, winSize.height - 20)];
    [coinLabel setColor:ccc3(255,255,183)];
    [self addChild:coinLabel];
    
    pauseButton = [CCSprite spriteWithFile:@"pause.png"];
    [pauseButton setPosition:ccp(winSize.width - pauseButton.contentSize.width, winSize.height - 20)];
    [pauseButton setOpacity:150];
    [self addChild:pauseButton];
}



@end



