#import "SquidAttrViewer.h"

@implementation SquidAttrViewer 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		_delegate = nil;
	}
	_view = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
	[_view setText:@"Blah blah blah"];
	[self addSubview:_view];
	return self;
}

- (void)dealloc {
	_delegate = nil;
	[super dealloc];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

@end
