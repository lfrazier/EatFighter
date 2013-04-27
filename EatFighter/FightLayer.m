//
//  FightLayer.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "FightLayer.h"
#import "FightScene.h"

@implementation FightLayer

CGSize winSize;

- (id)init {
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"stage.png"];
        background.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:background z:0];
        
        [self setUpCharacters];
        
        [self setUpJoystickAndButtons];
        
        [self setUpHealthBars];
        
    }
    return self;
}

- (void)setUpCharacters {
    //Controlled Object (Ryu)
    CCSpriteBatchNode *ryuNode = [CCSpriteBatchNode batchNodeWithFile:@"ryu-hd.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ryu-hd.plist"];
    
    ryu  = [CCSprite spriteWithSpriteFrameName:@"4.png"];
    ryu.position   = ccp(winSize.width/6, winSize.height/3);
    
    NSMutableArray *ryuIdleAnimFrames = [NSMutableArray array];
    [ryuIdleAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"12.png"]];
    [ryuIdleAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"13.png"]];
    CCAnimation *ryuIdleAnim = [CCAnimation
                                animationWithSpriteFrames:ryuIdleAnimFrames delay:0.5f];
    ryuIdleAction = [[CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:ryuIdleAnim]] retain];
    [ryu runAction:ryuIdleAction];
    [ryuNode addChild:ryu z:10];
    
    
    // Enemy (basically a clone of Ryu)
    enemy = [CCSprite spriteWithSpriteFrameName:@"4.png"];
    enemy.position   = ccp(winSize.width/1.2, winSize.height/3);
    
    NSMutableArray *enemyIdleAnimFrames = [NSMutableArray array];
    [enemyIdleAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"12.png"]];
    [enemyIdleAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"13.png"]];
    CCAnimation *enemyIdleAnim = [CCAnimation
                                  animationWithSpriteFrames:enemyIdleAnimFrames delay:0.5f];
    enemyIdleAction = [[CCRepeatForever actionWithAction:
                        [CCAnimate actionWithAnimation:enemyIdleAnim]] retain];
    [enemy runAction:enemyIdleAction];
    
    enemy.flipX = YES;
    float r = arc4random() % 255;
    float g = arc4random() % 255;
    float b = arc4random() % 255;
    enemy.color = ccc3(r, g, b);
    [ryuNode addChild:enemy z:5];
    
    // Enemy AI
    //[self schedule:@selector(enemyPunch) interval:1 repeat:-1 delay:1];
    
    [self addChild:ryuNode z:5];
}

- (void)setUpHealthBars {
    ryuHealthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"green_health_bar.png"]];
    ryuHealthBar.type = kCCProgressTimerTypeBar;
    [ryuHealthBar setScaleX:20];
    [ryuHealthBar setScaleY:10];
    ryuHealth = 100;
    ryuHealthBar.percentage = ryuHealth;
    ryuHealthBar.position = ccp(winSize.width/5,winSize.height/1.1);
    [self addChild:ryuHealthBar z:10];
    
    enemyHealthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"green_health_bar.png"]];
    enemyHealthBar.type = kCCProgressTimerTypeBar;
    [enemyHealthBar setScaleX:20];
    [enemyHealthBar setScaleY:10];
    enemyHealth = 100;
    enemyHealthBar.percentage = enemyHealth;
    enemyHealthBar.position = ccp(winSize.width/1.25,winSize.height/1.1);
    [self addChild:enemyHealthBar z:10];
    
}

- (void)ryuPunch {
    // Animation
    [ryu stopAllActions];
    NSMutableArray *punchAnimFrames = [NSMutableArray array];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"9.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"10.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"11.png"]];
    
    CCAnimation *punchAnim = [CCAnimation
                             animationWithSpriteFrames:punchAnimFrames delay:0.25f];
    ryuPunchAction = [CCAnimate actionWithAnimation:punchAnim];
    [ryu runAction:ryuPunchAction];
    [ryu runAction:ryuIdleAction];
    
    [self scheduleOnce:@selector(checkForRyuHit) delay:0.5];
}

- (void)checkForRyuHit {
    CGRect extendedReach = CGRectMake(ryu.boundingBox.origin.x - 10, ryu.boundingBox.origin.y - 10, ryu.boundingBox.size.width + 10, ryu.boundingBox.size.height + 10);
    if (CGRectIntersectsRect(extendedReach, enemy.boundingBox)) {
        enemyHealth -= 25;
        [enemyHealthBar setPercentage:enemyHealth];
        if (enemyHealth <= 0) {
            // Display something then start the next level
            [[CCDirector sharedDirector] replaceScene:[FightScene node]];
        }
    }
}

- (void)enemyPunch {
    // Animation
    [enemy stopAllActions];
    NSMutableArray *punchAnimFrames = [NSMutableArray array];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"9.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"10.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"11.png"]];
    
    CCAnimation *punchAnim = [CCAnimation
                              animationWithSpriteFrames:punchAnimFrames delay:0.1f];
    enemyPunchAction = [CCAnimate actionWithAnimation:punchAnim];
    [enemy runAction:enemyPunchAction];
    [self scheduleOnce:@selector(checkForEnemyHit) delay:0.5];
}

- (void)checkForEnemyHit {
    CGRect extendedReach = CGRectMake(enemy.boundingBox.origin.x - 10, enemy.boundingBox.origin.y - 10, enemy.boundingBox.size.width + 10, enemy.boundingBox.size.height + 10);
    if (CGRectIntersectsRect(extendedReach, ryu.boundingBox)) {
        ryuHealth -= 25;
        [ryuHealthBar setPercentage:ryuHealth];
        if (ryuHealth <= 0) {
            // Display something then put player on the twitter screen.
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(button.boundingBox, touchLocation)) {
        [self ryuPunch];
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
}

- (void)setUpJoystickAndButtons {
    //Joystick
    ZJoystick *_joystick	= [ZJoystick joystickNormalSpriteFile:@"JoystickContainer_norm.png" selectedSpriteFile:@"JoystickContainer_trans.png" controllerSpriteFile:@"Joystick_norm.png"];
    _joystick.position	= ccp(_joystick.contentSize.width/2, _joystick.contentSize.height/2);
    _joystick.delegate	= self;				//Joystick Delegate
    _joystick.controlledObject  = ryu;     //we set our controlled object which the blue circle
    _joystick.speedRatio         = 4.0f;                //we set speed ratio, movement speed of blue circle once controlled to any direction
    _joystick.joystickRadius     = 50.0f;               //Added in v1.2
    [self addChild:_joystick z:10];
    
    float distanceFromEdge = 50;
    button = [CCSprite spriteWithFile:@"Joystick_button.png"];
    button.position = CGPointMake(winSize.width - distanceFromEdge, distanceFromEdge);
    [self addChild:button z:10];
}

- (void)joystickControlBegan {
    [ryu stopAllActions];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    [walkAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"12.png"]];
    [walkAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"13.png"]];
    [walkAnimFrames addObject:
     [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"6.png"]];
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.25f];
    ryuWalkAction = [CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:walkAnim]];
    [ryu runAction:ryuWalkAction];
    
}

- (void)joystickControlMoved {
    
}

- (void)joystickControlEnded {
    [ryu stopAction:ryuWalkAction];
    [ryu runAction:ryuIdleAction];
}

@end
