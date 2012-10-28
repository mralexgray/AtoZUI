//
//  BGHUDProgressIndicator.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/6/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDProgressIndicator :NSProgressIndicator
{
}

@property (readwrite, retain) NSTimer* animator;
@property (readwrite) double progressOffset;

-(void)drawBezel;
-(void)drawProgressWithBounds:(NSRect)bounds;
-(void)drawStripesInBounds:(NSRect)bounds;
-(void)drawShadowInBounds:(NSRect)bounds;
-(NSBezierPath*)stripeWithOrigin:(NSPoint)origin bounds:(NSRect)frame;

//@property (strong) NSString *themeKey;

@end
