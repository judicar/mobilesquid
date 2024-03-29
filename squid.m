#import "Squid.h"

@implementation Squid


- (void) applicationDidFinishLaunching: (id) unused
{
	sfm =  [SquidFileManager alloc];
	sfmb = [SquidFileManager alloc];
	sav = [SquidAttrViewer alloc];
	
	rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	window = [[UIWindow alloc] initWithContentRect: rect];
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];

	nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 74.0f)];
	[nav setDelegate: self];
	[nav enableAnimation];
	[nav hideButtons];
	
	[sfm initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height - 74.0f)];
	[sfm setDelegate:self];
	
	[sfmb initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height - 74.0f)];
	[sfmb setDelegate:self];

	[sav initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height - 74.0f)];
	[sav setDelegate:self];
	
	lnk = [[SquidNavItem alloc] initWithTitle:@"Files" view:sfm];
	[lnk setDelegate:self];

	lnkb = [[SquidNavItem alloc] initWithTitle:@"Files" view:sfmb];
	[lnkb setDelegate:self];
	
	attrs = [[SquidNavItem alloc] initWithTitle:@"Attributes" view:sav];
	[attrs setDelegate:self];

	tranView = [[UITransitionView alloc] initWithFrame: CGRectMake(rect.origin.x, 74.0f, rect.size.width, rect.size.height - 74.0f)];
	
	mainView = [[UIView alloc] initWithFrame: rect];
	[mainView addSubview: nav];
	[mainView addSubview: tranView];
	[window setContentView: mainView];
	
	[nav pushNavigationItem:lnk];
	_current = sfm;
	[tranView transition:1 toView:sfm];
}

- (void)alertSheet:(UIAlertSheet *)sheet buttonClicked:(int)button
{
	[sheet dismiss];
}

- (void)fileManager: (SquidFileManager *)manager doBackTrack:(NSString *)path
{	
	_current = [manager isEqual:sfm] ? sfmb : sfm;
	[_current changePath:path];
	[tranView transition:2 toView:_current];
}

- (void)fileManager: (SquidFileManager *)manager folderSelected:(NSString *)folder attrs:(NSDictionary *)dict
{	
	_current = [manager isEqual:sfm] ? sfmb : sfm;
	[_current changePath:folder];
	[tranView transition:1 toView:_current];

}


- (void)navigationItemClicked:(id)item view:(id)view;
{

		if ( [_current isEqual:sav])
		{	
			[sfm changePath:[[NSFileManager defaultManager] currentDirectoryPath]];
			[tranView transition:2 toView: sfm];
		}	
		_current = view;

		//SquidHTTPDownloader *d = [[SquidHTTPDownloader alloc] initWithUrl:@"www.cnn.com"];
}

- (void)fileManager: (SquidFileManager *)manager fileSelected:(NSString *)file attrs:(NSDictionary *)dict
{
	[nav pushNavigationItem:attrs];
	[nav showBackButton:YES animated:YES];
	[sav setFile:file attrs:dict];
	[tranView transition:1 fromView:manager toView:sav];
	[sav becomeFirstResponder];
}
@end