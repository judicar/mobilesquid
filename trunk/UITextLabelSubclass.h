#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

@interface UITextLabelSubclass : UITextLabel
{
	float _fntSize;
	NSString *_fntName;
	CGColorRef _fgColor;
	CGColorRef _bgColor;
	CGAffineTransform transform;
	int _cW, _cH;
	id _delegate;
	float _fr,_fg,_fb,_fa;
	float _br,_bg,_bb,_ba;
}
- (void)setFGColor:(float)r g:(float)g b:(float)b a:(float)a;
- (void)setBGColor:(float)r g:(float)g b:(float)b a:(float)a;
- (void)setFontName:(NSString *)font;
- (void)setFontSize:(float)size;
- (id)initWithFrame:(struct CGRect)rect;
- (id)initWithFrameAndDelegate:(struct CGRect)rect label:(id)label;
- (void)drawRect:(CGRect)rect;
- (void)drawContentsInRect:(CGRect)rect;

@end
