//
//  BGThemeManager.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
//


#import <Cocoa/Cocoa.h>
#import "BGTheme.h"
#import "BGGradientTheme.h"
#import "AZFlatTheme.h"


@interface BGThemeManager : NSObject <NSCopying>

@property (nonatomic, retain) NSMutableDictionary *themes;

+ (BGThemeManager*) keyedManager;
- (void) 			initDefaultThemes;
- (BGTheme*) 		themeForKey:		(NSString*)key;
- (void) 			setTheme:			(BGTheme*)theme 	forKey:(NSString *)key;

@end
