#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

@interface MyTextLabel : UITextLabel
{

}
- (id)initWithFrame: (struct CGRect) aRect;
- (void)drawRect:(CGRect)rect;
- (void)drawContentsInRect:(CGRect)rect;
@end

@interface SquidAttrViewer : UIView 
{
	id _delegate;
	UITextLabel *_date;
	MyTextLabel *_test;
}
- (id)initWithFrame:(CGRect)rect;
- (void)setDelegate:(id)delegate;
- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict;
@end

