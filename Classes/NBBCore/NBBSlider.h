/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Cocoa/Cocoa.h>
#import "NBBThemable.h"

@interface NBBSlider : NSSlider <NBBThemable>
# pragma mark - NBBThemable
- (id) initWithTheme:(NBBTheme*) theme;
- (BOOL)applyTheme:(NBBTheme*) theme;
@end
