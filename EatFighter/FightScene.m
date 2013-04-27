//
//  FightScene.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/26/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "FightScene.h"
#import "FightLayer.h"

@implementation FightScene

CGSize winSize;

- (id)init {
    self = [super init];
    if (self) {
        FightLayer *fightLayer = [FightLayer node];
        [self addChild:fightLayer z:1];
    }
    return self;
}


@end
