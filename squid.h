#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIProgressBar.h>
#import <UIKit/UIShadowView.h>

@interface Squid : UIApplication {
    NSMutableString *_log;
    UITextView *textView;
	UIProgressBar *progressBar;
	UIAlertSheet* sheet;
	UIView *mainView;
	
	NSURL* _url;
    CFReadStreamRef		_stream;
    CFHTTPMessageRef	_request;
	CFIndex	_progress;
	CFIndex _total;
	UITable *table;
	UIImage *fle;
	UIImage *fldr;
	NSFileManager *finder;
}
- (void)tableRowSelected:(UITable *)atable;
//- (void)tableSelectionDidChange:(UITable *)atable;
- (int) numberOfRowsInTable: (UITable *)table;
- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col;
- (UITableCell *) table: (UITable *)table cellForRow: (int)row column: (int)col;
- (void)alertSheet:(UIAlertSheet*)alert buttonClicked:(int)button;
- (void)navigationBar:(UINavigationBar*)bar buttonClicked:(int)button;
- (void)fetch:(CFHTTPMessageRef)request;
- (void)handleNetworkEvent:(CFStreamEventType)type;
- (void)handleBytesAvailable;
- (void)handleStreamComplete;
- (void)handleStreamError;
@end
