//
//  bghudtestAppDelegate.h
//  bghudtest
//
//  Created by Timothy Davis on 4/12/11.
//  Copyright 2011 none. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZUI/AtoZUI.h>

@interface AtoZUIAppDelegate : NSObject <NSApplicationDelegate, AtoZGridViewDataSource, AtoZGridViewDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet BGHUDTabView *tabView;
@property (weak) IBOutlet NSProgressIndicator *bar, *spinner;
@property (weak) IBOutlet AtoZGridView *gridView;
@property (strong) IBOutlet NSSlider *itemSizeSlider;

@property (strong) 		  NSMA *items;

-(IBAction)doSegmentStuff:(id)sender;
- (IBAction)itemSizeSliderAction:(id)sender;

@end
