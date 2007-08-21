#import "AccordionView.h"

@implementation AccordionPanel    
- (id)initWithFrameAndTitle:(struct CGRect)frame title:(NSString *)title
{
        if ((self == [super initWithFrame: frame]) != nil) 
        {

        }

		_pushbar = [[UIPushButton alloc] initWithTitle:title];	
		_pushbarUp = [UIImage imageNamed:@"pushbuttonup.png"];
		_pushbarDwn = [UIImage imageNamed:@"pushbuttonup.png"];
		
		[_pushbar setFrame:CGRectMake(0,0,frame.size.width,29.0f)];
		[_pushbar setDrawsShadow:YES];
		[_pushbar setEnabled:YES];
		[_pushbar setStretchBackground:YES];
		[_pushbar setBackground:_pushbarUp forState:0];
		[_pushbar setBackground:_pushbarDwn forState:1];
		[_pushbar addTarget:self action:@selector(pushbarClicked:) forEvents:1];

		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		float _fc[4] = {0.3f, 0.3f, 0.3f, 1.0f};
		CGColorRef fg = CGColorCreate(colorSpace, _fc);
		[self setBackgroundColor:fg];

		_translationUp = [[UITransformAnimation alloc] initWithTarget: self];
		_translationDwn = [[UITransformAnimation alloc] initWithTarget: self];
	
		struct CGAffineTransform _up = CGAffineTransformMakeTranslation(0, 0.0f);
		struct CGAffineTransform _down = CGAffineTransformMakeTranslation(0, frame.size.height - 29.0f);
	
		[_translationUp setStartTransform: _down];
		[_translationUp setEndTransform: _up];
	
		[_translationDwn setStartTransform: _up];
		[_translationDwn setEndTransform: _down];

		_fixed = NO;
		_Up = YES;
		
		[self addSubview:_pushbar];
		
        return self;
}

- (void)setTitle:(NSString *)title
{
	[_pushbar setTitle:title];
}

- (void)setNextPanel:(AccordionPanel *)panel
{
	_next = panel;
}

- (void)setPrevPanel:(AccordionPanel *)panel
{
	_prev = panel;
}

- (void)setFixed:(BOOL)fixed
{
	_fixed = fixed;
}

- (void)toggle
{
	if(_Up)
		[self hide];
	else
		[self show];
}

- (void)show
{
	if(!_fixed && !_Up)
	{
		_Up = YES;
		if(_prev)
			[_prev show];
		UIAnimator *_a = [[UIAnimator alloc] init];
		[_a addAnimation:_translationUp withDuration:0.5f start:YES];
	}
}

- (void)hide
{
	if(!_fixed && _Up)
	{
		_Up = NO;
		if(_next)
			[_next hide];
		UIAnimator *_a = [[UIAnimator alloc] init];
		[_a addAnimation:_translationDwn withDuration:0.5f start:YES];
	}
}

- (void)pushbarClicked:(UIPushButton *)button
{
	[self toggle];
}

- (void)dealloc
{
	[_translationUp release];
	[_translationDwn release];
	[_pushbar release];
	[_pushbarUp release];
	[_pushbarDwn release];
	[super dealloc];
}

@end

@implementation AccordionView
- (id)initWithFrame:(struct CGRect)frame
{
	if ((self == [super initWithFrame: frame]) != nil)
	{

	}
	_frame = frame;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float _fc[4] = {0.3f, 0.3f, 0.3f, 1.0f};
	CGColorRef fg = CGColorCreate(colorSpace, _fc);
	[self setBackgroundColor:fg];

	return self;
}

- (void)setSize:(int)size
{
	_margin = 0;
	_panels = [NSMutableArray array];
	_padding = (size - 1) * 29;
}

- (AccordionPanel *)addPanel:(NSString *)title
{
	AccordionPanel *p = [[AccordionPanel alloc] initWithFrameAndTitle: CGRectMake(0, _margin, _frame.size.width, _frame.size.height - (float)_padding) title:title];
	_margin+=29;
	[_panels addObject:p];
	[self addSubview:p];
	return p;
}

- (void)fixup
{
	int i;
	for(i=1;i<([_panels count]-1);i++)
	{
			id ob = [_panels objectAtIndex:i];
			[ob setNextPanel:[_panels objectAtIndex:i+1]];
	}
	for(i=1;i<[_panels count];i++)
	{
		id ab = [_panels objectAtIndex:i];
		[ab setPrevPanel:[_panels objectAtIndex:i-1]];
	}
	[[_panels objectAtIndex:0] setFixed:YES];
}

- (void)dealloc
{
	[_panels release];
	[super dealloc];
}

@end