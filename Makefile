CC=/usr/local/bin/arm-apple-darwin-cc
LD=$(CC)
LDFLAGS	=	-ObjC -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit \
		-framework Coregraphics -framework CFNetwork -larmfp

LDFLAGS_FRAMEWORKSDIR=-F/Developer/SDKs/iphone/heavenly/System/Library/

all:			Squid

Squid:			main.o squid.o SquidFileManager.o SquidAttrViewer.o SquidNavItem.o UITextLabelSubclass.o
			$(LD) $(LDFLAGS) -o $@ $^

%.o:			%.m
			$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

install:		
			cp Squid /Volumes/iPhone/Applications/Squid.app/Squid

clean:
			rm -f *.o Squid

