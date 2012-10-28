//
//  BGHUDTokenFieldCell.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/10/08.
//


#import <Cocoa/Cocoa.h>
#import "BGHUDTokenAttachmentCell.h"
#import "NSTokenAttachmentCell.h"
#import "BGThemeManager.h"

@interface BGHUDTokenFieldCell : NSTokenFieldCell {

	BOOL fillsBackground;
	NSString *themeKey;
}

@property (retain) NSString *themeKey;

@end
