#import "Squid.h"

@implementation SquidHTTPDownloader

	static void ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo)
	{
		[((SquidHTTPDownloader*)clientCallBackInfo) handleNetworkEvent: type];
	}
	
	static const CFOptionFlags kNetworkEvents = kCFStreamEventOpenCompleted |
	kCFStreamEventHasBytesAvailable |
	kCFStreamEventEndEncountered |
	kCFStreamEventErrorOccurred;
	
	- (void)handleNetworkEvent:(CFStreamEventType)type {
		switch (type) {
			case kCFStreamEventHasBytesAvailable:
				[self handleBytesAvailable];
				break;
			case kCFStreamEventEndEncountered:
				[self handleStreamComplete];
				break;
			case kCFStreamEventErrorOccurred:
				[self handleStreamError];
				break;
			default:
				break;
		}
	}
	
	- (void)handleBytesAvailable {
		UInt8 buffer[2048];
		CFIndex bytesRead = CFReadStreamRead(_stream, buffer, sizeof(buffer));
		if (bytesRead < 0)
			[self handleStreamError];
		else if (bytesRead) {
			_progress += bytesRead;
			CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
			if(CFHTTPMessageIsHeaderComplete(response))
			{
				NSString *contentLength = [(NSString *) CFHTTPMessageCopyHeaderFieldValue(response, CFSTR("Content-Length")) autorelease];
				_total = [contentLength intValue];
			}
			
			[progressBar setProgress:(((float)_progress)/(float)_total)];
		}
	}
	
	- (void)handleStreamComplete {
		CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
		CFReadStreamSetClient(_stream, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFRelease(response);
		[sheet dismiss];
	}
	
	- (void)handleStreamError {
		CFStreamError error = CFReadStreamGetError(_stream);
		CFReadStreamSetClient(_stream, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFReadStreamClose(_stream);
		CFRelease(_stream);
		_stream = NULL;
	}
	
	- (void)fetch:(CFHTTPMessageRef)request
	{
		CFHTTPMessageRef old;
		CFReadStreamRef stream;
		CFStreamClientContext ctxt = {0, self, NULL, NULL, NULL};
		old = _request;
		_request = (CFHTTPMessageRef)CFRetain(request);
		if (old)
			CFRelease(old);
		stream = CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, _request);
		if (!stream) {
			return;
		}
		
		CFReadStreamSetProperty(stream, kCFStreamPropertyHTTPAttemptPersistentConnection, kCFBooleanTrue);
		if (!CFReadStreamSetClient(stream, kNetworkEvents, ReadStreamClientCallBack, &ctxt)) {
			CFRelease(stream);
			return;
		}
		
		CFReadStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		if (!CFReadStreamOpen(stream)) {
			CFReadStreamSetClient(stream, 0, NULL, NULL);
			CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
			CFRelease(stream);
			return;
		}
		if (_stream) {
			CFReadStreamClose(_stream);
			CFRelease(_stream);
		}
		_stream = stream;
		
	}
	
	- (void)alertSheet:(UIAlertSheet *)aSheet buttonClicked:(int)button
	{
		[aSheet dismiss];
	}
	
	-(id)initWithUrl:(NSString *)url
	{
		NSArray* buttons = [NSArray arrayWithObjects:@"Dismiss",nil];
		sheet =	[[UIAlertSheet alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 200.0f)];
		[sheet setDelegate:self];
		[sheet popupAlertAnimated:YES];
						
		progressBar = [[UIProgressBar alloc] initWithFrame:CGRectMake(10.0f, 20.0f, 260.0f, 20.0f)];
		[progressBar setProgress:0.0f];
		[progressBar setStyle:0];
		[sheet addSubview:progressBar];
		[sheet setBodyText:@"text"];
		[sheet popupAlertAnimated:YES];
		
		CFHTTPMessageRef request;

		if (!url || ![url length]) {
			return;
		}
		if (![url hasPrefix: @"http://"] && ![url hasPrefix: @"https://"])
			url = [NSString stringWithFormat: @"http://%@", url];
		if (_url) {
			[_url release];
			_url = NULL;
		}
		_url = [NSURL URLWithString: url];
		if (!_url) {
			return;
		}
		[_url retain];
		request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef)_url, kCFHTTPVersion1_1);
		if (!request) {
			return;
		}
		[self fetch: request];
		CFRelease(request);
		return self;
	}
@end

@implementation SquidFileManager 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		UITableColumn *col = [[UITableColumn alloc]
			initWithTitle: @"FileName"
			identifier:@"filename"
			width: frame.size.width
		];

		_table = [[UITable alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[_table addTableColumn: col];
		[_table setSeparatorStyle: 1];
		[_table setDelegate: self];
		[_table setDataSource: self];

		NSBundle *bundle = [NSBundle mainBundle];
		NSString *fldrpath = [bundle pathForResource:@"fldr" ofType:@"png"];
		fldr = [[UIImage alloc]initWithContentsOfFile:fldrpath];
		NSString *flepath = [bundle pathForResource:@"fle" ofType:@"png"];
		fle = [[UIImage alloc]initWithContentsOfFile:flepath];
		_finder = [NSFileManager defaultManager];
		[_finder changeCurrentDirectoryPath:@"/"];

		_delegate = nil;

		[self addSubview: _table];
		[_table reloadData];
	}
	return self;
}

- (void)dealloc {
	[_table release];
	_delegate = nil;
	[super dealloc];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (int)numberOfRowsInTable:(UITable *)table {
	return [[_finder directoryContentsAtPath:[_finder currentDirectoryPath]] count] + 1;
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col {

	UIImageAndTextTableCell *c = [[UIImageAndTextTableCell alloc] init];

	if ( row == 0 )
	{
		[c setTitle:[NSString stringWithFormat:@"%@\n", @" .."]];
	}
	else {
		NSArray *cwd = [_finder directoryContentsAtPath:[_finder currentDirectoryPath]];
		NSDictionary *fa = [_finder fileAttributesAtPath:[NSString stringWithFormat:@"%@/%@", [_finder currentDirectoryPath], [cwd objectAtIndex:row-1]] traverseLink:YES];
		UITextLabel *lbl;
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			[c setImage:fldr];
			lbl = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f, 10.0f, 0.0f, 0.0f)];
			[lbl setText:[NSString stringWithFormat:@"%@\n", [cwd objectAtIndex:row-1]]];
			[c addSubview:lbl];
			[lbl sizeToFit];
		}
		else {
			[c setImage:fle];
			lbl = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 0.0f, 0.0f)];
			[lbl setText:[NSString stringWithFormat:@"%@\n", [cwd objectAtIndex:row-1]]];
			
			UITextLabel *sz = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f,20.0f,0.0f,0.0f)];
			[sz setText:[NSString stringWithFormat:@"%@ bytes", [fa objectForKey:NSFileSize]]];
			
			[c addSubview:lbl];
			[c addSubview:sz];
			[sz sizeToFit];
			[lbl sizeToFit];
		}
	}
	return c;
}

- (void)tableRowSelected:(NSNotification *)notification {

	int row = [_table selectedRow];

	NSArray *cwd = [_finder directoryContentsAtPath:[_finder currentDirectoryPath]];

	if ( row == 0 )
	{
		NSMutableArray *pc = [[_finder currentDirectoryPath] pathComponents];
		if ( [pc count] > 0 )
		{
			[pc removeLastObject];
			[_finder changeCurrentDirectoryPath:[pc componentsJoinedByString:@"/"]];
			[_table reloadData];
		}
	}
	else {
		NSString *path = [NSString stringWithFormat:@"%@/%@", [_finder currentDirectoryPath], [cwd objectAtIndex:row-1]];
		NSDictionary *fa = [_finder fileAttributesAtPath:path traverseLink:YES];
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			[_finder changeCurrentDirectoryPath:path];
			[_table reloadData];
		}
		else {
			if( [_delegate respondsToSelector:@selector( fileManager:fileSelected: )] )
				[_delegate fileManager:self fileSelected:path];
		}
	}
}
@end

@implementation Squid

- (void)transitionToView:(id)view
{
  [tranView transition:2 toView:view];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
    if (button == 0)
    {
		[nav popNavigationItem];
		[nav hideButtons];
		[tranView transition:2 toView:sfm];
    }
    else if (button == 1)
    {
		SquidHTTPDownloader *d = [[SquidHTTPDownloader alloc] initWithUrl:@"www.cnn.com"];
    }
}

- (void) applicationDidFinishLaunching: (id) unused
{
	sfm =  [SquidFileManager alloc];
	rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	window = [[UIWindow alloc] initWithContentRect: rect];
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];

	nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 48.0f)];
	[nav setPrompt: @"Squid"];
	[nav setBarStyle: 0];
	[nav setDelegate: self];
	[nav enableAnimation];
	[nav showButtonsWithLeftTitle:@"Download" rightTitle:@"Quit" leftBack: NO];
	
	[sfm initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height - 74.0f)];
	[sfm setDelegate:self];
	
	tranView = [[UITransitionView alloc] initWithFrame: CGRectMake(rect.origin.x, 74.0f, rect.size.width, rect.size.height - 74.0f)];
	
	mainView = [[UIView alloc] initWithFrame: rect];
	[mainView addSubview: nav];
	[mainView addSubview: tranView];
	[window setContentView: mainView];
	
	[tranView transition:1 toView:sfm];
}

- (void)fileManager: (SquidFileManager *)manager fileSelected:(NSString *)file
{
	NSArray* buttons = [NSArray arrayWithObjects:@"Button1",@"Button2",nil];
	UIAlertSheet* sheet = [[UIAlertSheet alloc] 
							  initWithTitle:file 
	                          buttons: buttons
	 						defaultButtonIndex: 1 
							delegate:self
							 context:nil];
						[sheet popupAlertAnimated:FALSE];
}
@end
