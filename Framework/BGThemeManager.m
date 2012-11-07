//
//  BGThemeManager.m
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/15/08.
//


#import "BGThemeManager.h"


@implementation BGThemeManager

static BGThemeManager *sharedThemeManager = nil;

+ (BGThemeManager *)keyedManager;
{
    if (sharedThemeManager == nil) { sharedThemeManager = [[super allocWithZone:NULL] init];
													      [sharedThemeManager initDefaultThemes];
    }
    return sharedThemeManager;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    return [self keyedManager];
}

-(void)initDefaultThemes {
	
	//Init our Dictionary for 2 defaults
//	self.themes = [NSMutableDictionary dictionary];

	//Add the default Flat and Gradient themes
//	[themes setObject: [[BGTheme alloc] init] forKey: @"flatTheme"];
//	[themes setObject: [[BGTheme alloc] init] forKey: @"azFlatTheme"];
//	[themes setObject: [[BGTheme alloc] init] forKey: @"gradientTheme"];

	BGTheme *atoz = [AZFlatTheme new];
	BGTheme *grad = [BGGradientTheme new];
	BGTheme *flat = [BGTheme new];
	self. themes = @{ @"flat":flat, @"atoz":atoz, @"grad":grad}.mutableCopy;
	//themes setObject: [[AZFlatTheme alloc] init] forKey: @"azFlatTheme"];
//	themes setObject:  forKey: @"gradientTheme"];

//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"gradientTheme"];
//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"gradientTheme"];
//	[themes setObject: [[BGGradientTheme alloc] init] forKey: @"flatTheme"];
}

- (BGTheme *)themeForKey:(NSString *)key {

	//Make sure the key exists before we try to
	//return it
		return [self.themes objectForKey:key] ? self.themes[key] : self.themes[@"atoz"];
	
}

- (void)setTheme:(BGTheme*)theme forKey:(NSString *)key {
	[self.themes setObject:theme forKey:key];
}

- (id)copyWithZone:(NSZone*)zone; {
    return self;
}

//- (id)retain; {
//    return self;
//}
//
//- (NSUInteger)retainCount; {
//    return NSUIntegerMax;  //denotes an object that cannot be released
//}
//
//- (void)release; {
//    //do nothing
//}
//
//- (id)autorelease; {
//    return self;
//}

@end

