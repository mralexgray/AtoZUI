
#import <Cocoa/Cocoa.h>


@interface BGTheme : NSObject
{
	BOOL useAlpha;
}

//	General Theme

//	Alphas used only if you want certain colors to be draw with the same	alpha value.
@property (readonly) CGFloat 	 gradientAngle, alphaValue, disabledAlphaValue;

//	Gradient used to draw standard and complex (4 tone) normal,  disabled,  pushed, and highlight background
@property (readonly) NSGradient *normalGradient, *disabledNormalGradient, *highlightGradient, *pushedGradient,
								*normalComplexGradient, *disabledNormalComplexGradient, *pushedComplexGradient, *highlightComplexGradient;;

//	Solid color used to draw normal, disabled, pushed, and highlight background.
@property (readonly) NSColor 	*normalSolidFill, *disabledNormalSolidFill, *pushedSolidFill, *highlightSolidFill;

//	Color used to draw borders, disabled brders, and dark shadow borders.
@property (readonly) NSColor 	*strokeColor, *disabledStrokeColor, *darkStrokeColor;

 // 	Color used to draw standard, hightlight text, disabled text
@property (readonly) NSColor 	*textColor, *highlightTextColor, *disabledTextColor;

//	Drop shadow used on all controls   + Shadow used for the focus rings
@property (readonly) NSShadow *dropShadow, *focusRing;

//	Scroller Theme
//	Color for Arrows/Knob Border
@property (readonly) NSColor 	*scrollerStroke;
//	Gradient used to draw knob, knob track, normal Arrow button, and pushed Arrow button
@property (readonly) NSGradient	*scrollerKnobGradient, *scrollerTrackGradient, *scrollerArrowNormalGradient, *scrollerArrowPushedGradient;
@property (readonly) CGFloat 	scrollerAlphaValue;

													//	Slider Theme
- (NSColor*)	sliderTrackColor;					//	Color used to draw          slider track
- (NSColor*)	disabledSliderTrackColor; 			//	Color used to draw disabled slider track
- (NSGradient*)	knobColor;							//	Gradient used to draw         the knob
- (NSGradient*)	highlightKnobColor;					//	Gradient used to draw highlighted knob
- (NSGradient*)	disabledKnobColor;					//	Gradient used to draw    disabled knob

													//	Text Based Theme
- (NSColor*)	textFillColor;						//	Color of background if drawbackground set to ON
- (NSColor*)	selectionHighlightActiveColor;		//	Background color of higlighted text (active app)
- (NSColor*)	selectionHighlightInActiveColor;	//	Background color of higlighted text (inactive app)
- (NSColor*)	selectionTextActiveColor;			//	Selection text color (active app)
- (NSColor*)	selectionTextInActiveColor;			//	Selection text color (inactive app)
- (NSColor*)	placeholderTextColor;				//	Placeholder text color
- (BOOL)		isOverrideFillColor;

													//	Progress Theme
- (NSGradient*)	progressTrackGradient;				//	Gradient used to draw progress bar track

													//	Token Theme
- (NSColor*)	tokenFillNormal;					//	Color used to fill      normal token background
- (NSColor*)	tokenFillHighlight;					//	Color used to fill highlighted token background
- (NSColor*)	tokenBorder;							//	Color used to draw token border
- (NSColor*)	tokenTextColor;						//	Color used to draw token text

													//	Table Theme
- (NSColor*)	cellHighlightColor;					//	Color used to highlight selected row
- (NSArray*)	cellAlternatingRowColors;			//	NSArray with 2 Colors used to draw alternating rows
- (NSColor*)	cellSelectedTextColor;				//	Color used to draw text when row selected
- (NSColor*)	cellEditingFillColor;				//	Color used to draw background of editing cell
- (NSColor*)	tableBackgroundColor;				//	Color used to fill table background
- (NSColor*)	tableHeaderCellBorderColor;			//	Color used to draw border in column headers

- (NSGradient*)	tableHeaderCellNormalFill;			//	Gradient used to draw   normal column header
- (NSGradient*)	tableHeaderCellPushedFill;			//	Gradient used to draw   pushed column header
- (NSGradient*)	tableHeaderCellSelectedFill;		//	Gradient used to draw selected column header



@end


@interface BGGradientTheme : BGTheme
@end

@interface AZDebugTheme : BGTheme
@end

@interface AZFlatTheme : BGTheme
@end


