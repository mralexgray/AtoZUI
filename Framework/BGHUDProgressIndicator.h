//
//  BGHUDProgressIndicator.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/6/08.
//


#import <Cocoa/Cocoa.h>
#import "BGThemeManager.h"

@interface BGHUDProgressIndicator : NSProgressIndicator {
	NSBezierPath *progressPath;
	NSString *themeKey;
@private
    NSTimer *spinningAnimationTimer;
    int spinningAnimationIndex;
    NSThread *spinningAnimationThread;
    BOOL isAnimating;
}

@property (retain) NSString *themeKey;

@end
