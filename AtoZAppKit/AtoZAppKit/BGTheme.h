
#import <Cocoa/Cocoa.h>


@interface BGTheme : NSObject
@end

@interface BGTheme ()

@property (nonatomic, assign)	BOOL useAlpha;

@property (nonatomic, strong) NSColor *baseColor;

//	General Theme
//	Alphas used only if you want certain colors to be draw with the same	alpha value.
@property (nonatomic, assign) CGFloat 	 gradientAngle, alphaValue, disabledAlphaValue;

//	Gradient used to draw standard and complex (4 tone) normal,  disabled,  pushed, and highlight background
@property (nonatomic, strong) NSGradient *normalGradient, *disabledNormalGradient, *highlightGradient, *pushedGradient,
								*normalComplexGradient, *disabledNormalComplexGradient, *pushedComplexGradient, *highlightComplexGradient;;

//	Solid color used to draw normal, disabled, pushed, and highlight background.
@property (nonatomic, strong) NSColor 	*normalSolidFill, *disabledNormalSolidFill, *pushedSolidFill, *highlightSolidFill;

//	Color used to draw borders, disabled brders, and dark shadow borders.
@property(nonatomic, strong) NSColor 	*strokeColor, *disabledStrokeColor, *darkStrokeColor;

 // 	Color used to draw standard, hightlight text, disabled text
@property(nonatomic, strong) NSColor 	*textColor, *highlightTextColor, *disabledTextColor;

//	Drop shadow used on all controls   + Shadow used for the focus rings
@property( nonatomic, strong) NSShadow *dropShadow, *focusRing;

//	Scroller Theme
//	Color for Arrows/Knob Border
@property( nonatomic, strong) NSColor 	*scrollerStroke;
//	Gradient used to draw knob, knob track, normal Arrow button, and pushed Arrow button
@property (nonatomic, strong) NSGradient	*scrollerKnobGradient, *scrollerTrackGradient, *scrollerArrowNormalGradient, *scrollerArrowPushedGradient;
@property (nonatomic, assign) CGFloat 	scrollerAlphaValue;

													//	Slider Theme
@property (nonatomic, strong) NSColor*	sliderTrackColor;					//	Color used to draw          slider track
@property (nonatomic, strong) NSColor*	disabledSliderTrackColor; 			//	Color used to draw disabled slider track
@property (nonatomic, strong) NSGradient*	knobColor;							//	Gradient used to draw         the knob
@property (nonatomic, strong) NSGradient*	highlightKnobColor;					//	Gradient used to draw highlighted knob
@property (nonatomic, strong) NSGradient*	disabledKnobColor;					//	Gradient used to draw    disabled knob

													//	Text Based Theme
@property (nonatomic, strong) NSColor*	textFillColor;						//	Color of background if drawbackground set to ON
@property (nonatomic, strong) NSColor*	selectionHighlightActiveColor;		//	Background color of higlighted text (active app)
@property (nonatomic, strong) NSColor*	selectionHighlightInActiveColor;	//	Background color of higlighted text (inactive app)
@property (nonatomic, strong) NSColor*	selectionTextActiveColor;			//	Selection text color (active app)
@property (nonatomic, strong) NSColor*	selectionTextInActiveColor;			//	Selection text color (inactive app)
@property (nonatomic, strong) NSColor*	placeholderTextColor;				//	Placeholder text color
- (BOOL)		isOverrideFillColor;

													//	Progress Theme
@property (nonatomic, strong) NSGradient*	progressTrackGradient;				//	Gradient used to draw progress bar track

													//	Token Theme
@property (nonatomic, strong) NSColor*	tokenFillNormal;					//	Color used to fill      normal token background
@property (nonatomic, strong) NSColor*	tokenFillHighlight;					//	Color used to fill highlighted token background
@property (nonatomic, strong) NSColor*	tokenBorder;							//	Color used to draw token border
@property (nonatomic, strong) NSColor*	tokenTextColor;						//	Color used to draw token text

					//	Color used to draw token text

													//	Table Theme
@property (nonatomic, strong) NSColor*	cellHighlightColor;					//	Color used to highlight selected row
@property (nonatomic, strong) NSArray*  cellAlternatingRowColors;			//	NSArray with 2 Colors used to draw alternating rows
@property (nonatomic, strong) NSColor*	cellSelectedTextColor;				//	Color used to draw text when row selected
@property (nonatomic, strong) NSColor*	cellEditingFillColor;				//	Color used to draw background of editing cell
@property (nonatomic, strong) NSColor*	tableBackgroundColor;				//	Color used to fill table background
@property (nonatomic, strong) NSColor*	tableHeaderCellBorderColor;			//	Color used to draw border in column headers

@property (nonatomic, strong) NSGradient*	tableHeaderCellNormalFill;			//	Gradient used to draw   normal column header
@property (nonatomic, strong) NSGradient*	tableHeaderCellPushedFill;			//	Gradient used to draw   pushed column header
@property (nonatomic, strong) NSGradient*	tableHeaderCellSelectedFill;		//	Gradient used to draw selected column header



@end


@interface BGGradientTheme : BGTheme
@end

@interface AZDebugTheme : BGTheme
@end

@interface AZFlatTheme : BGTheme
@end


