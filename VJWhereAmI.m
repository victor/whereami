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
		[manager setDelegate:self];
	locationObtained = 0;

	
	
	[manager startUpdatingLocation];
	
	while (locationObtained < 2) {
		CFRunLoopRun();
	}
	[manager release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation  {
	// printf("iteration %d, %s\n",locationObtained,[[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] UTF8String]);
  if (locationObtained < 1) {
    locationObtained++;
    return;
  }
  printf("%s\n",[[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude] UTF8String]);
	locationObtained++;
	CFRunLoopStop(CFRunLoopGetCurrent());
	
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	fprintf(stderr,"%s\n",[[NSString stringWithFormat:@"%@: %@",[error localizedDescription],[error localizedFailureReason]] UTF8String]);
	locationObtained = 100;
	CFRunLoopStop(CFRunLoopGetCurrent());
}


@end
