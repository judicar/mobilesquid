#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UIBox.h>
#import <UIKit/UIView.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UICheckBox.h>

#import "UITextLabelSubclass.h"

typedef struct __GSEvent {
	long i0; 
	long i1;
	long eventType;
	long i3;
	long i4;
	long i5;
} __GSEvent;

@interface SquidPermCol: UIView
{
	id _delegate;
	UITextLabelSubclass *_title;
	UICheckbox *cbr;
	UICheckbox *cbw;
	UICheckbox *cbe;
	float _paddingLeft;
	float _paddingTop;
}
- (void)setPermissions:(int)p;
- (int)getPermissions;
- (void)setTitle:(NSString *)title;
- (id)initWithFrameAndDelegate:(struct CGRect)frame delegate:(id)delegate;

@end

@interface SquidPermEditor : UIView
{
	id _delegate;
	UITextLabelSubclass *_title;
	SquidPermCol *_owner;
	SquidPermCol *_group;
	SquidPermCol *_other;
	float _width, _paddingLeft;
}
- (void)displayPermissions;
- (void)setPermissions:(int)p;
- (int)getPermissions;
- (id)initWithFrameAndDelegate:(struct CGRect)frame delegate:(id)delegate;
- (void)applyChanges;
@end

@interface SquidAttrViewer : UIView 
{
	id _delegate;
	UITextLabelSubclass *_mdatelabel;
	UITextLabelSubclass *_sizelabel;
	UITextLabelSubclass *_fnlabel;
	UITextLabelSubclass *_pathlabel;
	UITextLabelSubclass *_grouplabel;
	UITextLabelSubclass *_ownerlabel;
	UITextLabelSubclass *_cdatelabel;
	UIImage* _applyUp;
	UIImage* _applyDwn;
	UIPushButton* _apply;
	UIView *_view;
	NSDictionary *_dict;
	NSString *_path;
	SquidPermEditor *_perms;
}
- (void)applyButton:(UIPushButton *)button;
- (void)processChanges:(NSDictionary *)dict;
- (id)initWithFrame:(CGRect)rect;
- (void)processLabels:(UITextLabelSubclass *)label;
- (void)setDelegate:(id)delegate;
- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict;
- (void)processChanges:(NSDictionary *)dict;
@end

