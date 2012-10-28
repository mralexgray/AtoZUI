//
//  bghudtestAppDelegate.h
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BGHUDAppKit/BGHUDAppKit.h>

@interface bghudtestAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *__weak window;
    BGHUDTabView *__weak tabView;
}

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet BGHUDTabView *tabView;
@property (weak) IBOutlet NSProgressIndicator *bar, *spinner;

-(IBAction)doSegmentStuff:(id)sender;

@end
