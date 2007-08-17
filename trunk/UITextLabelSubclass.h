#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

@interface UITextLabelSubclass : UITextLabel
{
	float _fontSize;
	NSString *_fontName;
	float _c[4];
	int _cW, _cH;
	CGContextRef context = UICurrentContext();
	float _w;
	float _h;
	CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, h/30);
}

- (void)setFont:(NSString *)font;
- (void)setFontSize:(float)size;
- (id)initWithFrame: (struct CGRect) rect;
// - (void)drawRect:(CGRect)rect;
- (void)drawContentsInRect:(CGRect)rect;

@end
