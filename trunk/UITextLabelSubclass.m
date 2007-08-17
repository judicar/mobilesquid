#import "UITextLabelSubclass.h"

@implementation UITextLabelSubclass

- (id)initWithFrame: (struct CGRect) rect
{
	_fntName = "ArialBold";
	_fntSize = 15.0f;
	_cW = 7;
	_cH = 18;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	transform = CGAffineTransformMake(1, 0, 0, -1, 0, ( rect.size.height / 30 ));
	float _fc[4] = {0,0,0,1};
	_fgColor = CGColorCreate(colorSpace, _fc);
	
	float _bc[4] = {1,1,1,1};
	_bgColor = CGColorCreate(colorSpace, _bc);
	[self setBackgroundColor: _bgColor];
	return [super initWithFrame: rect];
}

- (void)setFontName:(NSString *)font
{
	const char *tmp;
	tmp = (const char*)malloc(sizeof(const char) * ([font length]+1));
	strcpy(tmp, [font UTF8String]);
	delete _fntName;
	_fntName = tmp;
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

- (void)drawContentsInRect:(CGRect)rect
{
	CGContextRef context = UICurrentContext();
	CGContextSelectFont(context, _fntName, _fontSize, kCGEncodingMacRoman);
	const float* fgc = CGColorGetComponents(_fgColor);
	CGContextSetRGBFillColor(context, fgc[0], fgc[1], fgc[2], fgc[3]);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetTextMatrix(context, transform);
	NSString *s = [self text];
	CGContextShowTextAtPoint(context, _cW, _cH , [s UTF8String], [s length]);
}

@end
