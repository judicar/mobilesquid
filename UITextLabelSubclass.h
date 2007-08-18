#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

@interface UITextLabelSubclass : UITextLabel
{
	float _fntSize;
	const char *_fntName;
	CGColorRef _fgColor;
	CGColorRef _bgColor;
	CGAffineTransform transform;
	int _cW, _cH;
}
- (void)setFontName:(NSString *)font;
- (void)setFontSize:(float)size;
- (id)initWithFrame: (struct CGRect) rect;
// - (void)drawRect:(CGRect)rect;
- (void)drawContentsInRect:(CGRect)rect;

@end
