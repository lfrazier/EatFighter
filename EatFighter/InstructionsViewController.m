//
//  InstructionsViewController.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/27/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

@synthesize label, textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    textView.font = [UIFont fontWithName:@"Aldo the Apache" size:24];
    textView.text = @"'EAT FIGHTER II' is a game that pits you against nearby restaurants. Square off against lower rated restaurants to get to the better rated ones. Fight your way to the top to get the best lunch! \n\nNew Game:\nFight your way up through the ladder. If you want to eat at a restaurant, you must defeat it first. If you lose, you must eat lunch at the last restaurant that you defeated. If you beat them all, you win the game (and can eat at the best restaurant)!\nMove using the joystick on the left, and punch with the 'P' button on the right.\n\nWrite Review:\nWrite reviews and give star ratings for restuarants. Remove a restaurant from the table to never see it again. Remember, star ratings impact the order that you will face the restaurants (lowest-rated to highest-rated).\n\nInstructions:\nThese are the instructions.";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
