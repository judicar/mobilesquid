#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UIKeyboard.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UISegmentedControl.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIView.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIView-Rendering.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIBox.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITextLabel.h>
#import "Squid.h"

@implementation Squid

static void
ReadStreamClientCallBack(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo) {

    [((Squid*)clientCallBackInfo) handleNetworkEvent: type];
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
				[self logger:[NSString stringWithFormat:@"%@ Content-Length", contentLength]];
				_total = [contentLength intValue];
			}

		[progressBar setProgress:(((float)_progress)/(float)_total)];
    }
}

- (void)handleStreamComplete {
    CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
	CFReadStreamSetClient(_stream, 0, NULL, NULL);
	CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
	[sheet dismiss];
	CFRelease(response);
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

- (void)alertSheet:(UIAlertSheet*)alert buttonClicked:(int)button
{
	[sheet dismiss];
}

- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button
{
    if (button == 0)
    {

    }
    else if (button == 1)
    {
	
	/*
		NSArray* buttons = [NSArray arrayWithObjects:@"Dismiss", nil];
		sheet = [[UIAlertSheet alloc] init];
		[sheet setDelegate:self];
													
		progressBar = [[UIProgressBar alloc] initWithFrame: CGRectMake(10.0f, 10.0f, 263.0f, 20.0f)];
		[progressBar setStyle:0];
		
		[sheet addSubview:progressBar];
		[sheet popupAlertAnimated:TRUE];

		UIView *contentView = [[UIView alloc] initWithFrame:  CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
		
		UIBox *box = [[UIBox alloc] initWithFrame: CGRectMake(0.0f, 74.0f, 320.0f, 60.0f)];
		
		CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
		float bc[4] = {110.0f/255.0f, 123.0f/255.0f, 139.0f/255.0f, 1};
		[box setBackgroundColor: CGColorCreate(cs, bc)];
		
		UIProgressBar *pbar = [[UIProgressBar alloc] initWithFrame: CGRectMake(0.0f, 10.0f, 316.0f, 20.0f)];
		[pbar setStyle:0];
		[pbar setProgress:0.5f];
		
		[contentView addSubview:pbar];	
		[box setContentView:contentView];
		[mainView addSubview:box];
		
	*/

		/*
		CFHTTPMessageRef request;
		NSString* url_string = @"http://www.cnn.com";
		if (!url_string || ![url_string length]) {
			[self logger:@"empty url"];
			return;
		}
		if (![url_string hasPrefix: @"http://"] && ![url_string hasPrefix: @"https://"])
			url_string = [NSString stringWithFormat: @"http://%@", url_string];
		if (_url) {
			[_url release];
			_url = NULL;
		}
		_url = [NSURL URLWithString: url_string];
		if (!_url) {
			[self logger:@"error in nsurl"];
			return;
		}
		[_url retain];
		request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef)_url, kCFHTTPVersion1_1);
		if (!request) {
			[self logger:@"request not created"];
			return;
		}
		[self logger:@"request created"];
		[self resetProgressbar];
		[self fetch: request];
		CFRelease(request);
		*/
    }

}

- (int) numberOfRowsInTable: (UITable *)table
{
	return [[finder directoryContentsAtPath:[finder currentDirectoryPath]] count] + 1;
}

- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col
{
	UIImageAndTextTableCell *c = [[UIImageAndTextTableCell alloc] init];
	if ( row == 0 )
	{
		[c setTitle:[NSString stringWithFormat:@"%@\n", @" .."]];
	}
	else {
		NSArray *cwd = [finder directoryContentsAtPath:[finder currentDirectoryPath]];
		NSDictionary *fa = [finder fileAttributesAtPath:[NSString stringWithFormat:@"%@/%@", [finder currentDirectoryPath], [cwd objectAtIndex:row-1]] traverseLink:YES];
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			[c setImage:fldr];
		}
		else {
			[c setImage:fle];
		}
		[c setTitle:[NSString stringWithFormat:@"%@\n", [cwd objectAtIndex:row-1]]];
	}
	return c; 
}


//- (void)tableSelectionDidChange:(UITable *)atable;
- (void)tableRowSelected:(UITable *)atable
{
	int row = [table selectedRow];
	NSArray *cwd = [finder directoryContentsAtPath:[finder currentDirectoryPath]];
	if ( row == 0 )
	{
		NSMutableArray *pc = [[finder currentDirectoryPath] pathComponents];
		if ( [pc count] > 0 )
		{
			[pc removeLastObject];
			[finder changeCurrentDirectoryPath:[pc componentsJoinedByString:@"/"]];
			[table reloadData];
		}
	}
	else {
		NSString *path = [NSString stringWithFormat:@"%@/%@", [finder currentDirectoryPath], [cwd objectAtIndex:row-1]];
		NSDictionary *fa = [finder fileAttributesAtPath:path traverseLink:YES];
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			[finder changeCurrentDirectoryPath:path];
			[table reloadData];
		}
	}
}

- (void) applicationDidFinishLaunching: (id) unused
{
	UIWindow *window;
	window = [[UIWindow alloc] initWithContentRect: [UIHardware fullScreenApplicationContentRect]];
	
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];

	UINavigationBar *nav = [[UINavigationBar alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 48.0f)];
	[nav setPrompt: @"Squid"];
	[nav setBarStyle: 0];
	[nav setDelegate: self];
	[nav enableAnimation];

	table = [[UITable alloc] initWithFrame: CGRectMake(0.0f, 48.0f, 320.0f, 480.0f - 48.0f)];
	UITableColumn *col = [[UITableColumn alloc] initWithTitle: @"Textedit" identifier: @"hello" width: 320.0f];
	[table setScrollingEnabled:YES];
	[table addTableColumn: col]; 
	[table setDataSource: self];
	[table setDelegate: self];
  
	struct CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	mainView = [[UIView alloc] initWithFrame: rect];
	[mainView addSubview: nav]; 
	[mainView addSubview: table];

	[window setContentView: mainView];
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *fldrpath = [bundle pathForResource:@"fldr" ofType:@"png"];
	fldr = [[UIImage alloc]initWithContentsOfFile:fldrpath];
	NSString *flepath = [bundle pathForResource:@"fle" ofType:@"png"];
	fle = [[UIImage alloc]initWithContentsOfFile:flepath];
	finder = [NSFileManager defaultManager];
	[finder changeCurrentDirectoryPath:@"/"];
	[table reloadData];
}

@end
