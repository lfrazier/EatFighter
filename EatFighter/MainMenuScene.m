//
//  MainMenuScene.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/26/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "MainMenuScene.h"
#import "FightScene.h"
#import "AppDelegate.h"

@implementation MainMenuScene

- (id)init {
    self = [super init];
    if (self) {
        [CCMenuItemFont setFontName:@"Aldo the Apache"];
        [CCMenuItemFont setFontSize:50];
        CCMenuItemFont *startNew = [CCMenuItemFont itemWithString:@"New Game" target:self selector: @selector(newGame)];
        CCMenuItemFont *leaveReview = [CCMenuItemFont itemWithString:@"Write a Review" target:self selector: @selector(writeReview)];
        CCMenuItemFont *instructions = [CCMenuItemFont itemWithString:@"Instructions" target:self selector: @selector(showInstructions)];
        CCMenu *menu = [CCMenu menuWithItems:startNew, leaveReview, instructions, nil];
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu];
    }
    return self;
}

- (void)newGame {
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"stars" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants sortUsingDescriptors:sortDescriptors];
    NSDictionary *dict = [((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:0];
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionProgressRadialCW transitionWithDuration:0.5 scene:[[FightScene alloc] initWithRestaurant:dict]]];
}

- (void)writeReview {
    
}

- (void)showInstructions {
    
}

@end
