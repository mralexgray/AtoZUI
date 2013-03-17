//
//  BGHUDView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDView : NSView

@property (nonatomic, assign) BOOL 			useTheme;
@property (nonatomic, strong) IBOutlet NSString 		*themeKey;
@property (nonatomic, strong) BGTheme 		*theme;

@property (nonatomic, strong) NSColor		*shadowColor, *borderColor, *color1, *color2;

@property (nonatomic, assign) BOOL 			 flipGradient;
@property (nonatomic, strong) NSGradient 	*customGradient;

@property (nonatomic, assign) BOOL drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder;
@property (nonatomic, assign) BOOL drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow;


@end
