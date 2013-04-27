//
//  FightLayer.h
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "CCLayer.h"
#import "ZJoystick.h"
#import "Restaurant.h"

@interface FightLayer : CCLayer<ZJoystickDelegate> {
    CCSprite *ryu;
    CCSprite *enemy;
    
    CCAction *ryuIdleAction;
    CCAction *enemyIdleAction;
    
    CCAction *ryuWalkAction;
    CCAction *enemyWalkAction;
    
    CCAction *ryuPunchAction;
    CCAction *enemyPunchAction;
    
    float ryuHealth;
    float enemyHealth;
    CCProgressTimer *ryuHealthBar;
    CCProgressTimer *enemyHealthBar;
    
    Restaurant *restaurant;
    CCSprite *button;

}

@end