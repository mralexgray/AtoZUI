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

@property (strong) NSString *themeKey;

@end
