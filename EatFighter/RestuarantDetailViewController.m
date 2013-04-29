//
//  RestuarantDetailViewController.m
//  EatFighter
//
//  Created by Lauren Frazier on 4/28/13.
//  Copyright (c) 2013 Lauren Frazier. All rights reserved.
//

#import "RestuarantDetailViewController.h"
#import "AppDelegate.h"

@interface RestuarantDetailViewController ()

@end

@implementation RestuarantDetailViewController

@synthesize textField, label,stepper;

- (id)initWithRestaurantID:(int)restID {
    self = [super init];
    if (self) {
        restaurantID = restID;
        self.title =  [NSString stringWithFormat:@"%@ Review",[[((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:restaurantID] objectForKey:@"name"]];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == textField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField{
    NSLog(theTextField.text);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:restaurantID]];
    [dict setObject:theTextField.text forKey:@"review"];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants replaceObjectAtIndex:restaurantID withObject:dict];
    
    // Save array
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"restaurants.txt"];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants writeToFile:fileName atomically:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    if (value == 1) {
        [label setText:[NSString stringWithFormat:@"%d Star", (int)value]];
    } else {
        [label setText:[NSString stringWithFormat:@"%d Stars", (int)value]];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:restaurantID]];
    [dict setObject:[NSNumber numberWithInt:(int)value] forKey:@"stars"];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants replaceObjectAtIndex:restaurantID withObject:dict];
    
    // Save array
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //2) Create the full file path by appending the desired file name
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"restaurants.txt"];
    [((AppController *)[UIApplication sharedApplication].delegate).restaurants writeToFile:fileName atomically:YES];
}

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
    NSNumber *stars = [[((AppController *)[UIApplication sharedApplication].delegate).restaurants objectAtIndex:restaurantID] objectForKey:@"stars"];
    if (stars.intValue == 1) {
        [label setText:[NSString stringWithFormat:@"%d Star", stars.intValue]];
    } else {
        [label setText:[NSString stringWithFormat:@"%d Stars", stars.intValue]];
    }
    [stepper setValue:stars.doubleValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
