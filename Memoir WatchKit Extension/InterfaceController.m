//
//  InterfaceController.m
//  Memoir WatchKit Extension
//
//  Created by Luiz Soares on 4/5/15.
//  Copyright (c) 2015 Some Org. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceButton *yellowButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *redButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *blueButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *greenButton;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblStepsAndWrongs;

@property (strong, nonatomic) NSNumber *step;
@property (strong, nonatomic) NSNumber *wrongs;
@property (strong, nonatomic) NSDictionary *context;
@property (strong, nonatomic) NSString *correctAnswer;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSDictionary *ctx = (NSDictionary *) context;
    
    if( context )
    {
        self.wrongs = (NSNumber *)[ctx objectForKey:@"wrongs"];
        
        NSNumber *previousStep = (NSNumber *)[ctx objectForKey:@"step"];
        self.step = [NSNumber numberWithInt:[previousStep intValue] + 1];
    }
    else
    {
        self.step = [NSNumber numberWithInt:0];
        self.wrongs = [NSNumber numberWithInt:0];
    }
    
    self.correctAnswer = [self fetchCurrentAnswer:self.step];
    
}

- (void)willActivate {
    [super willActivate];
    
    NSString *text =[NSString stringWithFormat:@"step: %@, wrong: %@", [self.step stringValue], [self.wrongs stringValue]];
    [self.lblStepsAndWrongs setText:text];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Fetch Answer
-(NSString *) fetchCurrentAnswer:(NSNumber *)step
{
    int a = rand() % 4;
    switch ( a )
    {
        case 0:
            return @"yellow";
            break;
        case 1:
            return @"red";
            break;
        case 2:
            return @"green";
            break;
        case 3:
            return @"blue";
            break;
        default:
            return @"yellow";
            break;
    }
}

#pragma mark - IBAction's
-(IBAction)didSelectYellowButton:(id)sender
{
    [self didSelectColor: @"yellow"];
}

-(IBAction)didSelectBlueButton:(id)sender
{
    [self didSelectColor: @"blue"];
}

-(IBAction)didSelectGreenButton:(id)sender
{
    [self didSelectColor: @"green"];
}

-(IBAction)didSelectRedButton:(id)sender
{
    [self didSelectColor: @"red"];
}

-(void) didSelectColor:(NSString *)color
{
    
    BOOL isCorrect = [color isEqualToString:self.correctAnswer];
    if( !isCorrect )
    {
        self.wrongs = [NSNumber numberWithInt:[self.wrongs intValue] + 1];
        [self presentControllerWithName:@"WrongChoiceInterfaceController" context:nil];
        
        return;
    }
    
    if( [color isEqualToString:@"yellow"] )
    {
        [self.redButton setBackgroundColor:[UIColor grayColor]];
        [self.blueButton setBackgroundColor:[UIColor grayColor]];
        [self.greenButton setBackgroundColor:[UIColor grayColor]];
    }
    
    if( [color isEqualToString:@"blue"] )
    {
        [self.redButton setBackgroundColor:[UIColor grayColor]];
        [self.yellowButton setBackgroundColor:[UIColor grayColor]];
        [self.greenButton setBackgroundColor:[UIColor grayColor]];
    }
    
    if( [color isEqualToString:@"green"] )
    {
        [self.redButton setBackgroundColor:[UIColor grayColor]];
        [self.yellowButton setBackgroundColor:[UIColor grayColor]];
        [self.blueButton setBackgroundColor:[UIColor grayColor]];
    }

    if( [color isEqualToString:@"red"] )
    {
        [self.greenButton setBackgroundColor:[UIColor grayColor]];
        [self.yellowButton setBackgroundColor:[UIColor grayColor]];
        [self.blueButton setBackgroundColor:[UIColor grayColor]];
    }
    
    [self pushControllerWithName:@"MemoirInterfaceController" context:@{@"wrongs" : self.wrongs, @"step" : self.step}];
}

@end



