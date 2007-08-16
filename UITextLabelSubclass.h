#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>

@interface UITextLabelSubclass : UITextLabel
{

}

- (id)initWithFrame: (struct CGRect) aRect;
- (void)drawRect:(CGRect)rect;
- (void)drawContentsInRect:(CGRect)rect;

@end
