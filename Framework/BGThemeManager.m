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
    if (sharedThemeManager == nil) {
        sharedThemeManager = [[super allocWithZone:NULL] init];
		[sharedThemeManager initDefaultThemes];
    }
    return sharedThemeManager;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    return [[self keyedManager] retain];
}

-(void)initDefaultThemes {
	
	//Init our Dictionary for 2 defaults
	themes = [[NSMutableDictionary alloc] initWithCapacity: 2];
	
	//Add the default Flat and Gradient themes
	[themes setObject: [[[BGTheme alloc] init] autorelease] forKey: @"flatTheme"];
	[themes setObject: [[[BGGradientTheme alloc] init] autorelease] forKey: @"gradientTheme"];
}

- (BGTheme *)themeForKey:(NSString *)key {

	//Make sure the key exists before we try to
	//return it
	if([themes objectForKey: key]) {

		return [themes objectForKey: key];
	} else {

		//Return the default gradient key
		return [themes objectForKey: @"gradientTheme"];
	}
	
	
}

- (void)setTheme:(BGTheme *)theme forKey:(NSString *)key {
	
	[themes setObject: theme forKey: key];
}

- (id)copyWithZone:(NSZone *)zone; {
    return self;
}

- (id)retain; {
    return self;
}

- (NSUInteger)retainCount; {
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release; {
    //do nothing
}

- (id)autorelease; {
    return self;
}

@end
