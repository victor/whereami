#import <Cocoa/Cocoa.h>
#import "VJWhereAmI.h"

int main (int argc, const char * argv[]) {
    @autoreleasepool {

        VJWhereAmI* main = [[VJWhereAmI alloc] init];
	[main printLocation];
	
    }
    return 0;
}
