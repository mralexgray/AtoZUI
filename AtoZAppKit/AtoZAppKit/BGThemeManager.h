//  BGThemeManager.h
//  BGHUDAppKit
//  Created by BinaryGod on 6/15/08.

#import "BGTheme.h"
#import "BGHUDView.h"
										
@class  BGHUDView;
BGTheme* _themeKey (BGHUDView *_self);
#define THEME(x) 	 ((BGTheme*)_themeKey((BGHUDView *)x))

@interface BGThemeManager : NSObject <NSCopying>
@property (nonatomic,strong) NSArray 	*themes;
@property (nonatomic,strong) BGTheme	*activeTheme;
+ (instancetype) sharedManager; // alias for keyedManager.
+ (instancetype) keyedManager;
-     (BGTheme*) themeForKey:(NSString*)key;
@end

//-         (void) initDefaultThemes;
//-         (void) setTheme:		(BGTheme*)theme 	
//							 forKey:(NSString*)key;
