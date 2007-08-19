#import "SquidAttrViewer.h"

@implementation SquidPermCol 
- (id)initWithFrameAndDelegate:(struct CGRect)frame delegate:(id)delegate
{
		if ((self == [super initWithFrame: frame]) != nil)
		{
			_delegate = nil;
		}
		
		_delegate = delegate;
		
		_paddingLeft = 8.0f;
		_paddingTop = 0.0f;
		
		float ht = ( frame.size.height / 4.0f );
		_title = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0, 0, frame.size.width, ht) delegate:_delegate];
		[self addSubview:_title];
		
		cbr = [[UICheckbox alloc] initWithTitle:@"Read"];
		cbw = [[UICheckbox alloc] initWithTitle:@"Write"];
		cbe = [[UICheckbox alloc] initWithTitle:@"Exec"];
		

		[cbr setFrame:CGRectMake(_paddingLeft, ht, frame.size.width, ht)];
		[cbw setFrame:CGRectMake(_paddingLeft, (2.0f * ht) + _paddingTop, frame.size.width, ht)];
		[cbe setFrame:CGRectMake(_paddingLeft, (3.0f * ht) + _paddingTop, frame.size.width, ht)];
		
		[self addSubview:cbr];
		[self addSubview:cbw];
		[self addSubview:cbe];
		
		return self;
}

- (int)getPermissions
{
	int p = 0;
	if([cbe isChecked])
		p+=1;
	if([cbw isChecked])
		p+=2;
	if([cbr isChecked])
		p+=4;
	return p;
}

- (void)setPermissions:(int)p
{
	[cbe setChecked:NO];
	[cbw setChecked:NO];
	[cbr setChecked:NO];
		
	if(p>=4)
	{
		p-=4;
		[cbr setChecked:YES];
	}
	if(p>=2)
	{
		p-=2;
		[cbw setChecked:YES];
	}
	if(p==1)
	{
		[cbe setChecked:YES];
	}
}

- (void)setTitle:(NSString *)title
{
	[_title setText:title];
}

- (void)dealloc
{
	[_title release];
	[cbr release];
	[cbw release];
	[cbe release];
	_delegate = nil;
	[super dealloc];
}

@end

@implementation SquidPermEditor 
- (id)initWithFrameAndDelegate:(struct CGRect)frame delegate:(id)delegate
{
		if ((self == [super initWithFrame: frame]) != nil)
		{
			_delegate = nil;
		}
		
		_delegate = delegate;
		_paddingLeft = 5.0f;
		_width = (frame.size.width / 4.0f);
		_title = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0, 0, frame.size.width, 20) delegate:_delegate];
		_owner = [[SquidPermCol alloc] initWithFrameAndDelegate:CGRectMake(0, 20, _width, 80) delegate:_delegate];
		_group = [[SquidPermCol alloc] initWithFrameAndDelegate:CGRectMake(_width + _paddingLeft, 20, _width, 80) delegate:_delegate];
		_other = [[SquidPermCol alloc] initWithFrameAndDelegate:CGRectMake((_width * 2.0f) + _paddingLeft * 2, 20, _width, 80) delegate:_delegate];
		
		[_title setText:@"Permissions:"];
		[_owner setTitle:@"Owner"];
		[_group setTitle:@"Group"];
		[_other setTitle:@"Other"];
		
		[self addSubview:_owner];
		[self addSubview:_group];
		[self addSubview:_other];
		[self addSubview:_title];
		return self;
}

- (void)setPerms:(NSNumber *)perm
{

}

- (void)dealloc
{
	[_title release];
	[_owner release];
	[_group release];
	[_other release];

	[super dealloc];
}

- (void)setPermissions:(int)p
{
		[_other setPermissions:(p % 8)];
		[_group setPermissions:((p / 8) % 8)];
		[_owner setPermissions:((p / 64) % 8)];
		
		[self displayPermissions];
}

- (int)getPermissions
{
	int p =  ([_owner getPermissions] * 64) + ([_group getPermissions] * 8) + [_other getPermissions];
	return p;
}

- (void)displayPermissions
{
		int p = [self getPermissions];
		
		int others = p % 8;
		int group = (p / 8) % 8;
		int owner = (p / 64) % 8;
		
		[_title setText:[NSString stringWithFormat:@"Permissions: %ld (%d%d%d)", p, owner, group, others]];
}

- (void)applyChanges
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSNumber numberWithInt:[self getPermissions]] forKey:NSFilePosixPermissions];
	
	if( [_delegate respondsToSelector:@selector( processChanges: )] )
		[_delegate processChanges:dict];
}
@end

@implementation SquidAttrViewer 
- (id)initWithFrame:(struct CGRect)frame
{
	if ((self == [super initWithFrame: frame]) != nil)
	{
		_delegate = nil;
	}

	_view = [[UIView alloc] initWithFrame:frame];
	
	_mdatelabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,20,290,20) delegate:self];
	_cdatelabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,40,290,20) delegate:self];
	_sizelabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,60,290,20) delegate:self];
	_fnlabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,0,290,20) delegate:self];
	_pathlabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,80,290,20) delegate:self];
	_ownerlabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,100,290,20) delegate:self];
	_grouplabel = [[UITextLabelSubclass alloc] initWithFrameAndDelegate: CGRectMake(0,120,290,20) delegate:self];
	_perms = [[SquidPermEditor alloc] initWithFrameAndDelegate:CGRectMake(0,140,200,100) delegate:self];
	
	[_view addSubview:_mdatelabel];
	[_view addSubview:_cdatelabel];
	[_view addSubview:_sizelabel];
	[_view addSubview:_fnlabel];	
	[_view addSubview:_pathlabel];
	[_view addSubview:_ownerlabel];	
	[_view addSubview:_grouplabel];
	[_view addSubview:_perms];

	_applyUp = [UIImage imageNamed:@"applyup.png"];
	_applyDwn = [UIImage imageNamed:@"applyup.png"];
	
	_apply = [[UIPushButton alloc] initWithTitle:@"" autosizesToFit:NO];
	
	[_apply setFrame: CGRectMake(0.0, 230.0, 100.0, 50.0)];
	[_apply setDrawsShadow: YES];
	[_apply setEnabled:YES];
	[_apply setStretchBackground:NO];
	[_apply setBackground:_applyUp forState:0];
	[_apply setBackground:_applyDwn forState:1];
	[_apply addTarget:self action:@selector(applyButton:) forEvents:1];

	[_view addSubview:_apply];

	[_fnlabel setFontSize:15.0f];
	[_fnlabel setFGColor:0.0f g:0.0f b:0.0f a:1.0f];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float _fc[4] = {1.0f, 1.0f, 1.0f, 1.0f};
	CGColorRef fg = CGColorCreate(colorSpace, _fc);
	[_view setBackgroundColor:fg];
	[self addSubview:_view];
	return self;
}

- (void)applyButton:(UIPushButton *)button
{
	[_perms applyChanges];
}

- (void)processChanges:(NSDictionary *)dict
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
	NSNumber *num = [[NSNumber alloc] initWithInt:[[dict objectForKey:NSFilePosixPermissions] intValue]];
	
	[d setObject:num forKey:NSFilePosixPermissions];
	[fm changeFileAttributes:d atPath:_path];
	
	[_perms setPermissions:[num unsignedLongValue]];
	[d release];
	[num release];
}

- (void)fileEditPermissions
{
	NSArray* buttons = [NSArray arrayWithObjects:@"Button1",@"Button2",nil];
	UIAlertSheet* sheet = [[UIAlertSheet alloc] 
							  initWithTitle:@"title" 
	                          buttons: buttons
	 						defaultButtonIndex: 1 
							delegate:self
							 context:nil];
						[sheet popupAlertAnimated:FALSE];
}

- (void)dealloc
{
	[_perms release];
	[_mdatelabel release];
	[_sizelabel release];
	[_fnlabel release];
	[_pathlabel release];
	[_ownerlabel release];
	[_grouplabel release];
	[_cdatelabel release];
	[_path release];
	[_apply release];
	[_applyUp release];
	[_applyDwn release];
	_delegate = nil;
	[super dealloc];
}

- (void)setDelegate:(id)delegate
{
	_delegate = delegate;
}

- (BOOL)handleEvent:(__GSEvent *)event
{
	switch(event->eventType)
	{
		case 50: //orientation change
			return YES;
		case 2002: //quit event
			return NO;	
		case 3: //click
		case 3001: //drag
			return YES;
		default:
			return YES;
	}
	
	return YES;
}

- (void)processLabels:(UITextLabelSubclass *)label
{
	[label setFontName:@"VerdanaBold"];
	[label setFontSize:10.0f];
	[label setBGColor:1.0f g:1.0f b:1.0f a:1.0f];
	[label setFGColor:0.4f g:0.4f b:0.4f a:1.0f];
}

- (void)setFile:(NSString *)path attrs:(NSDictionary *)dict
{
	[_path release];
	_path = [[NSString alloc] initWithString:path];
	_dict = dict;

	NSNumber *perms = [dict objectForKey:NSFilePosixPermissions];
	[_perms setPermissions:[perms unsignedLongValue]];
	NSNumber *size = [dict objectForKey:NSFileSize];
	NSDate *mdate = [dict objectForKey:NSFileModificationDate];
	NSDate *cdate = [dict objectForKey:NSFileCreationDate]?[dict objectForKey:NSFileCreationDate]:[dict objectForKey:NSFileModificationDate];	
	
	[_mdatelabel setText:[NSString stringWithFormat:@"Modified: %@",
		[mdate descriptionWithCalendarFormat:@"%a, %d %b %y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]]];
		
	[_cdatelabel setText:[NSString stringWithFormat:@"Created: %@",
		[cdate descriptionWithCalendarFormat:@"%a, %d %b %y, %I:%M %p" timeZone:nil locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]]]];
	
	int sz = [size intValue];
	float fsz;
	NSString *str;
	if(sz < 1048576)
	{
	// less than 1mb
		fsz = (float)sz / 1024.0f;
		str = [NSString stringWithFormat:@"%.2f KB", fsz];
	}
	else if(sz < 1073741824)
	{
	// less than 1gb
		fsz = (float)sz / 1048576.0f;
		str = [NSString stringWithFormat:@"%.2f MB", fsz];
	}
	else {
	// 1gb or more
		fsz = (float)sz / 1073741824.0f;
		str = [NSString stringWithFormat:@"%.2f GB", fsz];
	}
	
	[_sizelabel setText:[NSString stringWithFormat:@"Size: %@ (%@ bytes)", str, size]];
	[_fnlabel setText:[NSString stringWithFormat:@"%@", [path lastPathComponent]]];
	[_pathlabel setText:[NSString stringWithFormat:@"Where: %@", [path stringByDeletingLastPathComponent]]];
	[_ownerlabel setText:[NSString stringWithFormat:@"Owner: %@", [dict objectForKey:NSFileOwnerAccountName]]];
	[_grouplabel setText:[NSString stringWithFormat:@"Group: %@", [dict objectForKey:NSFileGroupOwnerAccountName]]];
}
@end
