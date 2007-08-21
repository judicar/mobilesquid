#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>
#import <UIKit/UIKit.h>
#import <UIKit/UITextLabel.h>
#import <UIKit/UIBox.h>
#import <UIKit/UIView.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UICheckBox.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIKeyboard.h>
#import "UITextLabelSubclass.h"
#import <UIKit/UITransformAnimation.h>
#import <UIKit/UIAnimator.h>
#import <UIKit/UIKeyboardImpl.h>
#import "AccordionView.h"


typedef struct __GSEvent {
	long i0; 
	long i1;
	long eventType;
	long i3;
	long i4;
	long i5;
} __GSEvent;

@interface EditField : UITextView {
	BOOL _dirty;
}
- (void)setDirty:(BOOL)dirty;
- (id)hitTest:(struct CGPoint)fp8 forEvent:(struct __GSEvent *)fp16;
- (id)initWithFrame:(struct CGRect)fp8;
- (BOOL)canBecomeFirstResponder;
- (BOOL)respondsToSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
- (BOOL)webView:(id)fp8 shouldDeleteDOMRange:(id)fp12;
- (BOOL)webView:(id)fp8 shouldInsertText:(id)character replacingDOMRange:(id)fp16 givenAction:(int)fp20;
@end

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


@interface EditingKeyboard : UIKeyboard
{
	UITransformAnimation *_translationUp;
	UITransformAnimation *_translationDwn;
}
- (id)initWithFrame:(struct CGRect)fp8;
- (void)show;
- (void)hide;
@end


@interface SquidAttrViewer : UIView 
{
	id _delegate;
	UITextLabelSubclass *_mdatelabel;
	UITextLabelSubclass *_sizelabel;
	EditField *_fnlabel;
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
	EditingKeyboard *_keyboard;
	NSFileHandle *_handle;
	AccordionView *_accordion;
}
- (BOOL)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorDict;
- (void)fileManager:(NSFileManager *)fm willProcessPath:(NSString *)path;
- (BOOL)handleKeyboardInput:(id)character;
- (void)showKeyboard:(id)view;
- (void)hideKeyboard:(id)view;
- (UIKeyboard *)getKeyboard:(id)view;
- (void)applyButton:(UIPushButton *)button;
- (void)processChanges:(NSDictionary *)dict;
- (id)initWithFrame:(CGRect)rect;
- (void)processLabels:(UITextLabelSubclass *)label;
- (void)setDelegate:(id)delegate;
- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict;
- (void)processChanges:(NSDictionary *)dict;
@end

