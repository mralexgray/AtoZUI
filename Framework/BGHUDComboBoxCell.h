//
//  NGHUDComboBoxCell.h
//  BGHUDAppKit
//
//  Created by Alan Rogers on 10/11/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDComboBoxCell : NSComboBoxCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (retain) NSString *themeKey;

- (void)drawArrowsInRect:(NSRect) frame;
-(void)drawButtonInRect:(NSRect) cellFrame;

@end
