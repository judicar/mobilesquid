#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

#import "UITextLabelSubclass.h"

@interface SquidAttrViewer : UIView 
{
	id _delegate;
	UITextLabelSubclass *_date;
}
- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict;
@end

