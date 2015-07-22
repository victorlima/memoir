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
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceImage *redImage;

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

-(void) erick
{
    NSLog(@"aaaaa");
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
    [self.yellowImage setTintColor:[UIColor yellowColor]];
    [self.greenImage setTintColor:[UIColor greenColor]];
    [self.blueImage setTintColor:[UIColor blueColor]];
    [self.redImage setTintColor:[UIColor redColor]];
    
    NSString *color = [self.answers objectAtIndex: 0];
    if( [color isEqualToString:@"yellow"] )
    {
        [self.yellowImage setImageNamed:@"funny"];
        [self.yellowImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:0.1f repeatCount:1];
    }
    
    if( [color isEqualToString:@"blue"] )
    {
        [self.blueImage setImageNamed:@"funny"];
        [self.blueImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:0.1f repeatCount:1];
    }
    
    if( [color isEqualToString:@"green"] )
    {
        [self.greenImage setImageNamed:@"funny"];
        [self.greenImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:0.1f repeatCount:1];
    }
    
    if( [color isEqualToString:@"red"] )
    {
        [self.redImage setImageNamed:@"funny"];
        [self.redImage startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:0.1f repeatCount:1];
    }
}

-(void) animateImage:(WKInterfaceImage *)image
{
    [image setImageNamed:@"funny"];
    [image startAnimatingWithImagesInRange:NSMakeRange(0, 2) duration:1.0f repeatCount:4];
}

-(void) resetImages
{
    [self.yellowImage setImageNamed:@"yellow"];
    [self.blueImage setImageNamed:@"blue"];
    [self.redImage setImageNamed:@"red"];
    [self.greenImage setImageNamed:@"green"];
}

-(void) showNextColor
{

    int i = 0;
    float timer = 0.0f;
    
    for( NSString *color in self.answers )
    {
        timer = i + 2.5f;

        if( [color isEqualToString:@"yellow"] )
        {
            [self performSelector:@selector(animateImage:) withObject:self.yellowImage afterDelay: timer];
        }
        
        if( [color isEqualToString:@"blue"] )
        {
            [self performSelector:@selector(animateImage:) withObject:self.blueImage afterDelay: timer];
        }
        
        if( [color isEqualToString:@"green"] )
        {
            [self performSelector:@selector(animateImage:) withObject:self.greenImage afterDelay: timer];
        }
        
        if( [color isEqualToString:@"red"] )
        {
            [self performSelector:@selector(animateImage:) withObject:self.redImage afterDelay: timer];
        }
    }
    
    timer += 1;
    [self performSelector:@selector(resetImages) withObject:nil afterDelay:timer];
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
    }
    
    if( [self.memoirTry intValue ] == [self.step intValue] - 1 )
    {
        [self chooseNextColor];
        
        self.step = [NSNumber numberWithInt:([self.step intValue] + 1)];
        
        [self showNextColor];
        
        NSLog(@"%@", self.answers);
        
        return;
    }
    
    self.memoirTry = [NSNumber numberWithInt:[self.memoirTry intValue] + 1];
}

@end



