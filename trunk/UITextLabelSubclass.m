#import "UITextLabelSubclass.h"

@implementation UITextLabelSubclass

- (id)initWithFrame: (struct CGRect) rect
{
	_fontName = @"CourierNew";
	_fontSize = 15.0f;
	_c = {.1, .1, .1, 1};
	_cW = 7;
	_cH = 18;
	context = UICurrentContext();
	float _w = rect.size.width;
	float _h = rect.size.height;
	transform = CGAffineTransformMake(1, 0, 0, -1, 0, _h/30);
	
	return [super initWithFrame: rect];
}

- (void)setFont:(NSString *)font
{
	_fontName = font;
}

- (void)setFontSize:(float)size
{
	_fontSize = size;
}

- (void)drawContentsInRect:(CGRect)rect
{
	CGContextSelectFont(context, [_fontName UTF8String], _fontSize, kCGEncodingMacRoman);
	CGContextSetRGBFillColor(context, _c[0], _c[1], _c[2], _c[3]);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetTextMatrix(context, transform);
	NSString *s = [self text];
	CGContextShowTextAtPoint(context, _cW, _cH , [s UTF8String], [s length]);
}

@end
