#import "SquidFileManager.h"

@implementation SquidFileManager 
- (id)initWithFrame:(struct CGRect)frame{
	if ((self == [super initWithFrame: frame]) != nil) {
		UITableColumn *col = [[UITableColumn alloc]
			initWithTitle: @"FileName"
			identifier:@"filename"
			width: frame.size.width
		];
	
		_table = [[UITable alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[_table addTableColumn: col];
		[_table setSeparatorStyle: 1];
		[_table setDelegate: self];
		[_table setDataSource: self];

		NSBundle *bundle = [NSBundle mainBundle];
		
		NSString *fldrpath = [bundle pathForResource:@"fldr" ofType:@"png"];
		_folderIcon = [[UIImage alloc]initWithContentsOfFile:fldrpath];
		
		NSString *flepath = [bundle pathForResource:@"fle" ofType:@"png"];
		_fileIcon = [[UIImage alloc]initWithContentsOfFile:flepath];
		
		_finder = [NSFileManager defaultManager];
		[_finder changeCurrentDirectoryPath:@"/"];

		_delegate = nil;

		[self addSubview: _table];
		[_table reloadData];
	}
	return self;
}

- (void)dealloc {
	[_table release];
	[_folderIcon release];
	[_fileIcon release];
	_delegate = nil;
	[super dealloc];
}

- (void)setDelegate:(id)delegate {
	_delegate = delegate;
}

- (void)changePath:(NSString *)path
{
		[_finder changeCurrentDirectoryPath:path];
		[_table reloadData];
}

- (void)backTrack
{
		NSMutableArray *pc = [[_finder currentDirectoryPath] pathComponents];
		if ( [pc count] > 0 )
		{
			[pc removeLastObject];
			NSString *path = [pc componentsJoinedByString:@"/"];
			
			if ( [path isEqual:@""] )
				return;
			
			if( [_delegate respondsToSelector:@selector( fileManager:doBackTrack: )] )
				[_delegate fileManager:self doBackTrack:path];
		}
}

- (int)numberOfRowsInTable:(UITable *)table {
	return [[_finder directoryContentsAtPath:[_finder currentDirectoryPath]] count] + 1;
}

- (UITableCell *)table:(UITable *)table cellForRow:(int)row column:(UITableColumn *)col {

	UIImageAndTextTableCell *c = [[UIImageAndTextTableCell alloc] init];

	if ( row == 0 )
	{
		[c setTitle:[NSString stringWithFormat:@"%@\n", @" .."]];
	}
	else {
		NSArray *cwd = [_finder directoryContentsAtPath:[_finder currentDirectoryPath]];
		NSDictionary *fa = [_finder fileAttributesAtPath:[NSString stringWithFormat:@"%@/%@", [_finder currentDirectoryPath], [cwd objectAtIndex:row-1]] traverseLink:YES];
		UITextLabel *lbl;
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			[c setImage:_folderIcon];
			lbl = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f, 10.0f, 0.0f, 0.0f)];
			[lbl setText:[NSString stringWithFormat:@"%@\n", [cwd objectAtIndex:row-1]]];
			[c addSubview:lbl];
			[lbl sizeToFit];
		}
		else {
			[c setImage:_fileIcon];
			lbl = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f, 0.0f, 0.0f, 0.0f)];
			[lbl setText:[NSString stringWithFormat:@"%@\n", [cwd objectAtIndex:row-1]]];
			
			UITextLabel *sz = [[UITextLabel alloc] initWithFrame:CGRectMake(45.0f,20.0f,0.0f,0.0f)];
			[sz setText:[NSString stringWithFormat:@"%@ bytes", [fa objectForKey:NSFileSize]]];
			
			[c addSubview:lbl];
			[c addSubview:sz];
			[sz sizeToFit];
			[lbl sizeToFit];
		}
	}
	return c;
}

- (void)tableRowSelected:(NSNotification *)notification {

	int row = [_table selectedRow];

	NSArray *cwd = [_finder directoryContentsAtPath:[_finder currentDirectoryPath]];

	if ( row == 0 )
	{
		[self backTrack];
	}
	else {
		NSString *path = [NSString stringWithFormat:@"%@/%@", [_finder currentDirectoryPath], [cwd objectAtIndex:row-1]];
		NSDictionary *fa = [_finder fileAttributesAtPath:path traverseLink:YES];
		if ( [[fa objectForKey:NSFileType] isEqualToString:@"NSFileTypeDirectory"] )
		{
			if( [_delegate respondsToSelector:@selector( fileManager:folderSelected:attrs: )] )
				[_delegate fileManager:self folderSelected:path attrs:fa];
		}
		else {
			if( [_delegate respondsToSelector:@selector( fileManager:fileSelected:attrs: )] )
				[_delegate fileManager:self fileSelected:path attrs:fa];
		}
	}
}
@end
