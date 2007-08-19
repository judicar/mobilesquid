#import "UITextLabelSubclass.h"

@implementation UITextLabelSubclass

- (id)initWithFrame: (struct CGRect) rect
{
	_fntName = @"ArialBold";
	_fntSize = 15.0f;
	_cW = 7;
	_cH = 18;

	transform = CGAffineTransformMake(1, 0, 0, -1, 0, ( rect.size.height / 30 ));
	
	_br = 1.0f;
	_bg = 1.0f;
	_bb = 1.0f;
	_ba = 1.0f;
	
	_fr = 0.0f;
	_fg = 0.0f;
	_fb = 0.0f;
	_fa = 1.0f;
		
	return [super initWithFrame: rect];
}

- (id)initWithFrameAndDelegate:(struct CGRect)rect delegate:(id)delegate
{
	id o = [self initWithFrame:rect];

	[super setTapDelegate:delegate];
	_delegate = delegate;
	
	if( [_delegate respondsToSelector:@selector( processLabels: )] )
		[_delegate processLabels:self];
		
	return o;
}

- (void)setFontName:(NSString *)font
{
	_fntName = font;
}

- (void)dealloc
{
	CGColorRelease(_bgColor);
	CGColorRelease(_fgColor);
}

- (void)setFontSize:(float)size
{
	_fntSize = size;
}

- (void)setBGColor:(float)r g:(float)g b:(float)b a:(float)a
{
	_br = r;
	_bg = g;
	_bb = b;
	_ba = a;
}
- (void)setFGColor:(float)r g:(float)g b:(float)b a:(float)a
{
	_fr = r;
	_fg = g;
	_fb = b;
	_fa = a;
}
- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UICurrentContext();
	
	CGContextSetRGBFillColor(context, _br, _bg, _bb, _ba);
	CGContextFillRect(context, rect);	

	char *fn = [_fntName cStringUsingEncoding: NSASCIIStringEncoding];
	CGContextSelectFont(context, fn, _fntSize, kCGEncodingMacRoman);
	CGContextSetRGBFillColor(context, _fr, _fg, _fb, _fa);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetTextMatrix(context, transform);
	NSString *s = [self text];
	CGContextShowTextAtPoint(context, _cW, _cH , [s UTF8String], [s length]);
}

- (void)drawContentsInRect:(CGRect)rect
{

}

@end
