#import <Cocoa/Cocoa.h>
#import "VJWhereAmI.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    VJWhereAmI* main = [[VJWhereAmI alloc] init];
	[main printLocation];
	[main release];
	
    [pool drain];
    return 0;
}
