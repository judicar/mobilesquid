#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIProgressBar.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UITransitionView.h>
//#import <UIKit/UINavigationItem.h>




@interface SquidFileManager : UIView 
{
	UITable *_table;
	id _delegate;
	UIImage *fle;
	UIImage *fldr;
	NSFileManager *_finder;
}
- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (int)numberOfRowsInTable:(UITable *)table;
- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col;
- (void)tableRowSelected:(NSNotification *)notification;
@end

@interface Squid : UIApplication {
	struct CGRect rect;
	UIView *mainView;
	UIWindow *window;
	UINavigationBar *nav;
	UITransitionView *tranView;
	SquidFileManager *sfm;
}
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button;
- (void)fileManager: (SquidFileManager *)manager fileSelected:(NSString *)file;
@end

@interface SquidHTTPDownloader : NSObject {
	UIProgressBar *progressBar;
	UIAlertSheet *sheet;
	NSURL* _url;
    CFReadStreamRef		_stream;
    CFHTTPMessageRef	_request;
	CFIndex	_progress;
	CFIndex _total;
}
- (void)alertSheet:(UIAlertSheet *)aSheet buttonClicked:(int)button;
- (void)fetch:(CFHTTPMessageRef)request;
- (void)handleNetworkEvent:(CFStreamEventType)type;
- (void)handleBytesAvailable;
- (void)handleStreamComplete;
- (void)handleStreamError;
@end
