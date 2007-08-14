#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UINavigationItem.h>

@interface SquidNavItem : UINavigationItem
{
  UIView *_view;
  id _delegate;
}

- (SquidNavItem *)initWithTitle:(id)title view:(id)view;
- (void)setDelegate:(id)delegate;
@end

