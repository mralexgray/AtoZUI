//
//  bghudtestAppDelegate.m
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import "bghudtestAppDelegate.h"


@interface  bghudtestAppDelegate ()
@property (assign, nonatomic) BOOL spinning;
@property (assign, nonatomic) double progress;
@end
@implementation bghudtestAppDelegate

@synthesize window, tabView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSLog(@"Done with initialization");
    NSLog(@"TabView: %@", tabView);
}

-(IBAction)doSegmentStuff:(id)sender
{
	NSInteger seg = [sender selectedSegment];
	switch (seg) {
		case 0: self.spinning =! self.spinning; break;
		case 1: self.progress = self.progress <= 100 ? self.progress + 10 : 0;
		default: break;
	}
}

-(void) setProgress:(double)progress {

	[@[_spinner, _bar] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj stopAnimation:nil];
		[obj setDoubleValue:progress];
	}];
	_progress = progress;

}
-(void) setSpinning:(BOOL)spinning {
	[@[_spinner, _bar] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		spinning ? [obj startAnimation:nil] : [obj stopAnimation:nil];
	}];
	_spinning = spinning;
}
@end
