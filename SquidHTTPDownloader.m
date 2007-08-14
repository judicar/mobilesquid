#import "SquidHTTPDownloader.h"

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
