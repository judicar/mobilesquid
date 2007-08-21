#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITransformAnimation.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIImage.h>

@interface AccordionPanel : UIView
{
	UIPushButton *_pushbar;
	UIImage *_pushbarUp;
	UIImage *_pushbarDwn;
	UITransformAnimation *_translationUp;
	UITransformAnimation *_translationDwn;
	AccordionPanel *_next;
	AccordionPanel *_prev;
	BOOL _fixed;
	BOOL _Up;
}
- (void)hide;
- (void)show;
- (void)toggle;
- (void)setFixed:(BOOL)fixed;
- (void)pushbarClicked:(UIPushButton *)button;
- (void)setNextPanel:(AccordionPanel *)panel;
- (void)setPrevPanel:(AccordionPanel *)panel;
- (id)initWithFrameAndTitle:(struct CGRect)frame title:(NSString *)title;
@end

@interface AccordionView : UIView
{
	NSMutableArray *_panels;
	int _padding;
	int _margin;
	CGRect _frame;
}
- (void)setSize:(int)size;
- (AccordionPanel *)addPanel:(NSString *)title;
- (void)fixup;
@end
