#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIProgressBar.h>

@interface SquidHTTPDownloader : NSObject {
	UIProgressBar *progressBar;
	UIAlertSheet *sheet;
	NSURL* _url;
	CFReadStreamRef	_stream;
    	CFHTTPMessageRef _request;
	CFIndex	_progress;
	CFIndex _total;
	id _delegate;
}
- (CFIndex)getTotalSize;
- (CFIndex)getProgress;
- (void)setDelegate(id)delegate;
- (void)alertSheet:(UIAlertSheet *)aSheet buttonClicked:(int)button;
- (void)fetch:(CFHTTPMessageRef)request;
- (void)handleNetworkEvent:(CFStreamEventType)type;
- (void)handleBytesAvailable;
- (void)handleStreamComplete;
- (void)handleStreamError;
@end
