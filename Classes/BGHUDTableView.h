//
//  BGHUDTableView.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 6/17/08.
//


#import <AppKit/AppKit.h>
#import "BGThemeManager.h"
#import "BGHUDTableViewHeaderCell.h"
#import "BGHUDTableCornerView.h"

@interface BGHUDTableView : NSTableView {

	NSString *themeKey;
}

@property (strong) NSString *themeKey;

@end
