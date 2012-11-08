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

@property (assign) 	IBOutlet NSWindow *window;
@property (assign) 	IBOutlet BGHUDTabView *tabView;
@property (assign) 	IBOutlet BGHUDProgressIndicator *bar;
@property (assign) 	IBOutlet BGHUDProgressIndicator *spinner;
@property (assign) 	IBOutlet AtoZGridView *gridView;
@property (assign) 	IBOutlet NSSlider *itemSizeSlider;
@property (assign)  IBOutlet BGHUDView *windowView;
@property (assign)  IBOutlet AtoZColorWell *colorWell;

@property (strong) 		  NSMA *items;

- (IBAction)doSegmentStuff:(id)sender;
- (IBAction)itemSizeSliderAction:(id)sender;
- (IBAction)setViewColor:(id)sender;

@end
