#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextView.h>
@interface SquidAttrViewer : UIView 
{
	id _delegate;
	UITextView *_view;
}
- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
@end

