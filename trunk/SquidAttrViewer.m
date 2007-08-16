#import "SquidAttrViewer.h"

@implementation MyTextLabel
- (id)initWithFrame: (struct CGRect) aRect
{
	return [super initWithFrame: aRect];
}

/*

- (void)drawRect:(CGRect)rect
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
  char c = 'G';
  CGContextShowTextAtPoint(context, 0, 15 , &c, 1);



[super drawContentsInRect:rect];
}
*/

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

@implementation SquidAttrViewer 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		_delegate = nil;
	}

	_date = [[UITextLabel alloc] initWithFrame: CGRectMake(0,0,0,0)];
	_test = [[MyTextLabel alloc] initWithFrame: CGRectMake(0,40,320,60)];
	
	[_test setText:@"A test"];
	
	[self addSubview:_date];
	[self addSubview:_test];	
	return self;
}

- (void)dealloc {

	[_date release];
	_delegate = nil;
	[super dealloc];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict
{
	NSNumber *perms = [[dict objectForKey:NSFilePosixPermissions] intValue];
	NSDate *date = [dict objectForKey:NSFileModificationDate];
	CGContextRef context = UICurrentContext();
	CGContextSelectFont(context, "CourierNewBold", 9, kCGEncodingMacRoman);
	[_test setText:[NSString stringWithFormat:@"Last Modified: %@",
		[date descriptionWithCalendarFormat:@"%a, %d %b %Y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]]];
	[_date sizeToFit];
}
@end
