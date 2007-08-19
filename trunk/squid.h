#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIProgressBar.h>
#import <UIKit/UITransitionView.h>

#import "SquidFileManager.h"
#import "SquidHTTPDownloader.h"
#import "SquidAttrViewer.h"
#import "SquidNavItem.h"

@interface Squid : UIApplication {
	struct CGRect rect;
	UIView *mainView;
	UIWindow *window;
	UINavigationBar *nav;
	UITransitionView *tranView;
	SquidFileManager *sfm;
	SquidFileManager *sfmb;
//	SquidFileManager *_current;
	id _current;
	
	SquidAttrViewer *sav;
	SquidNavItem *lnk;
	SquidNavItem *lnkb;
	SquidNavItem *attrs;
}
- (void)fileManager: (SquidFileManager *)manager doBackTrack:(NSString *)path;
- (void)navigationItemClicked:(id)item view:(id)view;
- (void)fileManager: (SquidFileManager *)manager fileSelected:(NSString *)file  attrs:(NSDictionary *)dict;
- (void)fileManager: (SquidFileManager *)manager folderSelected:(NSString *)folder  attrs:(NSDictionary *)dict;
@end
