CC=arm-apple-darwin-cc
LD=$(CC)
LDFLAGS=-ObjC -framework CoreFoundation -framework Foundation -framework UIKit -framework LayerKit -framework Coregraphics -framework CFNetwork -larmfp
LDFLAGS_FRAMEWORKSDIR=-F/Developer/SDKs/iphone/heavenly/System/Library/

all:			Squid

Squid:			main.o Squid.o
			$(LD) $(LDFLAGS) -o $@ $^
			cp Squid /Volumes/iPhone/Applications/Squid.app/Squid

%.o:			%.m
			$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

clean:
			rm -f *.o Squid

