//
//  InterfaceController.m
//  Memoir WatchKit Extension
//
//  Created by Luiz Soares on 4/5/15.
//  Copyright (c) 2015 Some Org. All rights reserved.
//

#import "WrongInterfaceController.h"


@interface WrongInterfaceController()

@property (weak, nonatomic) IBOutlet WKInterfaceLabel *lblWrongs;
@property (strong, nonatomic) NSString *wrongs;
@end


@implementation WrongInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    if( context )
    {
        if( [context intValue] == 1 )
            self.wrongs = [NSString stringWithFormat:@"Your are wrong for the first time"];
        
        if( [context intValue] == 2 )
            self.wrongs = [NSString stringWithFormat:@"Your are wrong for the second time"];
        
        if( [context intValue] == 3 )
            self.wrongs = [NSString stringWithFormat:@"Your are wrong for the third time"];
        
        if( [context intValue] > 3 )
            self.wrongs = [NSString stringWithFormat:@"Your are wrong for the %@th time", (NSNumber*)[context stringValue]];
    }
}

- (void)willActivate {
    [super willActivate];
    [self.lblWrongs setText:self.wrongs];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

-(IBAction)dismiss:(id)sender
{
    [self dismissController];
}

-(IBAction)startOver:(id)sender
{
    [self dismissController];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"START_OVER_NOTIFICATION" object:nil];
}
@end



