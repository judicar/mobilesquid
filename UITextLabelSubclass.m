#import "UITextLabelSubclass.h"

@implementation UITextLabelSubclass

- (id)initWithFrame: (struct CGRect) aRect
{
	return [super initWithFrame: aRect];
}

- (void)drawContentsInRect:(CGRect)rect
{
  CGContextRef context = UICurrentContext();
  
  float w = rect.size.width;
  float h = rect.size.height;
  
  CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, h/30);

  CGContextSelectFont(context, "CourierNew", 15.0f,
                      kCGEncodingMacRoman);
  CGContextSetRGBFillColor(context, .1, .1, .1, 1);

  CGContextSetTextDrawingMode(context, kCGTextFill);
  CGContextSetTextMatrix(context, transform);
  NSString *s = [self text];
  char *c = [s UTF8String];
  int i=0;
  for(i=0;i < [s length]; i++)
  {
	if(c[i] == 0)
		c[i] = ' ';
	CGContextShowTextAtPoint(context,7*i, 18 , &c[i], 1);
  }
}

@end
