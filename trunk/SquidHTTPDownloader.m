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

	- (void)setDelegate(id)delegate
	{
		_delegate = delegate;
	}
	
	- (void)handleNetworkEvent:(CFStreamEventType)type
	{
		switch (type)
		{
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

	- (CFIndex)getTotalSize
	{
		return _total;
	}

	- (CFIndex)getProgress
	{
		return _progress;
	}
	
	- (void)handleBytesAvailable
	{
		UInt8 buffer[2048];
		CFIndex bytesRead = CFReadStreamRead(_stream, buffer, sizeof(buffer));
		if (bytesRead < 0)
			[self handleStreamError];
		else if (bytesRead)
		{
			_progress += bytesRead;

			CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
			if(CFHTTPMessageIsHeaderComplete(response))
			{
				NSString *contentLength = [(NSString *) CFHTTPMessageCopyHeaderFieldValue(response, CFSTR("Content-Length")) autorelease];
				_total = [contentLength intValue];
			}

			if( [_delegate respondsToSelector:@selector( httpDownloader:dataReceived:size: )] )
                                [_delegate httpDownloader:self dataReceived:buffer size:bytesRead];
		}
	}
	
	- (void)handleStreamComplete
	{
		CFHTTPMessageRef response = (CFHTTPMessageRef)CFReadStreamCopyProperty(_stream, kCFStreamPropertyHTTPResponseHeader);
		CFReadStreamSetClient(_stream, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFRelease(response);
		if( [_delegate respondsToSelector:@selector( httpDownloader:complete: )])
			[_delegate httpDownloader:self complete];
	}
	
	- (void)handleStreamError
	{
		CFStreamError error = CFReadStreamGetError(_stream);
		CFReadStreamSetClient(_stream, 0, NULL, NULL);
		CFReadStreamUnscheduleFromRunLoop(_stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		CFReadStreamClose(_stream);
		CFRelease(_stream);
		_stream = NULL;
                if( [_delegate respondsToSelector:@selector( httpDownloader:error: )])
                        [_delegate httpDownloader:self error];
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
		
		if (!stream)
		{
			return;
		}
		
		CFReadStreamSetProperty(stream, kCFStreamPropertyHTTPAttemptPersistentConnection, kCFBooleanTrue);
		
		if (!CFReadStreamSetClient(stream, kNetworkEvents, ReadStreamClientCallBack, &ctxt))
		{
			CFRelease(stream);
			return;
		}
		
		if( [_delegate respondsToSelector:@selector( httpDownloader:started: )])
                        [_delegate httpDownloader:self started];

		CFReadStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
		
		if (!CFReadStreamOpen(stream))
		{
			CFReadStreamSetClient(stream, 0, NULL, NULL);
			CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
			CFRelease(stream);
			return;
		}
		
		if (_stream)
		{
			CFReadStreamClose(_stream);
			CFRelease(_stream);
		}
		_stream = stream;
		
	}
	
	-(id)initWithUrl:(NSString *)url
	{

		_progress = 0;
		_total = 0;
		
		CFHTTPMessageRef request;

		if (!url || ![url length])
		{
			return;
		}

		if (![url hasPrefix: @"http://"] && ![url hasPrefix: @"https://"])
			url = [NSString stringWithFormat: @"http://%@", url];

		if (_url)
		{
			[_url release];
			_url = NULL;
		}

		_url = [NSURL URLWithString: url];

		if (!_url)
		{
			return;
		}

		[_url retain];

		request = CFHTTPMessageCreateRequest(kCFAllocatorDefault, CFSTR("GET"), (CFURLRef)_url, kCFHTTPVersion1_1);

		if (!request)
		{
			return;
		}

		[self fetch: request];
		CFRelease(request);
		return self;
	}
@end
