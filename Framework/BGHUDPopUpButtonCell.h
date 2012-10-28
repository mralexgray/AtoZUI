//
//  BGHUDPopUpButtonCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 5/31/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDPopUpButtonCell : NSPopUpButtonCell {

	NSString *themeKey;
}

@property (retain) NSString *themeKey;

- (void)drawArrowsInRect:(NSRect) frame;

@end
