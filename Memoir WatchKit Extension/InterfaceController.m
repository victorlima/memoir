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
@property (weak, nonatomic) IBOutlet WKInterfaceTimer *tmrCountUp;

@property (strong, nonatomic) NSNumber *step;
@property (strong, nonatomic) NSNumber *wrongs;
@property (strong, nonatomic) NSMutableArray *answers;
@property (strong, nonatomic) NSDictionary *context;
@property (strong, nonatomic) NSString *correctAnswer;
@property (strong, nonatomic) NSNumber *memoirTry;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context
{
    [super awakeWithContext:context];
    
    self.step = [NSNumber numberWithInt:1];
    self.wrongs = [NSNumber numberWithInt:0];
    self.answers = [NSMutableArray array];
    self.memoirTry = [NSNumber numberWithInt: 0];

    [self chooseNextColor];
}

- (void)willActivate
{
    [super willActivate];
    
    NSString *text;
    if( [self.step intValue] == 1 )
        text =[NSString stringWithFormat:@"choose"];
    else
        text =[NSString stringWithFormat:@"step: %@", [self.step stringValue]];

    [self.lblStepsAndWrongs setText:text];
    
    [self.tmrCountUp start];
    
    if( [self.step intValue] == 1 )
        [self showFirstColor];
    
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - Fetch Answer
-(NSString *) fetchCurrentAnswer:(NSNumber *)step
{
    return [self.answers objectAtIndex:[self.memoirTry intValue]];
}

-(void) showFirstColor
{

    NSString *color = [self.answers objectAtIndex: 0];
    
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
}


-(void) showNextColor
{
    for( NSString *color in self.answers)
    {
        [self.greenButton setBackgroundColor:[UIColor greenColor]];
        [self.yellowButton setBackgroundColor:[UIColor yellowColor]];
        [self.blueButton setBackgroundColor:[UIColor blueColor]];
        [self.redButton setBackgroundColor:[UIColor redColor]];

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
    }

    [self.greenButton setBackgroundColor:[UIColor greenColor]];
    [self.yellowButton setBackgroundColor:[UIColor yellowColor]];
    [self.blueButton setBackgroundColor:[UIColor blueColor]];
    [self.redButton setBackgroundColor:[UIColor redColor]];
}

-(void) chooseNextColor
{
    // randomly choose next color
    NSString *colorName;
    int color = random() % 4;
    switch ( color ) {
        case 0:
            colorName = @"yellow";
            break;
        case 1:
            colorName = @"blue";
            break;
        case 2:
            colorName = @"green";
            break;
        case 3:
            colorName = @"red";
            break;
        default:
            break;
    }
    
    [self.answers addObject:colorName];
    
    NSLog(@"%@", self.answers);
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
    
    NSLog(@"selected color: %@", color);
    
    BOOL isCorrect = [color isEqualToString:[self fetchCurrentAnswer:self.memoirTry]];
    if( !isCorrect )
    {
        self.wrongs = [NSNumber numberWithInt:[self.wrongs intValue] + 1];
        [self presentControllerWithName:@"WrongChoiceInterfaceController" context:self.wrongs];
        
        return;
    } else
        [self.tmrCountUp stop];
    
    if( [self.memoirTry intValue ] == [self.step intValue] - 1 )
    {
        [self chooseNextColor];
        [self showNextColor];

        self.step = [NSNumber numberWithInt:([self.step intValue] + 1)];
        
        NSLog(@"%@", self.answers);
        
        return;
    } else
        self.memoirTry = [NSNumber numberWithInt:[self.memoirTry intValue] + 1];
}

@end



