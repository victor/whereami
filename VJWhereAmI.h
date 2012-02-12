//
//  VJWhereAmI.h
//  whereami
//
//  Created by Victor Jalencas on 17/02/10.
//  Copyright 2010 Victor Jalencas All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

@interface VJWhereAmI : NSObject <CLLocationManagerDelegate> {

	CLLocationManager * manager;
	BOOL locationObtained, errorOccurred;


}
- (void) printLocation;


@end
