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
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *yellowImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *greenImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *blueImage;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *redImge;

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
    
    [self initialSetup];
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
    {
        NSString *color = [self.answers objectAtIndex: 0];
        [self showColor: color];
    }
    
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

-(void) showColor:(NSString *) color
{

    if( [color isEqualToString:@"yellow"] )
    {
        [self.yellowImage setImageNamed:@"funny"];
        [self.yellowImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:1.0f repeatCount:0];
    }
    
    if( [color isEqualToString:@"blue"] )
    {
        [self.blueImage setImageNamed:@"funny"];
        [self.blueImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:1.0f repeatCount:0];
    }
    
    if( [color isEqualToString:@"green"] )
    {
        [self.greenImage setImageNamed:@"funny"];
        [self.greenImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:1.0f repeatCount:0];
    }
    
    if( [color isEqualToString:@"red"] )
    {
        [self.redImge setImageNamed:@"funny"];
        [self.redImge startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:1.0f repeatCount:0];
    }
    
    [self performSelector:@selector(stopAnimation:) withObject:color afterDelay:1.2f];
}

-(void) stopAnimation:(NSString *)color
{
    [self.yellowImage setImageNamed:@"yellow"];
    [self.redImge setImageNamed:@"red"];
    [self.blueImage setImageNamed:@"blue"];
    [self.greenImage setImageNamed:@"green"];
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

#pragma mark - logic when user select a color
-(void) didSelectColor:(NSString *)color
{
    
    NSLog(@"selected color: %@", color);
    
    BOOL isCorrect = [color isEqualToString:[self fetchCurrentAnswer:self.memoirTry]];
    if( !isCorrect )
    {
        self.wrongs = [NSNumber numberWithInt:[self.wrongs intValue] + 1];
        [self presentControllerWithName:@"WrongChoiceInterfaceController" context:self.wrongs];
        
        self.memoirTry = [NSNumber numberWithInt: 0];
        
        return;
    } else
        [self.tmrCountUp stop];
    
    if( [self.memoirTry intValue ] == [self.step intValue] - 1 )
    {
        [self chooseNextColor];
        
        NSString *c = [self.answers lastObject];
        [self showColor: c];
        
        self.step = [NSNumber numberWithInt:([self.step intValue] + 1)];
        self.memoirTry = [NSNumber numberWithInt: 0];
        
        NSLog(@"%@", self.answers);
        
        return;
    } else
        self.memoirTry = [NSNumber numberWithInt:[self.memoirTry intValue] + 1];
}

#pragma mark - NSNotificationCenter method's
-(void) startOver
{
    [self initialSetup];    
    [self chooseNextColor];
    
    NSString *color = [self.answers objectAtIndex: 0];
    [self showColor: color];
}

-(void) initialSetup
{
    // initial setup
    self.step = [NSNumber numberWithInt:1];
    self.wrongs = [NSNumber numberWithInt:0];
    self.answers = [NSMutableArray array];
    self.memoirTry = [NSNumber numberWithInt: 0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startOver) name:@"START_OVER_NOTIFICATION" object:nil];
}

@end



