//
//  FightLayer.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "FightLayer.h"
#import "FightScene.h"
#import "AppDelegate.h"
#import "ModalAlert.h"
#import "MainMenuScene.h"
#import "SimpleAudioEngine.h"

@implementation FightLayer

#define PUNCH_DAMAGE 25;

CGSize winSize;

- (id)initWithRestaurant:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        restaurant = dict;
        self.touchEnabled = YES;
        winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"stage.png"];
        background.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:background z:0];
        
        [self setUpCharacters];
        
        [self setUpJoystickAndButtons];
        
        [self setUpHealthBars];
        
        [self displayIntro];
        
    }
    return self;
}

- (void)setUpCharacters {
    //Controlled Object (Ryu)
    CCSpriteBatchNode *ryuNode = [CCSpriteBatchNode batchNodeWithFile:@"ryu.png"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"ryu.plist"];
    
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
    
    [self addChild:ryuNode z:5];
}

- (void)setUpHealthBars {
    
    float healthBarHeight = winSize.height/1.2;
    ryuHealthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"green_health_bar.png"]];
    ryuHealthBar.type = kCCProgressTimerTypeBar;
    [ryuHealthBar setScaleX:20];
    [ryuHealthBar setScaleY:10];
    ryuHealth = 100;
    ryuHealthBar.percentage = ryuHealth;
    ryuHealthBar.position = ccp(winSize.width/5, healthBarHeight);
    ryuHealthBar.midpoint = ccp(0, 0);
    ryuHealthBar.barChangeRate = ccp(1, 0);
    [self addChild:ryuHealthBar z:10];
    
    enemyHealthBar = [CCProgressTimer progressWithSprite:[CCSprite spriteWithFile:@"green_health_bar.png"]];
    enemyHealthBar.type = kCCProgressTimerTypeBar;
    [enemyHealthBar setScaleX:20];
    [enemyHealthBar setScaleY:10];
    enemyHealth = 100;
    enemyHealthBar.percentage = enemyHealth;
    enemyHealthBar.position = ccp(winSize.width/1.25,healthBarHeight);
    enemyHealthBar.midpoint = ccp(1, 0);
    enemyHealthBar.barChangeRate = ccp(1, 0);
    [self addChild:enemyHealthBar z:10];
    
    int labelOffset = 30;
    CCLabelTTF *ryuLabel = [CCLabelTTF labelWithString:@"FUELED" fontName:@"Aldo the Apache" fontSize:30];
    ryuLabel.position = ccp(winSize.width/5,healthBarHeight + labelOffset);
    ryuLabel.color = ccWHITE;
    [self addChild:ryuLabel z:10];
    
    CCLabelTTF *enemyLabel = [CCLabelTTF labelWithString:[restaurant objectForKey:@"name"] fontName:@"Aldo the Apache" fontSize:18];
    enemyLabel.position = ccp(winSize.width/1.25,healthBarHeight + labelOffset);
    enemyLabel.color = ccRED;
    [self addChild:enemyLabel z:10];
}

- (void)setUpJoystickAndButtons {
    //Joystick
    _joystick	= [ZJoystick joystickNormalSpriteFile:@"JoystickContainer_norm.png" selectedSpriteFile:@"JoystickContainer_trans.png" controllerSpriteFile:@"Joystick_norm.png"];
    _joystick.position	= ccp(_joystick.contentSize.width/2, _joystick.contentSize.height/2);
    _joystick.delegate	= self;				//Joystick Delegate
    _joystick.controlledObject  = ryu;     //we set our controlled object which the blue circle
    _joystick.speedRatio         = 4.0f;                //we set speed ratio, movement speed of blue circle once controlled to any direction
    _joystick.joystickRadius     = 50.0f;               //Added in v1.2
    [self addChild:_joystick z:10];
    
    float distanceFromEdge = 50;
    button = [CCSprite spriteWithFile:@"Joystick_button.png"];
    button.position = CGPointMake(winSize.width - distanceFromEdge, distanceFromEdge);
    [self addChild:button z:20];
}

- (void)displayIntro {
    NSString *review = [restaurant objectForKey:@"review"];
    if ([review isEqual:@""]) {
        review = @"No Review";
    }
    
    [ModalAlert Tell:[NSString stringWithFormat:@"%@\n\n%@", [restaurant objectForKey:@"name"], review] onLayer:self option1:@"Fight!" okBlock:^{
        // Enemy AI
        // The more stars the restaurant has, the harder it is to beat
        int stars = [(NSNumber *)[restaurant objectForKey:@"stars"] integerValue];
        
        // Complicated AI: come back to this
        /*double randomOffset = (arc4random() % 100) / 100.0;
         float interval = 6 - (stars + randomOffset);
         */
        
        // Simple AI: Stars are inversely, linearly proportional to punching speed.
        float interval = 6 - stars;
        [self schedule:@selector(enemyPunch) interval:interval repeat:-1 delay:5];
    }];
}

- (void)ryuPunch {
    // Animation
    [ryu stopAllActions];
    NSMutableArray *punchAnimFrames = [NSMutableArray array];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"9.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"10.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"11.png"]];
    
    CCAnimation *punchAnim = [CCAnimation
                             animationWithSpriteFrames:punchAnimFrames delay:0.2f];
    ryuPunchAction = [CCAnimate actionWithAnimation:punchAnim];
    [ryu runAction:ryuPunchAction];
    [ryu runAction:ryuIdleAction];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Woosh.mp3"];
    
    [self scheduleOnce:@selector(checkForRyuHit) delay:0.2];
}

- (void)checkForRyuHit {
    CGRect extendedReach = CGRectMake(ryu.boundingBox.origin.x - 10, ryu.boundingBox.origin.y - 10, ryu.boundingBox.size.width + 10, ryu.boundingBox.size.height + 10);
    if (CGRectIntersectsRect(extendedReach, enemy.boundingBox)) {
        enemyHealth -= PUNCH_DAMAGE;
        [enemyHealthBar setPercentage:enemyHealth];
        if (enemyHealth <= 0) {
            // Display something then start the next level
            [self ryuWon];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"Strong_Punch.mp3"];
    }
}

- (void)enemyPunch {
    // Animation
    [enemy stopAllActions];
    NSMutableArray *punchAnimFrames = [NSMutableArray array];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"9.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"8.png"]];
    [punchAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"7.png"]];
    
    CCAnimation *punchAnim = [CCAnimation
                              animationWithSpriteFrames:punchAnimFrames delay:0.2f];
    enemyPunchAction = [CCAnimate actionWithAnimation:punchAnim];
    [enemy runAction:enemyPunchAction];
    [enemy runAction:enemyIdleAction];
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"Woosh.mp3"];
    
    [self scheduleOnce:@selector(checkForEnemyHit) delay:0.2];
}

- (void)checkForEnemyHit {
    CGRect extendedReach = CGRectMake(enemy.boundingBox.origin.x - 10, enemy.boundingBox.origin.y - 10, enemy.boundingBox.size.width + 10, enemy.boundingBox.size.height + 10);
    if (CGRectIntersectsRect(extendedReach, ryu.boundingBox)) {
        ryuHealth -= PUNCH_DAMAGE;
        [ryuHealthBar setPercentage:ryuHealth];
        if (ryuHealth <= 0) {
            // Display something then put player on the twitter screen.
            [self enemyWon];
        }
        [[SimpleAudioEngine sharedEngine] playEffect:@"Strong_Punch.mp3" pitch:1.5 pan:1 gain:1];
    }
}

- (void)ryuWon {
    [self unscheduleAllSelectors];
    // If we've beaten the last enemy, go to the twitter screen.
    if (((AppController *)[UIApplication sharedApplication].delegate).currentRestaurantIndex == ((AppController *)[UIApplication sharedApplication].delegate).restaurants.count - 1) {
        [ModalAlert Message:[NSString stringWithFormat:@"You win! You can eat lunch at \n%@\n today!", [restaurant objectForKey:@"name"]] onLayer:self option1:@"Main Menu" yesBlock:^{
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene node]]];
        } option2:@"Tweet" noBlock:^{
            [self sendTweetWithRestaurant:[restaurant objectForKey:@"name"]];
        }];
    } else {
        ((AppController *)[UIApplication sharedApplication].delegate).currentRestaurantIndex++;
        NSDictionary *dict = [((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:((AppController *)[UIApplication sharedApplication].delegate).currentRestaurantIndex];
        [ModalAlert Tell:@"You win... for now. The next challenger approaches!" onLayer:self option1:@"Next" okBlock:^{
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[[FightScene alloc] initWithRestaurant:dict]]];
        }];
    }
}

- (void)enemyWon {
    [self unscheduleAllSelectors];
    int index = ((AppController *)[UIApplication sharedApplication].delegate).currentRestaurantIndex;
    if (index == 0) { // You lost on the first enemy. You get no lunch.
        [ModalAlert Message:@"You lose! You get no lunch today!" onLayer:self option1:@"Main Menu" yesBlock:^{
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene node]]];
        } option2:@"Tweet" noBlock:^{
            [self sendTweetWithRestaurant:@"-none-"];
        }];

    } else {
        NSDictionary *dict = [((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:index-1];
        [ModalAlert Message:[NSString stringWithFormat:@"You lose! You must eat lunch at \n%@\n today!", [dict objectForKey:@"name"]] onLayer:self option1:@"Main Menu" yesBlock:^{
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene node]]];
        } option2:@"Tweet" noBlock:^{
            [self sendTweetWithRestaurant:[dict objectForKey:@"name"]];
        }];
    }
}

- (void)sendTweetWithRestaurant:(NSString *)name {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if ([name isEqual:@"-none-"]) {
            [tweetController setInitialText:@"I won't be eating any lunch today, because I lost at #EatFighterII!"];
        } else {
            [tweetController setInitialText:[NSString stringWithFormat:@"I'll be eating lunch at %@ today, thanks to #EatFighterII!", name]];
        }
        tweetController.completionHandler = ^(SLComposeViewControllerResult result){
            //  dismiss the Tweet Sheet
            dispatch_async(dispatch_get_main_queue(), ^{
                [tweetController dismissViewControllerAnimated:NO completion:^{
                    NSLog(@"Tweet Sheet has been dismissed.");
                }];
            });
            [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5 scene:[MainMenuScene node]]];
        };
        [((AppController *)[UIApplication sharedApplication].delegate).navController presentViewController:tweetController animated:YES completion:nil];
    } else {
        [[[[UIAlertView alloc] initWithTitle:@"Cannot Send Tweet" message:@"You cannot tweet from this device at this time. Please check your settings and try again." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
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
    [ryu stopAllActions];
    [ryu runAction:ryuIdleAction];
}

@end
