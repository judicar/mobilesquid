#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>

@interface SquidFileManager : UIView 
{
	UITable *_table;
	id _delegate;
	UIImage *_fileIcon;
	UIImage *_folderIcon;
	NSFileManager *_finder;
}
- (void)backTrack;
- (void)changePath:(NSString *)path;
- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (int)numberOfRowsInTable:(UITable *)table;
- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col;
- (void)tableRowSelected:(NSNotification *)notification;
@end
