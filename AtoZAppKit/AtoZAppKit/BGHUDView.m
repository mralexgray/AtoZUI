//
//  BGHUDView.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 2/15/09.
//  Copyright 2009 none. All rights reserved.
//


#import "BGHUDView.h"


@implementation BGHUDView

@synthesize flipGradient, drawTopBorder, drawBottomBorder, drawLeftBorder, drawRightBorder, borderColor, drawTopShadow, drawBottomShadow, drawLeftShadow, drawRightShadow, shadowColor, customGradient, themeKey, useTheme, color1, color2;

-(id)init {
	
	self = [super init];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		self.useTheme = YES;
		self.flipGradient = YES;
		self.borderColor = [NSColor blackColor];
		self.shadowColor = [NSColor blackColor];
		self.color1 = [NSColor blackColor];
		self.color2 = [NSColor colorWithCalibratedRed:0.804 green:0.426 blue:1.000 alpha:1.000];
	}
	
	return self;
}

-(id)initWithFrame:(NSRect) frame {
	
	self = [super initWithFrame: frame];
	
	if(self) {
		
		self.themeKey = @"gradientTheme";
		self.useTheme = YES;
		self.flipGradient = YES;
		self.borderColor = [NSColor blackColor];
		self.shadowColor = [NSColor blackColor];
		self.color1 = [NSColor blackColor];
		self.color2 = [NSColor colorWithCalibratedRed:0.253 green:0.478 blue:0.761 alpha:1.000];
	}
	
	return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	
	self = [super initWithCoder: aDecoder];
	
	if(self) { NSLog(@"initwithCoder");
		
		self.themeKey = [aDecoder containsValueForKey: @"themeKey"] ? [aDecoder decodeObjectForKey: @"themeKey"]
																	: @"gradientTheme";
		self.useTheme 			= YES;
		//[aDecoder containsValueForKey:@"useTheme"]  ? [aDecoder decodeBoolForKey: @"useTheme"]

		self.useTheme 			= [aDecoder decodeBoolForKey: @"useTheme"];
		self.flipGradient 		= [aDecoder decodeBoolForKey: @"flipGradient"];
		self.drawTopBorder 		= [aDecoder decodeBoolForKey: @"drawTopBorder"];
		self.drawBottomBorder 	= [aDecoder decodeBoolForKey: @"drawBottomBorder"];
		self.drawLeftBorder 		= [aDecoder decodeBoolForKey: @"drawLeftBorder"];
		self.drawRightBorder	 	= [aDecoder decodeBoolForKey: @"drawRightBorder"];
		
		self.borderColor = [aDecoder decodeObjectForKey: @"borderColor"] ?: [NSColor blackColor];

		self.drawTopShadow 		= [aDecoder decodeBoolForKey: @"drawTopShadow"];
		self.drawBottomShadow 	= [aDecoder decodeBoolForKey: @"drawBottomShadow"];
		self.drawLeftShadow 		= [aDecoder decodeBoolForKey: @"drawLeftShadow"];
		self.drawRightShadow 	= [aDecoder decodeBoolForKey: @"drawRightShadow"];
		
		self.shadowColor = [aDecoder containsValueForKey: @"shadowColor"] ?
			[aDecoder decodeObjectForKey: @"shadowColor"] : [NSColor blackColor];

		
		self.color1 = [aDecoder containsValueForKey: @"color1"] ?
			[aDecoder decodeObjectForKey: @"color1"] : [NSColor blackColor];
		self.color2 = [aDecoder containsValueForKey: @"color2"] ?
			[aDecoder decodeObjectForKey: @"color2"] :
			[NSColor colorWithCalibratedRed:0.851 green:0.723 blue:0.268 alpha:1.000];
	}
	
	return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
	
	[super encodeWithCoder: aCoder];
	
	[aCoder encodeObject: 	self.themeKey 			forKey: @"themeKey"];
	[aCoder encodeBool: 	self.useTheme 			forKey: @"useTheme"];
	[aCoder encodeBool: 	self.flipGradient 		forKey: @"flipGradient"];
	[aCoder encodeBool: 	self.drawTopBorder 		forKey: @"drawTopBorder"];
	[aCoder encodeBool: 	self.drawBottomBorder 	forKey: @"drawBottomBorder"];
	[aCoder encodeBool: 	self.drawLeftBorder 	forKey: @"drawLeftBorder"];
	[aCoder encodeBool: 	self.drawRightBorder 	forKey: @"drawRightBorder"];
	[aCoder encodeObject: 	self.borderColor 		forKey: @"borderColor"];
	[aCoder encodeBool: 	self.drawTopShadow 		forKey: @"drawTopShadow"];
	[aCoder encodeBool: 	self.drawBottomShadow 	forKey: @"drawBottomShadow"];
	[aCoder encodeBool: 	self.drawLeftShadow 	forKey: @"drawLeftShadow"];
	[aCoder encodeBool: 	self.drawRightShadow 	forKey: @"drawRightShadow"];
	[aCoder encodeObject: 	self.shadowColor 		forKey: @"shadowColor"];
	[aCoder encodeObject: 	self.color1 			forKey: @"color1"];
	[aCoder encodeObject: 	self.color2 			forKey: @"color2"];
}

- (BGTheme*) theme

{
	return _theme = _theme ?: [[BGThemeManager keyedManager] themeForKey: self.themeKey] ?: [[BGThemeManager keyedManager]themeForKey:@"atoz"];
}

-(void)drawRect:(NSRect) rect {
	
	rect = [self bounds];
	
//	if(self.useTheme) { NSLog(@"indeed using theme");
	[self.theme.normalGradient drawInRect: rect angle:self.theme.gradientAngle];
	[self.theme.strokeColor set];
	NSFrameRect(rect);
		
/*	} else {
		
		NSGradient *gradient;
		
		if(customGradient != nil) {
			
			gradient = customGradient;
		} else {
			
			gradient = [[NSGradient alloc] initWithStartingColor: self.color1 endingColor: self.color2];
		}
		
		NSShadow *dropShadow = [[NSShadow alloc] init];
		
		[dropShadow setShadowColor: self.shadowColor];
		[dropShadow setShadowBlurRadius: 5];
		
		if(self.flipGradient == 0) {
			
			[gradient drawInRect: rect angle: 360 - [[[BGThemeManager keyedManager] themeForKey: self.themeKey] gradientAngle]];
		} else {
			
			[gradient drawInRect: rect angle: [[[BGThemeManager keyedManager] themeForKey: self.themeKey] gradientAngle]];
		}
		
		
		[[NSGraphicsContext currentContext] setShouldAntialias: NO];
		
		[[self borderColor] set];
		
		rect = NSInsetRect(rect, .5f, .5f);
		
		//Draw Borders
		if(self.drawTopBorder) {
			
			[NSGraphicsContext saveGraphicsState];
			
			if(self.drawTopShadow) {
				
				[dropShadow setShadowOffset: NSMakeSize( 0, -1)];
				[dropShadow set];
			}
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect) , NSMaxY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
			
			[NSGraphicsContext restoreGraphicsState];
		}
		
		if(self.drawBottomBorder) {
			
			[NSGraphicsContext saveGraphicsState];
			
			if(self.drawBottomShadow) {
				
				[dropShadow setShadowOffset: NSMakeSize( 0, 1)];
				[dropShadow set];
			}
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect))];
			
			[NSGraphicsContext restoreGraphicsState];
		}
		
		if(self.drawLeftBorder) {
			
			[NSGraphicsContext saveGraphicsState];
			
			if(self.drawLeftShadow) {
				
				[dropShadow setShadowOffset: NSMakeSize( 1, 0)];
				[dropShadow set];
			}
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMinX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMinX(rect), NSMaxY(rect))];
			
			[NSGraphicsContext restoreGraphicsState];
		}
		
		if(self.drawRightBorder) {
			
			[NSGraphicsContext saveGraphicsState];
			
			if(self.drawRightShadow) {
				
				[dropShadow setShadowOffset: NSMakeSize( -1, 0)];
				[dropShadow set];
			}
			
			[NSBezierPath strokeLineFromPoint: NSMakePoint(NSMaxX(rect), NSMinY(rect)) toPoint: NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
			
			[NSGraphicsContext restoreGraphicsState];
		}

	}*/
}


@end
