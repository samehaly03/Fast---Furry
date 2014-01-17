//
//  HUDLayer.h
//  PaperGlider
//
//  Created by Sameh Aly on 12/15/11.
//  Copyright 2011 Extreme Solution. All rights reserved.
//

#import "cocos2d.h"


@interface HUDLayer : CCLayer 
{
    CGSize winSize;
    
    BOOL isPaused;
    
    CCSprite *cheese;
    CCSprite *coin;
    
    CCLabelTTF *cheeseLabel;
    CCLabelTTF *coinLabel;
    
    CCSprite *summaryBackground_CCSprite;
    CCSprite *summaryReplay;
    CCLabelTTF *summaryLabel;
    CCLabelTTF *replayLabel;
    
    CCLabelTTF *label;
    
    CCSprite* pauseButton;
    CCSprite* mainmenuButton;
    CCSprite* resumeButton;
    CCSprite* playAgain;
    CCSprite* gotoMenuSprite;
    CCSprite* box;

    BOOL isShowingMenu;
    BOOL isShowingSummary;
}

@property (nonatomic, copy) CCLabelTTF *cheeseLabel;
@property (nonatomic, copy) CCLabelTTF *coinLabel;
@property (nonatomic, copy) CCSprite* pauseButton;
@property (nonatomic, copy) CCSprite* playAgain;
@property (nonatomic, copy) CCSprite* gotoMenuSprite;

- (void)createHUD;
- (void) setupSummary;
- (void) showSummaryWithScore:(int)score;
- (void) hideSummary;
- (void) setupMenu;
- (void) showMenu;
- (void) hideMenu;
- (void) gotoMenu;

@end
