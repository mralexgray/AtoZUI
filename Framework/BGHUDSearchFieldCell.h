//
//  BGHUDSearchFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 7/21/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDSearchFieldCell : NSSearchFieldCell {
	
	BOOL fillsBackground;
	NSString *themeKey;
}

@property (retain) NSString *themeKey;

@end
