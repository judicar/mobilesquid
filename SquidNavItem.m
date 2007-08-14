#import "SquidNavItem.h"

@implementation SquidNavItem
- (SquidNavItem *)initWithTitle:(id)title view:(id)view
{
  [super initWithTitle:title];
  _view = [view retain];
  _delegate = nil;
  return self;
}

- (void)setDelegate:(id)delegate;
{
  _delegate = [delegate retain];
}

- (void) willBecomeTopInNavigationBar:(id)theBar navigationBarState:(int)state
{
/*
  if ([_delegate respondsToSelector:@selector(transitionToView:)])
    {
      [_delegate transitionToView:_view];
    }
*/
	if( [_delegate respondsToSelector:@selector( navigationItemClicked:view: )] )
	{
		[_delegate navigationItemClicked:self view:_view];
	}
	[super willBecomeTopInNavigationBar:theBar navigationBarState:state];
}

- (void)dealloc
{
  [_view release];
  [_delegate release];
  [super dealloc];
}

@end
