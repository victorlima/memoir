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
        self.wrongs = [NSString stringWithFormat:@"Wrongs: %@", (NSNumber*)[context stringValue]];
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
@end



