//
//  BGHUDView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDView : NSView {

	BOOL flipGradient;
	BOOL drawTopBorder;
	BOOL drawBottomBorder;
	BOOL drawLeftBorder;
	BOOL drawRightBorder;
	NSColor *borderColor;
	BOOL drawTopShadow;
	BOOL drawBottomShadow;
	BOOL drawLeftShadow;
	BOOL drawRightShadow;
	NSColor *shadowColor;
	NSGradient *customGradient;
	
	NSColor *color1;
	NSColor *color2;
	
	NSString *themeKey;
	BOOL useTheme;
}
@property (nonatomic, strong) BGTheme *theme;
@property BOOL flipGradient;
@property BOOL drawTopBorder;
@property BOOL drawBottomBorder;
@property BOOL drawLeftBorder;
@property BOOL drawRightBorder;
@property (nonatomic, strong) NSColor *borderColor;
@property BOOL drawTopShadow;
@property BOOL drawBottomShadow;
@property BOOL drawLeftShadow;
@property BOOL drawRightShadow;
@property (nonatomic, strong) NSColor 		*shadowColor;
@property (nonatomic, strong) NSGradient 	*customGradient;
@property (nonatomic, strong) NSColor 		*color1;
@property (nonatomic, strong) NSColor 		*color2;

@property (nonatomic, strong) NSString 		*themeKey;
@property BOOL useTheme;

@end
