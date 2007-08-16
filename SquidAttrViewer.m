#import "SquidAttrViewer.h"

@implementation SquidAttrViewer 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		_delegate = nil;
	}

	_date = [[UITextLabelSubclass alloc] initWithFrame: CGRectMake(0,40,320,60)];
	
	[self addSubview:_date];	
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
//	NSNumber *perms = [[dict objectForKey:NSFilePosixPermissions] intValue];
	NSDate *date = [dict objectForKey:NSFileModificationDate];

	[_date setText:[NSString stringWithFormat:@"Last Modified: %@",
		[date descriptionWithCalendarFormat:@"%a, %d %b %Y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]]];
}
@end
