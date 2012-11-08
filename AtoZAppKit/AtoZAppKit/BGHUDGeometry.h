//
//  BGHUDGeometry.h
//  BGHUDAppKit
//
//  Created by BinaryGod on 9/25/08.
//  Copyright 2008 none. All rights reserved.
//


#import <Foundation/NSGeometry.h>


NS_INLINE CGFloat BGCenterX(NSRect aRect) {
	return (aRect.size.width / 2);
}

NS_INLINE CGFloat BGCenterY(NSRect aRect) {
	return (aRect.size.height / 2);
}
