//
//  VJWhereAmI.m
//  whereami
//
//  Created by Victor Jalencas on 17/02/10.
//  Copyright 2010 Victor Jalencas All rights reserved.
//

#import "VJWhereAmI.h"


@implementation VJWhereAmI

- (void) printLocation {
	manager = [[CLLocationManager alloc] init];
 locationObtained = NO;
	[manager setDelegate:self];
	
	
	
	[manager startUpdatingLocation];
	
	while (!locationObtained) {
		CFRunLoopRun();
	}
	[manager release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation  {
	printf("%s\n",[[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] UTF8String]);
	locationObtained = YES;
	CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
