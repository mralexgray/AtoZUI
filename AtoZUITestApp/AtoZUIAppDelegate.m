//
//  bghudtestAppDelegate.m
//  Created by Timothy Davis on 4/12/11.

#import "AtoZUIAppDelegate.h"

@interface  AtoZUIAppDelegate ()
@property (assign, nonatomic) BOOL spinning;
@property (assign, nonatomic) double progress;
@end
@implementation AtoZUIAppDelegate

@synthesize window, tabView;



- (IBAction) doSegmentStuff: (id)sender
{
	NSInteger seg = [sender selectedSegment];
	switch (seg) {
		case 0: self.spinning =! self.spinning; break;
		case 1: self.progress = self.progress <= 100 ? self.progress + 10 : 0;
		default: break;
	}
}

- (void) setProgress:(double)progress
{
	[@[_spinner, _bar] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[obj stopAnimation:nil];
		[obj setDoubleValue:progress];
	}];
	_progress = progress;
}

-(void) setSpinning:(BOOL)spinning
{
	[@[_spinner, _bar] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		spinning ? [obj startAnimation:nil] : [obj stopAnimation:nil];
	}];
	_spinning = spinning;
}
- (IBAction)setViewColor:(id)sender
{
	[self.windowView.theme setBaseColor:self.colorWell.color];
	[[[self window] contentView]setNeedsDisplay:YES];
}



- (void) awakeFromNib //:(NSNotification*) aNotification
{
	// Insert code here to initialize your application
    NSLog(@"Done with initialization");
    NSLog(@"TabView: %@", tabView);

	//    self.gridView.itemBackgroundColor 	 = [[NSColor redColor] colorWithAlphaComponent:0.42];
	//    self.gridView.itemBackgroundColor = [NSColor colorWithCalibratedRed:0.195 green:0.807 blue:0.807 alpha:1.000];
    /// insert some content
	_items = [@[[NSImage imageNamed:NSImageNameActionTemplate], [NSImage imageNamed:NSImageNameAdvanced]]map:^id(id obj) {
		return @{ kContentImageKey: obj, kContentTitleKey: [obj valueForKey:@"name"] ?: @"N/A"};
		}].mutableCopy;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:kItemSizeSliderPositionKey]) {
        self.itemSizeSlider.integerValue = [defaults integerForKey:kItemSizeSliderPositionKey];
    }
    self.gridView.itemSize = NSMakeSize(self.itemSizeSlider.integerValue, self.itemSizeSlider.integerValue);
	//    self.gridView.backgroundColor = [NSColor //colorWithPatternImage:[NSImage imageNamed:@"BackgroundNoisy"]];
    self.gridView.scrollElasticity = NO;
    [self.gridView reloadData];
}
- (IBAction)itemSizeSliderAction:(id)sender
{
    self.gridView.itemSize = NSMakeSize(self.itemSizeSlider.integerValue, self.itemSizeSlider.integerValue);
    [[NSUserDefaults standardUserDefaults] setInteger:self.itemSizeSlider.integerValue forKey:kItemSizeSliderPositionKey];
}
//- (IBAction)allowMultipleSelectionCheckboxAction:(id)sender
//{
//    self.gridView.allowsMultipleSelection = (self.allowMultipleSelectionCheckbox.state == NSOnState ? YES : NO);
//}
//
//- (IBAction)visibleContentCheckboxAction:(id)sender
//{
//	//    self.hoverLayout.visibleContentMask = AtoZGridViewItemVisibleContentNothing;
//	self.gridView.visibleContentMask = self.visibleContentCheckbox.state == NSOnState ? AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle : AtoZGridViewItemVisibleContentNothing;
//	[_gridView reloadData];
//
//}
- (IBAction)deleteButtonAction:(id)sender
{

}


#pragma mark - AtoZGridView DataSource
- (NSUInteger)gridView:(AtoZGridView*) gridView numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"gris view items reported as %ld", self.items.count);
    return self.items.count;
}
- (AtoZGridViewItem*) gridView:(AtoZGridView*) gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section
{

    AtoZGridViewItem *item = 	[gridView dequeueReusableItemWithIdentifier:reuseIdentifier];
	if (item) { NSLog(@"did dequeue index: %lu item: %@", index, item);
	} else {
		item =	[[AtoZGridViewItem alloc] initInGrid:_gridView reuseIdentifier:reuseIdentifier];
		NSLog(@"did create item for index: %lu", index);
	}

	//:[AtoZGridViewItemLayout defaultLayout] reuseIdentifier:reuseIdentifier];
	//    item.hoverLayout 	 = self.hoverLayout;
	//    item.selectionLayout = self.selectionLayou	t;
    NSDictionary *contentDict = self.items[index];
//	NSLog(@"Reporting dictionary: %@", contentDict);
	item.itemTitle = contentDict[kContentTitleKey];//[NSString stringWithFormat:@"Item: %lu", index];
    item.itemImage = contentDict[kContentImageKey];
    return item;
}


#pragma mark - AtoZGridView Delegate
- (void) gridView:(AtoZGridView*) gridView willHovertemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
{
}
- (void) gridView:(AtoZGridView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section
{
    NSLog(@"rightMouseButtonClickedOnItemAtIndex: %li", index);
}
@end
