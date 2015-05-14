//
//  WhereAmICommand.swift
//  whereami
//
//  Created by Victor Jalencas on 14/12/14.
//  Copyright (c) 2014 Hand Forged. All rights reserved.
//

import Foundation

import CoreLocation


let MaxLocationFixStaleness = 10.0

enum OutputFormat {
    case Json
    case Bare
    case Sexagesimal
}

class WhereAmICommand: Command, CLLocationManagerDelegate {
    var locationObtained = false
    var errorOccurred = false
    var location = CLLocationCoordinate2DMake(0, 0)
    var errorMessage = ""

    var format = OutputFormat.Bare


    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        // the last one will be the most recent
        let updatedLocation = locations.last as! CLLocation;

        // Check is not older than 10 seconds, otherwise discard it
        if (updatedLocation.timestamp.timeIntervalSinceNow < MaxLocationFixStaleness) {
            location = updatedLocation.coordinate;
            locationObtained = true;
            CFRunLoopStop(CFRunLoopGetCurrent());
        }

    }

    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        if (error.domain == kCLErrorDomain) {
            switch (CLError(rawValue: error.code)!) {
            case .LocationUnknown:
                errorMessage = "Could not determine your location. Perhaps your WiFi is disabled?"
            case .Denied:
                errorMessage = "Denied Permission"
            default:
                errorMessage = "Unspecified error"
            }
        }

        errorOccurred = true;
        CFRunLoopStop(CFRunLoopGetCurrent());
    }

    func display(CLLocationCoordinate2D) -> () {
        var outputString: String
        switch (self.format) {
        case .Json:
            outputString = "{\"latitude\":\(location.latitude), \"longitude\": \(location.longitude)}"
        case .Sexagesimal:
            outputString = "\(stringFromDegrees(location.latitude)), \(stringFromDegrees(location.longitude))"
        case .Bare:
            outputString = "\(location.latitude),\(location.longitude)"
        }
        println(outputString);

    }


    // MARK: - Aux function

    func stringFromDegrees(degrees: Double) -> String {

        var deg: Double
        var min: Double
        var sec: Double

        (deg, min) = modf(degrees)
        min = min * 60
        (min, sec) = modf(min)
        sec = sec * 60

        return "\(Int(deg))° \(Int(min))′ \(sec)″"

    }
    // MARK: - Overrides

    override func commandName() -> String {
        return ""
    }

    override func execute() -> ExecutionResult {
        switch CLLocationManager.authorizationStatus() {
        case .Restricted:
            errorMessage = "You don't have permission to use Location Services.";
            errorOccurred = true;
        case .Denied:
            errorMessage = "You denied permission to use Location Services, please enable it in Preferences.";
            errorOccurred = true;
        default:
            if (!CLLocationManager.locationServicesEnabled()) {
                errorMessage = "Location Services are not enabled for this computer, please enable them in Preferences.";
                errorOccurred = true;
            }
        }

        var status: Int32 = 0
        if (!errorOccurred) {

            let manager = CLLocationManager();
            manager.delegate = self;
            manager.startUpdatingLocation();

            status = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 15, 0)
        }

        if (errorOccurred) {
            return failure(errorMessage);
        } else if (status == Int32(kCFRunLoopRunTimedOut)) {
            return failure("Could not get a proper location fix in 15 seconds. Try again perhaps?")
        } else {
            display(location);
        }

        return success();
    }

    override func handleOptions() {
        self.onKey("--format",
            usage:"output format (bare (default), json, sexagesimal)",
            valueSignature: "formatName",
            block: {key, value in
                switch (value) {
                case "json":
                    self.format = .Json
                case "sexagesimal":
                    self.format = .Sexagesimal
                default:
                    self.format = .Bare
                }
        })
    }
}