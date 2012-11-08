
#import "AtoZGridView.h"

#import <AtoZ/AZSizer.h>


NSString *const reuseIdentifier = @"AtoZGridViewItem";

//static CGFloat kDefaultContentInset;
//static CGFloat kDefaultSelectionRingLineWidth;
//static CGFloat kDefaultItemBorderRadius;

#pragma mark CNSelectionFrameView
@interface CNSelectionFrameView : NSView
@end

#pragma mark AtoZGridView
const int CNSingleClick = 1;
const int CNDoubleClick = 2;
const int CNTrippleClick = 3;

struct CNItemPoint {
    NSUInteger column;
    NSUInteger row;
};

typedef struct CNItemPoint CNItemPoint;

CNItemPoint CNMakeItemPoint(NSUInteger aColumn, NSUInteger aRow) {
	CNItemPoint point;
	point.column = aColumn;
	point.row = aRow;
	return point;
}

@interface AtoZGridView ()
@property (strong) NSMutableDictionary *keyedVisibleItems;
@property (strong) NSMutableDictionary *reuseableItems;
@property (strong) NSMutableDictionary *selectedItems;
@property (strong) NSMutableDictionary *selectedItemsBySelectionFrame;
@property (strong) NSTrackingArea *gridViewTrackingArea;
@property (assign) BOOL isInitialCall;
@property (assign) NSInteger lastHoveredIndex;
@property (assign) NSInteger lastSelectedIndex;
@property (assign) NSInteger numberOfItems;
@property (strong) NSMutableArray *clickEvents;
@property (strong) NSTimer *clickTimer;
@property (strong) CNSelectionFrameView *selectionFrameView;
@property (assign) CGPoint selectionFrameInitialPoint;
@property (assign) BOOL abortSelection;
- (void) setupDefaults;
- (void) updateVisibleRect;
- (void) refreshGridViewAnimated:(BOOL)animated;
- (void) updateReuseableItems;
- (void) updateVisibleItems;
- (NSIndexSet*) indexesForVisibleItems;
- (void) arrangeGridViewItemsAnimated:(BOOL)animated;
- (NSRange) currentRange;
- (NSRect) rectForItemAtIndex:(NSUInteger)index;
- (NSUInteger) columnsInGridView;
- (NSUInteger) allOverRowsInGridView;
- (NSUInteger) visibleRowsInGridView;
- (NSRect) clippedRect;
- (NSUInteger) indexForItemAtLocation:(NSPoint)location;
- (CNItemPoint) locationForItemAtIndex:(NSUInteger)itemIndex;
- (void) selectItemAtIndex:(NSUInteger)selectedItemIndex usingModifierFlags:(NSUInteger)modifierFlags;
- (void) handleClicks:(NSTimer*) theTimer;
- (void) handleSingleClickForItemAtIndex:(NSUInteger)selectedItemIndex;
- (void) handleDoubleClickForItemAtIndex:(NSUInteger)selectedItemIndex;
- (void) drawSelectionFrameForMousePointerAtLocation:(NSPoint)location;
- (void) selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUInteger)modifierFlags;
@end

@class AtoZGridViewItem;
@implementation AtoZGridView
{
	CIImage *inputMaskImage, *inputShadingImage;
}

//+ (void)initialize
//{
//	kDefaultSelectionRingLineWidth = 12.0f;
//	kDefaultContentInset = 7.0f;
//	kDefaultItemBorderRadius = 10.0f;
//}

#pragma mark - Initialization
- (id)init
{
	if (!(self = [super init])) return nil;
	[self setupDefaults];
	_delegate = nil;
	_dataSource = nil;
    return self;
}


- (id)initWithFrame:(NSRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
	[self setupDefaults];
	_delegate = nil;
	_dataSource = nil;
    return self;
}
- (id)initWithCoder:(NSCoder*) aDecoder
{
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	[self setupDefaults];
    return self;
}

- (void) setupDefaults
{

//	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//    // preload shading bitmap to use in transitions:
//	// this one is for "SlideshowViewPageCurlTransitionStyle", and "SlideshowViewRippleTransitionStyle"
//	NSURL *pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]];
//	inputShadingImage = [CIImage imageWithContentsOfURL:pathURL];
//	// this one is for "SlideshowViewDisintegrateWithMaskTransitionStyle"
//	pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
//	inputMaskImage = [CIImage imageWithContentsOfURL:pathURL];



	_visibleContentMask     = (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle);
	/// title text font attributes
	NSShadow *textShadow    = [[NSShadow alloc] init];
	[textShadow setShadowColor: [self itemTitleShadowColor]];
	[textShadow setShadowBlurRadius:2];
	[textShadow setShadowOffset: NSMakeSize(.5, -1)];
	NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
	[textStyle setAlignment: NSCenterTextAlignment];
	_itemTitleTextAttributes = @{NSFontAttributeName:			[NSFont fontWithName:@"Helvetica" size:12],
NSShadowAttributeName:			textShadow,
NSForegroundColorAttributeName:	[self itemTitleColor],
NSParagraphStyleAttributeName:	textStyle};

	//	CATiledLayer *laya = [CATiledLayer layer];
	//	laya.frame = self.window.frame;
	//	laya.backgroundColor = [[NSColor greenColor]CGColor];
	//	self.enclosingScrollView.layer = laya;
	//	self.enclosingScrollView.wantsLayer = YES;
    /// private properties
    _keyedVisibleItems	= [NSMutableDictionary new];
    _reuseableItems		= [NSMutableDictionary new];
    _selectedItems		= [NSMutableDictionary new];
    _selectedItemsBySelectionFrame	= [NSMutableDictionary new];
    /// public properties
    _gridViewTitle 		= nil;
    _scrollElasticity 	= YES;
    _itemSize 			= NSMakeSize(96,96);//, <#CGFloat h#>) [AtoZGridViewItem defaultItemSize];
    _allowsSelection 	= YES;
    _allowsMultipleSelection = NO;
    _useSelectionRing 	= YES;
    _useHover 			= YES;
    _isInitialCall 		= YES;
    _lastHoveredIndex 	= NSNotFound;
    _lastSelectedIndex 	= NSNotFound;
    _clickEvents 		= [NSMutableArray array];
    _clickTimer 		= nil;
    _selectionFrameView = nil;
    _selectionFrameInitialPoint = CGPointZero;
    _abortSelection 	= NO;
	//	[self updateSubviewsWithTransition:@"CIRippleTransition"];
	//    self.enclosingScrollView.drawsBackground 	= YES;
	//	self.enclosingScrollView.backgroundColor = [NSColor redColor];
	NSClipView *clipView = self.enclosingScrollView.contentView;
    clipView.postsBoundsChangedNotifications	= YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateVisibleRect)
                                                 name:NSViewBoundsDidChangeNotification
                                               object:clipView];
}

//- (void) awakeFromNib
//{
//	self.enclosingScrollView.drawsBackground 	= NO;
////	self.enclosingScrollView.backgroundColor = [NSColor redColor];
//}

#pragma mark - Accessors
- (void) setItemSize:(NSSize)itemSize
{
    _itemSize = itemSize;
	_selectionRingLineWidth = .05 * _itemSize.width;//kDefaultSelectionRingLineWidth;
	_contentInset           = .1  * _itemSize.width;//kDefaultContentInset;
	_itemBorderRadius       = .05  * _itemSize.width;//kDefaultItemBorderRadius;

    [self refreshGridViewAnimated:YES];
}
- (void) setScrollElasticity:(BOOL)scrollElasticity
{
    _scrollElasticity = scrollElasticity;
    NSScrollView *scrollView = [self enclosingScrollView];
    if (_scrollElasticity) {
        [scrollView setHorizontalScrollElasticity:NSScrollElasticityAllowed];
        [scrollView setVerticalScrollElasticity:NSScrollElasticityAllowed];
    } else {
        [scrollView setHorizontalScrollElasticity:NSScrollElasticityNone];
        [scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
    }
}

- (void) drawRect:(NSRect)dirtyRect {
	[self.backgroundColor set];
	NSRectFill([self bounds]);
}
- (void) setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    if (self.selectedItems.count > 1 && !allowsMultipleSelection) {
        NSArray *indexes = [self.selectedItems allKeys];
        [indexes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AtoZGridViewItem *item = (self.selectedItems)[(NSNumber*) obj];
            item.isSelected = NO;
            [self.selectedItems removeObjectForKey:(NSNumber*) obj];
        }];
        [self updateVisibleRect];
    }
}



#pragma mark - Private Helper
- (void) updateVisibleRect
{
    [self updateReuseableItems];
    [self updateVisibleItems];
    [self arrangeGridViewItemsAnimated:NO];
}
- (void) refreshGridViewAnimated:(BOOL)animated
{
    NSRect scrollRect = [self frame];
    scrollRect.size.width = scrollRect.size.width;
    scrollRect.size.height = [self allOverRowsInGridView] * self.itemSize.height;
    [super setFrame:scrollRect];
    [self updateReuseableItems];
    [self updateVisibleItems];
    [self arrangeGridViewItemsAnimated:animated];
}
- (void) updateReuseableItems
{
    NSRange currentRange = [self currentRange];
    [[self.keyedVisibleItems allValues] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AtoZGridViewItem *item = (AtoZGridViewItem*) obj;
        if (!NSLocationInRange(item.index, currentRange) && item.isReuseable) {
            [self.keyedVisibleItems removeObjectForKey:@(item.index)];
            [item removeFromSuperview];
            [item prepareForReuse];
            NSMutableSet *reuseQueue = (self.reuseableItems)[item.reuseIdentifier] ?: [NSMutableSet set];
            [reuseQueue addObject:item];
            (self.reuseableItems)[item.reuseIdentifier] = reuseQueue;
        }
    }];
}
- (void) updateVisibleItems
{
    NSRange currentRange = [self currentRange];
    NSMutableIndexSet *visibleItemIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:currentRange];
    [visibleItemIndexes removeIndexes:[self indexesForVisibleItems]];
    /// update all visible items
    [visibleItemIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        AtoZGridViewItem *item = [self gridView:self itemAtIndex:idx inSection:0];
        if (item) {
            item.index = idx;
            if (self.isInitialCall) {
                [item setAlphaValue:0.0];
                [item setFrame:[self rectForItemAtIndex:idx]];
            }
            (self.keyedVisibleItems)[@(item.index)] = item;
            [[self animator ]addSubview:item];
        }
    }];
}
- (NSIndexSet*) indexesForVisibleItems
{
    __block NSMutableIndexSet *indexesForVisibleItems = [[NSMutableIndexSet alloc] init];
    [self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [indexesForVisibleItems addIndex:[(AtoZGridViewItem*) obj index]];
    }];
    return indexesForVisibleItems;
}


- (void)updateSubviewsWithTransition:(NSString *)transition
{
    NSRect		rect = [self bounds];
    CIFilter	*transitionFilter = nil;
    // Use Core Animation's four built-in CATransition types, or an appropriately instantiated and configured Core Image CIFilter.
    transitionFilter = [CIFilter filterWithName:transition];  [transitionFilter setDefaults];
    [transition isEqualToString:@"CICopyMachineTransition"] ?
	[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"] :
    [transition isEqualToString:@"CIDisintegrateWithMaskTransition"] ? ^{
        // scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
        CIFilter *maskScalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"]; [maskScalingFilter setDefaults];
        CGRect maskExtent = [inputMaskImage extent];
        float xScale = rect.size.width / maskExtent.size.width;
        float yScale = rect.size.height / maskExtent.size.height;
        [maskScalingFilter setValue:@(yScale) forKey:@"inputScale"];
        [maskScalingFilter setValue:@(xScale / yScale) forKey:@"inputAspectRatio"];
        [maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
        [transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"]; }() :
	[transition isEqualToString:@"CIFlashTransition"] ? ^{
        [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"]; }() :
	[transition isEqualToString:@"CIModTransition"] ?
	[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"] :[transition isEqualToString:@"CIPageCurlTransition"] ? ^{
        [transitionFilter setValue:@(-M_PI_4) forKey:@"inputAngle"];
        [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
        [transitionFilter setValue:inputShadingImage forKey:@"inputBacksideImage"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"]; }() :
	[transition isEqualToString:@"CIRippleTransition"] ? ^{
        [transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
        [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
    }() : nil;
	CATransition *newTransition = [CATransition animation];    // new CATransition that describes the transition
    // we want to build a CIFilter-based CATransition. When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored, so we don't need to bother setting them.   else we want to specify one of Core Animation's built-in transitions.
	transitionFilter ? [newTransition setFilter:transitionFilter] : ^{ [newTransition setType:transition]; [newTransition setSubtype:kCATransitionFromLeft]; }();
    // specify an explicit duration for the transition.
    [newTransition setDuration:1.0];
    // associate the CATransition we've just built with the "subviews" key for this SlideshowView instance,
	// so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
	[self setAnimations:@{@"alphaValue": newTransition, @"frame":newTransition}];
}



//+ (id)defaultAnimationForKey:(NSString *)key {
//    if ([key isEqualToString:@"frame"]) {
//		NSRect rect = ;
//		CIFilter* transitionFilter = [CIFilter filterWithName:key];  [transitionFilter setDefaults];
//		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"] :
//
//        // By default, animate border color changes with simple linear interpolation to the new color value.
//        return [CABasicAnimation animation];
//    } else {
//        // Defer to super's implementation for any keys we don't specifically handle.
//        return [super defaultAnimationForKey:key];
//    }
//}
//

- (void) arrangeGridViewItemsAnimated:(BOOL)animated
{



	[self updateSubviewsWithTransition:@"CICopyMachineTransition"];
    /// on initial call (aka application startup) we will fade all items (after loading it) in
    if (self.isInitialCall && self.keyedVisibleItems.count > 0) {
        self.isInitialCall = NO;
        animated = YES;
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:(animated ? 1 : 0.0)];

        [self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
			CATransition *animation = [CATransition animation];
			[animation setType:kCATransitionMoveIn];
			[[(AtoZGridViewItem*)obj layer] addAnimation:animation forKey:@"isSelected"];
			[[(AtoZGridViewItem*) obj animator] setAlphaValue:1.0];
        }];
        [NSAnimationContext endGrouping];
    }
    else if (_keyedVisibleItems.count > 0) {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:(animated ? 1 : 0.0)];
        [[NSAnimationContext currentContext] setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSRect newRect = [self rectForItemAtIndex:[(AtoZGridViewItem*) obj index]];
            [[(AtoZGridViewItem*) obj animator] setFrame:newRect];
        }];
        [NSAnimationContext endGrouping];
    }
}
- (NSRange)currentRange
{
    NSRect clippedRect    = [self clippedRect];
    NSUInteger columns    = [self columnsInGridView];
    NSUInteger rows       = [self visibleRowsInGridView];
    NSUInteger rangeStart = clippedRect.origin.y > self.itemSize.height
	? (ceilf(clippedRect.origin.y / self.itemSize.height) * columns) - columns : 0;
    NSUInteger rangeLength = MIN(self.numberOfItems, (columns * rows) + columns);
    rangeLength = ((rangeStart + rangeLength) > self.numberOfItems ? self.numberOfItems - rangeStart : rangeLength);
    NSRange rangeForVisibleRect = NSMakeRange(rangeStart, rangeLength);
    return rangeForVisibleRect;
}
- (NSRect)rectForItemAtIndex:(NSUInteger)index
{
    NSUInteger columns = [self columnsInGridView];
 	return NSMakeRect((index % columns) * self.itemSize.width,
					  ((index - (index % columns)) / columns) * self.itemSize.height,
					  self.itemSize.width,
					  self.itemSize.height);

}
- (NSUInteger)columnsInGridView
{
    NSUInteger columns = floorf((float)NSWidth([self clippedRect]) / self.itemSize.width);
	return columns < 1 ? 1 : columns;
}

- (NSUInteger)allOverRowsInGridView	{	return ceilf((float)self.numberOfItems / [self columnsInGridView]);	}

- (NSUInteger)visibleRowsInGridView
{
	return ceilf((float)NSHeight([self clippedRect]) / self.itemSize.height);
}
- (NSRect)clippedRect {    return [[[self enclosingScrollView] contentView] bounds];  }
- (NSUInteger)indexForItemAtLocation:(NSPoint)location
{
    NSPoint point = [self convertPoint:location fromView:nil];
    NSUInteger indexForItemAtLocation;
    if (point.x > (self.itemSize.width * [self columnsInGridView])) indexForItemAtLocation = NSNotFound;
	else {
        NSUInteger currentColumn = floor(point.x / self.itemSize.width);
        NSUInteger currentRow = floor(point.y / self.itemSize.height);
        indexForItemAtLocation = currentRow * [self columnsInGridView] + currentColumn;
        indexForItemAtLocation = (indexForItemAtLocation > self.numberOfItems ? NSNotFound : indexForItemAtLocation);
    }
    return indexForItemAtLocation;
}
- (CNItemPoint)locationForItemAtIndex:(NSUInteger)itemIndex
{
    NSUInteger columnsInGridView = [self columnsInGridView];
    NSUInteger row = floor(itemIndex / columnsInGridView) + 1;
    NSUInteger column = itemIndex - floor((row -1) * columnsInGridView) + 1;
    CNItemPoint location = CNMakeItemPoint(column, row);
    return location;
}

#pragma mark - NSView Methods
- (BOOL)isFlipped { return YES; }

- (void) setFrame:(NSRect)frameRect
{
    BOOL animated = (self.frame.size.width == frameRect.size.width ? NO: YES);
    [super setFrame:frameRect];
    [self refreshGridViewAnimated:animated];
    [[self enclosingScrollView] setNeedsDisplay:YES];
}
- (void) updateTrackingAreas
{
    if (_gridViewTrackingArea) [self removeTrackingArea:_gridViewTrackingArea];
    self.gridViewTrackingArea = nil;
    self.gridViewTrackingArea =
	[[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:nil];
    [self addTrackingArea:_gridViewTrackingArea];
}


#pragma mark - Creating GridView Items
- (id)dequeueReusableItemWithIdentifier:(NSString*) identifier
{
    AtoZGridViewItem *reusableItem = nil;
    NSMutableSet *reuseQueue = (self.reuseableItems)[identifier];
    if (reuseQueue != nil && reuseQueue.count > 0) {
        reusableItem = [reuseQueue anyObject];
        [reuseQueue removeObject:reusableItem];
        (self.reuseableItems)[identifier] = reuseQueue;
    }
    return reusableItem;
}


#pragma mark - Reloading GridView Data
- (void) reloadData
{
    self.numberOfItems = [self gridView:self numberOfItemsInSection:0];
    [self.keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [(AtoZGridViewItem*) obj removeFromSuperview];
    }];
    [self.keyedVisibleItems	removeAllObjects];
    [self.reuseableItems	removeAllObjects];
    [self refreshGridViewAnimated:YES];
}


#pragma mark - Selection Handling
- (void) scrollToGridViewItem:(AtoZGridViewItem*) gridViewItem animated:(BOOL)animated
{

}
- (void) scrollToGridViewItemAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL)animated
{

}
- (void) selectItemAtIndex:(NSUInteger)selectedItemIndex usingModifierFlags:(NSUInteger)modifierFlags
{
    AtoZGridViewItem *gridViewItem = nil;
    if (self.lastSelectedIndex != NSNotFound && self.lastSelectedIndex != selectedItemIndex) {
        /// inform the delegate
        [self gridView:self willDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
        gridViewItem = (self.keyedVisibleItems)[@(self.lastSelectedIndex)];
        gridViewItem.isSelected = NO;
        [self.selectedItems removeObjectForKey:@(gridViewItem.index)];
        /// inform the delegate
        [self gridView:self didDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
    }
    gridViewItem = (self.keyedVisibleItems)[[NSNumber numberWithInteger:selectedItemIndex]];
    if (gridViewItem) {
        /// inform the delegate
        [self gridView:self willSelectItemAtIndex:selectedItemIndex inSection:0];
        if (self.allowsMultipleSelection)
            gridViewItem.isSelected = !gridViewItem.isSelected ? YES : modifierFlags & NSCommandKeyMask ? NO : gridViewItem.isSelected;
        else
            gridViewItem.isSelected = modifierFlags & NSCommandKeyMask ? !gridViewItem.isSelected : YES;

        self.lastSelectedIndex = (self.allowsMultipleSelection ? NSNotFound : selectedItemIndex);
        (self.selectedItems)[[NSNumber numberWithInteger:selectedItemIndex]] = gridViewItem;
        /// inform the delegate
        [self gridView:self didSelectItemAtIndex:selectedItemIndex inSection:0];
    }
}
- (void) handleClicks:(NSTimer*) theTimer
{
	NSUInteger clickCount = [self.clickEvents count];
	clickCount == CNSingleClick ?
	[self handleSingleClickForItemAtIndex:[self indexForItemAtLocation:[[self.clickEvents lastObject]locationInWindow]]]
	: clickCount ==  CNDoubleClick ? ^{
		NSUInteger indexClick1 = [self indexForItemAtLocation:[(self.clickEvents)[0] locationInWindow]];
		NSUInteger indexClick2 = [self indexForItemAtLocation:[(self.clickEvents)[1] locationInWindow]];
		if (indexClick1 == indexClick2) {
			[self handleDoubleClickForItemAtIndex:indexClick1];
		} else {
			[self handleSingleClickForItemAtIndex:indexClick1];
			[self handleSingleClickForItemAtIndex:indexClick2];
		}
	}() : clickCount == CNTrippleClick ? ^{
		NSUInteger indexClick1 = [self indexForItemAtLocation:[(self.clickEvents)[0] locationInWindow]];
		NSUInteger indexClick2 = [self indexForItemAtLocation:[(self.clickEvents)[1] locationInWindow]];
		NSUInteger indexClick3 = [self indexForItemAtLocation:[(self.clickEvents)[2] locationInWindow]];
		if (indexClick1 == indexClick2 == indexClick3) {
			[self handleDoubleClickForItemAtIndex:indexClick1];
		}
		else if ((indexClick1 == indexClick2) && (indexClick1 != indexClick3)) {
			[self handleDoubleClickForItemAtIndex:indexClick1];
			[self handleSingleClickForItemAtIndex:indexClick3];
		}
		else if ((indexClick1 != indexClick2) && (indexClick2 == indexClick3)) {
			[self handleSingleClickForItemAtIndex:indexClick1];
			[self handleDoubleClickForItemAtIndex:indexClick3];
		}
		else if (indexClick1 != indexClick2 != indexClick3) {
			[self handleSingleClickForItemAtIndex:indexClick1];
			[self handleSingleClickForItemAtIndex:indexClick2];
			[self handleSingleClickForItemAtIndex:indexClick3];
		}
	}(): nil;
    [self.clickEvents removeAllObjects];
}
- (void) handleSingleClickForItemAtIndex:(NSUInteger)selectedItemIndex
{
    /// inform the delegate
    [self gridView:self didClickItemAtIndex:selectedItemIndex inSection:0];
    CNLog(@"handleSingleClick for item at index: %lu", selectedItemIndex);
}
- (void) handleDoubleClickForItemAtIndex:(NSUInteger)selectedItemIndex
{
    /// inform the delegate
    [self gridView:self didDoubleClickItemAtIndex:selectedItemIndex inSection:0];
    CNLog(@"handleDoubleClick for item at index: %lu", selectedItemIndex);
}
- (void) drawSelectionFrameForMousePointerAtLocation:(NSPoint)location
{
    if (!self.selectionFrameView) {
        self.selectionFrameInitialPoint = location;
        self.selectionFrameView = [[CNSelectionFrameView alloc] init];
        self.selectionFrameView.frame = NSMakeRect(location.x, location.y, 0, 0);
        if (![self containsSubView:self.selectionFrameView])
            [self addSubview:self.selectionFrameView];
    }
    else {
        NSRect clippedRect = [self clippedRect];
        NSUInteger columnsInGridView = [self columnsInGridView];

        CGFloat posX = ceil((location.x > self.selectionFrameInitialPoint.x ? self.selectionFrameInitialPoint.x : location.x));
        posX = (posX < NSMinX(clippedRect) ? NSMinX(clippedRect) : posX);

        CGFloat posY = ceil((location.y > self.selectionFrameInitialPoint.y ? self.selectionFrameInitialPoint.y : location.y));
        posY = (posY < NSMinY(clippedRect) ? NSMinY(clippedRect) : posY);

        CGFloat width = (location.x > self.selectionFrameInitialPoint.x ? location.x - self.selectionFrameInitialPoint.x : self.selectionFrameInitialPoint.x - posX);
        width = (posX + width >= (columnsInGridView * self.itemSize.width) ? (columnsInGridView * self.itemSize.width) - posX - 1 : width);
        CGFloat height = (location.y > self.selectionFrameInitialPoint.y ? location.y - self.selectionFrameInitialPoint.y : self.selectionFrameInitialPoint.y - posY);
        height = (posY + height > NSMaxY(clippedRect) ? NSMaxY(clippedRect) - posY : height);
        NSRect selectionFrame = NSMakeRect(posX, posY, width, height);
        self.selectionFrameView.frame = selectionFrame;
    }
}
- (void) selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUInteger)modifierFlags
{
    NSUInteger topLeftItemIndex = [self indexForItemAtLocation:[self convertPoint:NSMakePoint(NSMinX(selectionFrame), NSMinY(selectionFrame)) toView:nil]];
    NSUInteger bottomRightItemIndex = [self indexForItemAtLocation:[self convertPoint:NSMakePoint(NSMaxX(selectionFrame), NSMaxY(selectionFrame)) toView:nil]];
    CNItemPoint topLeftItemPoint = [self locationForItemAtIndex:topLeftItemIndex];
    CNItemPoint bottomRightItemPoint = [self locationForItemAtIndex:bottomRightItemIndex];
    /// handle all "by selection frame" selected items beeing now outside
    /// the selection frame
    [[self indexesForVisibleItems] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        AtoZGridViewItem *item = (self.selectedItemsBySelectionFrame)[[NSNumber numberWithInteger:idx]];
        if (item) {
            CNItemPoint itemPoint = [self locationForItemAtIndex:item.index];
            if ((itemPoint.row < topLeftItemPoint.row)              ||  /// top edge out of range
                (itemPoint.column > bottomRightItemPoint.column)    ||  /// right edge out of range
                (itemPoint.row > bottomRightItemPoint.row)          ||  /// bottom edge out of range
                (itemPoint.column < topLeftItemPoint.column))           /// left edge out of range
            {
                /// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
                /// if it there is selected too. If it so, keep it untouched!
                item.isSelected = NO;
                [self.selectedItemsBySelectionFrame removeObjectForKey:@(item.index)];
            }
        }
    }];
    /// update all items that needs to be selected
    NSUInteger columnsInGridView = [self columnsInGridView];
    for (NSUInteger row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
        for (NSUInteger col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
            NSUInteger itemIndex = ((row -1) * columnsInGridView + col) -1;
            AtoZGridViewItem *item = (self.keyedVisibleItems)[[NSNumber numberWithInteger:itemIndex]];
            if (modifierFlags & NSCommandKeyMask) {
                item.isSelected = (item.isSelected ? NO : YES);
            } else {
                item.isSelected = YES;
            }
            (self.selectedItemsBySelectionFrame)[@(item.index)] = item;
        }
    }
}


#pragma mark - Managing the Content
- (NSUInteger)numberOfVisibleItems
{
    return _keyedVisibleItems.count;
}
- (void) removeItem:(AtoZGridViewItem*) theItem
{
}
- (void) removeItemAtIndex:(NSUInteger)index
{
}
- (void) removeAllItems
{
}
- (void) removeAllSelectedItems
{
}


#pragma mark - NSResponder Methods
- (void) mouseExited:(NSEvent*) theEvent
{
    self.lastHoveredIndex = NSNotFound;
}
- (void) mouseMoved:(NSEvent*) theEvent
{
    if (!self.useHover)
        return;
    NSUInteger hoverItemIndex = [self indexForItemAtLocation:theEvent.locationInWindow];
    if (hoverItemIndex != NSNotFound || hoverItemIndex != self.lastHoveredIndex) {
        AtoZGridViewItem *gridViewItem = nil;
        /// unhover the last hovered item
        if (self.lastHoveredIndex != NSNotFound) {
            /// inform the delegate
            [self gridView:self willUnhovertemAtIndex:self.lastHoveredIndex inSection:0];
            gridViewItem = (self.keyedVisibleItems)[@(self.lastHoveredIndex)];
            gridViewItem.isHovered = NO;
        }
        /// inform the delegate
        [self gridView:self willHovertemAtIndex:hoverItemIndex inSection:0];
        self.lastHoveredIndex = hoverItemIndex;
        gridViewItem = (self.keyedVisibleItems)[[NSNumber numberWithInteger:hoverItemIndex]];
        gridViewItem.isHovered = YES;
    }
}
- (void) mouseDragged:(NSEvent*) theEvent
{
    if (!self.allowsMultipleSelection)
        return;
    [NSCursor pointingHandCursor];
    if (!self.abortSelection) {
        NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        [self drawSelectionFrameForMousePointerAtLocation:location];
        [self selectItemsCoveredBySelectionFrame:self.selectionFrameView.frame usingModifierFlags:theEvent.modifierFlags];
    }
}
- (void) mouseUp:(NSEvent*) theEvent
{
    [NSCursor arrowCursor];
    /// remove selection frame
    [[self.selectionFrameView animator] setAlphaValue:0];
    self.selectionFrameView = nil;
    self.abortSelection = NO;
    [self.selectedItems addEntriesFromDictionary:self.selectedItemsBySelectionFrame];
    [self.selectedItemsBySelectionFrame removeAllObjects];
    [self.clickEvents addObject:theEvent];
    self.clickTimer = nil;
    self.clickTimer = [NSTimer scheduledTimerWithTimeInterval:[NSEvent doubleClickInterval] target:self selector:@selector(handleClicks:) userInfo:nil repeats:NO];
}
- (void) mouseDown:(NSEvent*) theEvent
{
    if (!self.allowsSelection)
        return;
    NSPoint location = [theEvent locationInWindow];
    [self selectItemAtIndex:[self indexForItemAtLocation:location] usingModifierFlags:theEvent.modifierFlags];
}
- (void) rightMouseDown:(NSEvent*) theEvent
{
    NSPoint location = [theEvent locationInWindow];
    [self gridView:self rightMouseButtonClickedOnItemAtIndex:[self indexForItemAtLocation:location] inSection:0];
}
- (void) keyDown:(NSEvent*) theEvent
{
    CNLog(@"keyDown");
    switch ([theEvent keyCode]) {
        case 53: {  // escape
            self.abortSelection = YES;
            break;
        }
    }
}


#pragma mark - AtoZGridView Delegate Calls
- (void) gridView:(AtoZGridView*) gridView willHovertemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView willHovertemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*) gridView willUnhovertemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView willUnhovertemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*)gridView willSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView willSelectItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*)gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView didSelectItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*)gridView willDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView willDeselectItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*)gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView didDeselectItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*) gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView didClickItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*) gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView didDoubleClickItemAtIndex:index inSection:section];
    }
}
- (void) gridView:(AtoZGridView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate gridView:gridView rightMouseButtonClickedOnItemAtIndex:index inSection:section];
    }
}


#pragma mark - AtoZGridView DataSource Calls
- (NSUInteger)gridView:(AtoZGridView*) gridView numberOfItemsInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource gridView:gridView numberOfItemsInSection:section];
    }
    return NSNotFound;
}
- (AtoZGridViewItem*) gridView:(AtoZGridView*) gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource gridView:gridView itemAtIndex:index inSection:section];
    }
    return nil;
}
- (NSUInteger)numberOfSectionsInGridView:(AtoZGridView*) gridView
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource numberOfSectionsInGridView:gridView];
    }
    return NSNotFound;
}
- (NSString*) gridView:(AtoZGridView*) gridView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource gridView:gridView titleForHeaderInSection:section];
    }
    return nil;
}
- (NSArray*) sectionIndexTitlesForGridView:(AtoZGridView*) gridView
{
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource sectionIndexTitlesForGridView:gridView];
    }
    return nil;
}





#pragma mark - AtoZGridView Item Default Colors
- (NSColor*) itemBackgroundColor
{
    return _itemBackgroundColor ?: [NSColor colorWithCalibratedWhite:0.238 alpha:1.000];
}
- (NSColor*) itemBackgroundHoverColor
{
    return /* _itemBackgroundHoverColor ?:*/ [NSColor redColor];
}
- (NSColor*) itemBackgroundSelectionColor
{
    return _itemBackgroundSelectionColor ?: [NSColor colorWithCalibratedWhite:0.172 alpha:1.000];
}
- (NSColor*) itemSelectionRingColor
{
    return _itemSelectionRingColor ?: [NSColor colorWithCalibratedWhite:0.740 alpha:1.000];
}
- (NSColor*) itemTitleColor
{
    return _itemTitleColor ?: [NSColor colorWithDeviceRed:0.969 green:0.994 blue:0.994 alpha:1.000];
}
- (NSColor*) itemTitleShadowColor
{
    return _itemTitleShadowColor ?: [NSColor colorWithDeviceWhite:0.011 alpha:0.930];
}
- (NSColor*) selectionFrameColor
{
    return _selectionFrameColor ?: [NSColor colorWithCalibratedRed:0.908 green:0.784 blue:0.170 alpha:1.000];
}
- (NSColor*) backgroundColor
{
    return _backgroundColor ?: [NSColor colorWithCalibratedWhite:0.137 alpha:1.000];
}



//+ (AtoZGridViewItemLayout*) defaultLayout
//{
//    AtoZGridViewItemLayout *defaultLayout = [[self class] new];
//    return defaultLayout;
//}

@end


#pragma mark - CNSelectionFrameView
@implementation CNSelectionFrameView
- (void) drawRect:(NSRect)rect
{
    NSRect dirtyRect = NSMakeRect(0.5, 0.5, floorf(NSWidth(self.bounds))-1, floorf(NSHeight(self.bounds))-1);
    NSBezierPath *selectionFramePath = [NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:0 yRadius:0];
    [[[NSColor lightGrayColor] colorWithAlphaComponent:0.42] setFill];
    [selectionFramePath fill];
    [[NSColor whiteColor] set];
    [selectionFramePath setLineWidth:2];
    [selectionFramePath stroke];
}
- (BOOL)isFlipped
{
    return YES;
}
@end


@interface AtoZGridViewItem ()
@property (strong) NSImageView *itemImageView;
//@property (strong, nonatomic) CAShapeLayer *selectionLayer;
//@property (strong) AtoZGridViewItemLayout *currentLayout;
@end
@implementation AtoZGridViewItem

//#pragma mark - Initialzation
+ (void)initialize
{
    kCNDefaultItemIdentifier = @"AtoZGridViewItem";
	//    kDefaultItemSize         = NSMakeSize(96, 96);
}
//+ (CGSize)defaultItemSize
//{
//    return kDefaultItemSize;
//}
- (id)init
{
	if (!(self = [super init])) return nil;
	[self initProperties];
    return self;
}
- (id)initWithCoder:(NSCoder*) aDecoder
{
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	[self initProperties];
    return self;
}
- (id)initInGrid:(AtoZGridView *)grid reuseIdentifier:(NSString *)reuseIdentifier
{
	if (!(self = [super init])) return nil;
	_grid = grid;
	[self initProperties];
	//	_standardLayout = layout;
	//	_reuseIdentifier = reuseIdentifier;
    return self;
}
- (void) initProperties
{
	//	self.wantsLayer		= YES;
    /// Reusing Grid View Items
    _reuseIdentifier 	= kCNDefaultItemIdentifier;
    /// Item Default Content
    _itemImage	 		= nil;
    _itemTitle 			= @"";
    _index 				= CNItemIndexNoIndex;
    /// Grid View Item Layout

	//	_standardLayout 	= [AtoZGridViewItemLayout defaultLayout];
	//    _hoverLayout 		= [AtoZGridViewItemLayout defaultLayout];
	//    _selectionLayout 	= [AtoZGridViewItemLayout defaultLayout];
	//    _currentLayout 		= _standardLayout;
    _useLayout 			= YES;
    /// Selection and Hovering
    _isSelected	 		= NO;
    _isSelectable 		= YES;
    _isHovered 			= NO;
}
- (BOOL)isFlipped
{
    return YES;
}


#pragma mark - Reusing Grid View Items
- (void) prepareForReuse
{
    self.itemImage 		= nil;
    self.itemTitle 		= @"";
    self.index 			= CNItemIndexNoIndex;
    self.isSelected 	= NO;
    self.isSelectable 	= YES;
    self.isHovered 		= NO;
}


#pragma mark - ViewDrawing
- (void) drawRect:(NSRect)rect
{
    NSRect dirtyRect = self.bounds;
    // decide which layout we have to use
    /// contentRect is the rect respecting the value of layout.contentInset
    NSRect contentRect = NSMakeRect(dirtyRect.origin.x + self.grid.contentInset, //self.currentLayout.contentInset,
                                    dirtyRect.origin.y + self.grid.contentInset, //self.currentLayout.contentInset,
                                    dirtyRect.size.width - self.grid.contentInset * 2, //self.currentLayout.contentInset * 2,
                                    dirtyRect.size.height - self.grid.contentInset * 2); //self.currentLayout.contentInset * 2);
    NSBezierPath *contentRectPath = [NSBezierPath bezierPathWithRoundedRect:contentRect
                                                                    xRadius:self.grid.itemBorderRadius //self.currentLayout.itemBorderRadius
                                                                    yRadius:self.grid.itemBorderRadius];//self.currentLayout.itemBorderRadius];
    [self.grid.itemBackgroundColor setFill];//currentLayout.itemBackgroundColor setFill];
    [contentRectPath fill];
	if (self.isSelected) [self.grid.itemBackgroundSelectionColor setFill];
	[contentRectPath fill];
	if (self.isHovered) [self.grid.itemBackgroundHoverColor setFill];
	[contentRectPath fill];

    /// draw selection ring
    if (self.isSelected) {
        [self.grid.itemSelectionRingColor setStroke];//currentLayout.itemSelectionRingColor setStroke];
        [contentRectPath setLineWidth:self.grid.selectionRingLineWidth];//currentLayout.selectionRingLineWidth];
        [contentRectPath stroke];
    }

	//    NSRect srcRect = NSZeroRect;
	//    srcRect.size = self.itemImage.size;
    NSRect imageRect = NSInsetRect([self bounds], self.grid.contentInset*2, self.grid.contentInset*2);//NSZeroRect;
    NSRect textRect = NSZeroRect;
    if (self.grid.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//currentLayout.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//        imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//                               self.currentLayout.contentInset + 10,
		//                               self.itemImage.size.width,
		//                               self.itemImage.size.height);
        [self.itemImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
		if (self.isHovered) {
			textRect = NSMakeRect(contentRect.origin.x + 3,
								  NSHeight(contentRect) - 6,
								  NSWidth(contentRect) - 6,
								  14);
			[self.itemTitle drawInRect:textRect withAttributes:self.grid.itemTitleTextAttributes];
		}
    }
    else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentImage) {
		//        imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//                               ((NSHeight(contentRect) - self.itemImage.size.height) / 2) + self.currentLayout.contentInset,
		//                               self.itemImage.size.width,
		//                               self.itemImage.size.height);
    }
    else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentTitle) {
    }
}


#pragma mark - Notifications
//- (void) clearHovering
//{
//    self.isHovered = NO;
//}
//- (void) clearSelection
//{
//    self.isSelected = NO;
//}


//- (CAShapeLayer*)selectionLayer {
//	CAShapeLayer *layer = _selectionLayer ?: [CAShapeLayer layer];
//	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:self.bounds xRadius:self.grid.itemBorderRadius yRadius:self.grid.itemBorderRadius];
////	layer.path =
//	return layer;
//}

#pragma mark - Accessors
- (void) setIsHovered:(BOOL)isHovered
{
    _isHovered = isHovered;
	//    _currentLayout = (isHovered ? _hoverLayout : (_isSelected ? _selectionLayout : _standardLayout));
    [self setNeedsDisplay:YES];
}
- (void) setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
	//    _currentLayout = isSelected ? _selectionLayout : _standardLayout;
    [self setNeedsDisplay:YES];
}
- (BOOL)isReuseable
{
    return _isSelected ? NO : YES;
}



@end

@implementation  AtoZGridViewAuto

-(void) viewDidMoveToSuperview {
	[@[self, _scrollView, _grid] do:^(id obj) {
		[(NSV*)obj setFrame:self.superview.bounds];
	}];
}

-(id) initWithArray:(NSArray *)array  // inView:(NSView *)view
{
	if (!(self = [super initWithFrame:NSZeroRect])) return nil;
	self.arMASK 		= NSSIZEABLE;
	self.autoresizesSubviews = YES;
	_array 				= [array map:^id(id obj) {
		return @{ kContentImageKey: obj, kContentTitleKey: [obj valueForKey:@"name"] ?: @"N/A"};
	}];
//	_view 				= view;
	_grid 				= [[AtoZGridView alloc]initWithFrame:NSZeroRect];
	_grid.delegate 		= self;
	_grid.dataSource 	= self;
	_scrollView 		= [[NSScrollView alloc] initWithFrame:NSZeroRect];

	// configure the scroll view
	[_scrollView setBorderType:NSNoBorder];
	[_scrollView setHasVerticalScroller:YES];

	// embed your custom view in the scroll view
	[_scrollView setDocumentView:_grid];
	[self addSubview:_scrollView];
	// set the scroll view as the content view of your window
//	[view addSubview:self];
	_grid.scrollElasticity = NO;
	[self setItemSize:(NSSize){65,65}];
	__block AtoZGridView *grid = _grid;
	[NSEVENTLOCALMASK: NSLeftMouseUp handler:^NSEvent *(NSEvent *e) {
		if ( [e clickCount] == 3 ) {
			grid.itemSize = [AZSizer forQuantity:_array.count inRect:self.bounds].size;
			[grid reloadData];
		}
		return e;
	}];
	return self;
}

-(void) setItemSize:(NSSize)itemSize
{
	_itemSize = itemSize;
	self.grid.itemSize = _itemSize;
	[self.grid reloadData];
}

- (NSUInteger)gridView:(AtoZGridView*) gridView numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"gris view items reported as %ld", self.array.count);
    return self.array.count;
}
- (AtoZGridViewItem*) gridView:(AtoZGridView*) gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section
{

    AtoZGridViewItem *item = 	[gridView dequeueReusableItemWithIdentifier:reuseIdentifier];
	if (item) { NSLog(@"did dequeue index: %lu item: %@", index, item);
	} else {
		item =	[[AtoZGridViewItem alloc] initInGrid:_grid reuseIdentifier:reuseIdentifier];
		NSLog(@"did create item for index: %lu", index);
	}
    NSDictionary *contentDict = self.array[index];
	item.itemTitle = contentDict[kContentTitleKey];
    item.itemImage = contentDict[kContentImageKey];
    return item;
}


#pragma mark - AtoZGridView Delegate
- (void) gridView:(AtoZGridView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    NSLog(@"rightMouseButtonClickedOnItemAtIndex: %li", index);
}
@end

